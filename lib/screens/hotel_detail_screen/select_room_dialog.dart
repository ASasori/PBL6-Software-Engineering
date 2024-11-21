import 'package:booking_hotel_app/models/room.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/booking.dart';
import '../../models/hotel_list_data.dart';
import '../../providers/wish_list_provider.dart';

class SelectRoomDialog extends StatefulWidget {
  final RoomType roomTypeData ;
  final DateTime startDate,endDate;
  const SelectRoomDialog({Key? key, required this.roomTypeData, required this.startDate, required this.endDate}) : super(key: key);

  @override
  _SelectRoomDialogState createState() => _SelectRoomDialogState();
}
class _SelectRoomDialogState extends State<SelectRoomDialog> {
  String? selectedRoom;
  List<String> rooms = ['room1', 'room2', 'room3']; // Replace with your actual room data

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
          child: DropdownButton<String>(
            value: selectedRoom,
            padding: EdgeInsets.only(left: 10),
            hint: Text('Select a room'),
            isExpanded: true,
            icon: Icon(Icons.arrow_drop_down),
            style: TextStyle(fontSize: 16, color: Colors.black),
            items: rooms.map((String room) {
              return DropdownMenuItem<String>(
                value: room,
                child: Text(room),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                selectedRoom = newValue;
              });
            },
          ),
        ),
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
              onPressed:() {
                if (selectedRoom != null) {
                  // Access the roomData from RoomBookView using a callback
                  final roomtypeData = widget.roomTypeData;

                  if (roomtypeData != null) {
                    BookingData value = new BookingData(
                      bookingID: "B003",
                      hotelName: roomtypeData.type,
                      imagePath: roomtypeData.imageUrl,
                      // address: roomData.location.toString(),
                      startDate: widget.startDate, // Assuming dateTxt is a DateTime
                      endDate: widget.endDate, // Assuming dateTxt is a DateTime
                      numberOfAdults: 3,
                      numberOfChildren: 2,
                      pricePernight: roomtypeData.price.toDouble(),
                      typeRoom: selectedRoom!, // Set the selected room
                      totalAmount: widget.endDate.difference(widget.startDate).inDays * widget.roomTypeData.price.toDouble(),
                    );
                    print("add");
                    wishlist.addBookingData(value);
                    wishlist.addTotalPrice(value.totalAmount);
                    wishlist.addCounter();
                    // Show SnackBar when product is added to the cart
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Row(
                          children: [
                            Icon(Icons.check_circle, color: Colors.green), // Add an icon
                            SizedBox(width: 10), // Space between icon and text
                            Expanded(child: Text('Product added to cart!')), // Message text
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