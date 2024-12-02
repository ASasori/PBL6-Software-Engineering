import 'package:booking_hotel_app/models/room.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/booking.dart';
import '../../models/hotel_list_data.dart';
import '../../models/room_data.dart';
import '../../providers/booking_provider.dart';
import '../../providers/room_provider.dart';
import '../../providers/wish_list_provider.dart';

class SelectRoomDialog extends StatefulWidget {
  final RoomType roomTypeData ;
  final String hotelSlug;
  final DateTime startDate,endDate;
  final RoomData roomData;
  const SelectRoomDialog({Key? key, required this.roomTypeData, required this.hotelSlug, required this.startDate, required this.endDate, required this.roomData}) : super(key: key);

  @override
  _SelectRoomDialogState createState() => _SelectRoomDialogState();
}
class _SelectRoomDialogState extends State<SelectRoomDialog> {
  Map<String, dynamic>? selectedRoom; // Lưu roomId và roomNumber
  List<Map<String, dynamic>> rooms = [];

  @override
  void initState (){
    WidgetsBinding.instance.addPostFrameCallback((_){
      Provider.of<RoomProvider>(context, listen: false).getRoomsInRoomtype(widget.hotelSlug, widget.roomTypeData).then((_){
        setState(() {
          rooms = Provider.of<RoomProvider>(context, listen: false)
              .allRoomsInRoomType
              .map((room) => {
            'roomId': room.roomId,
            'roomNumber': room.roomNumber,
          })
              .toList();
        });
      });
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    var wishlist = Provider.of<WishlistProvider>(context); // Access wishlist provider
    return AlertDialog(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select Room',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          SizedBox(height: 8),
          Text(
            'Room type: ${widget.roomTypeData.type}', // Display TypeRoom here
            style: TextStyle(fontSize: 14, color: Colors.grey),
          )
        ],
      ),
      content: Container(
        width: double.maxFinite, // Make dropdown take full width
        padding: EdgeInsets.symmetric(vertical: 10), //Add padding
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black), // Add border
          borderRadius: BorderRadius.circular(8), // Add rounded corners
        ),
        child: DropdownButtonHideUnderline(
          child: rooms.isEmpty? Center(child: CircularProgressIndicator(),)
            : DropdownButton<Map<String, dynamic>>(
                value: selectedRoom,
                padding: EdgeInsets.only(left: 10),
                hint: Text('Select a room'),
                isExpanded: true,
                icon: Icon(Icons.arrow_drop_down),
                style: TextStyle(fontSize: 16, color: Colors.black),
                items: rooms.map((Map<String, dynamic> room) {
                  return DropdownMenuItem<Map<String, dynamic>>(
                    value: room,
                    child: Text(room['roomNumber']),
                  );
                }).toList(),
                onChanged: (Map<String, dynamic>? newValue) {
                  setState(() {
                    selectedRoom = newValue;
                  });
                },
              ),
        )
    ),
      actions: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: Text('Add to Wishlist'),
              onPressed:() async {
                if (selectedRoom != null) {
                  final roomtypeData = widget.roomTypeData;

                  if (roomtypeData != null) {
                    final bookingProvider = Provider.of<BookingProvider>(context, listen: false);
                    final errorMessage = await bookingProvider.addCartItem(selectedRoom!['roomId'], widget.startDate, widget.endDate,
                        widget.roomData.adult, widget.roomData.children);

                    wishlist.addTotalPrice(value.totalAmount);
                    wishlist.addCounter();

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Row(
                          children: [
                            errorMessage == null ? Icon(Icons.check_circle, color: Colors.green)
                                : Icon(Icons.error_outline, color: Colors.red,), // Add an icon
                            SizedBox(width: 10), // Space between icon and text
                            Expanded(
                              child: Text(
                                errorMessage ?? 'Room successfully added to wishlist!',
                                style: TextStyle(fontSize: 16),
                              ),
                            ), // Message text
                          ],
                        ),
                        backgroundColor: Colors.black87, // Darker background for better contrast
                        duration: Duration(seconds: 3), // Duration of the SnackBar
                        behavior: SnackBarBehavior.floating, // Makes it float above the content
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ), // Rounded corners for better appearance
                        margin: EdgeInsets.all(16), // Adds some space around the SnackBar
                      ),
                    );
                  }
                  Navigator.of(context).pop(); // Close the dialog
                }
              },
            ),
          ],
        )
      ],
    );}
}