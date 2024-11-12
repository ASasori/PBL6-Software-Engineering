import 'package:booking_hotel_app/models/hotel_list_data.dart';
import 'package:booking_hotel_app/providers/wish_list_provider.dart';
import 'package:booking_hotel_app/screens/bottom_tab/bottom_tab_screen.dart';
import 'package:booking_hotel_app/screens/explore_screen/components/time_date_view.dart';
import 'package:booking_hotel_app/screens/hotel_detail_screen/room_booking_view.dart';
import 'package:booking_hotel_app/screens/wishlist_screen/wishlist_screen.dart';
import 'package:booking_hotel_app/widgets/common_button.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:provider/provider.dart';
import '../../models/hotel.dart';
import '../../providers/room_provider.dart';
import '../../utils/enum.dart';
import '../../utils/text_styles.dart';

class RoomBookingScreen extends StatefulWidget {
  final Hotel hotelBooking;

  const RoomBookingScreen({super.key, required this.hotelBooking});

  @override
  State<RoomBookingScreen> createState() => _RoomBookingScreenState();
}

class _RoomBookingScreenState extends State<RoomBookingScreen> with TickerProviderStateMixin{
  List<HotelListData> romeList = HotelListData.romeList;

  late AnimationController animationController;

  DateTime? startDate = DateTime.now(); // Store selected start date
  DateTime? endDate =  DateTime.now().add(Duration(days: 5)) ;// Store selected end date

  @override
  void initState() {
    animationController = AnimationController(
        duration: Duration(milliseconds: 2000), vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_){
      Provider.of<RoomProvider>(context, listen: false).getRoomList(widget.hotelBooking.slug);
    });

    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          getAppBarUI(context,animationController),
          TimeDateView(
            onDateChanged: (selectedStartDate, selectedEndDate) {
              setState(() {
                startDate = selectedStartDate;
                endDate = selectedEndDate;
              });
            },
          ),
          CommonButton(
            padding: EdgeInsets.only(top: 8, bottom: 24),
            buttonText: "Check Availability",
          ),
          Divider(
            height: 1,
          ),
          // Padding(
          //   padding: const EdgeInsets.only(top: 8, bottom: 16),
          //   child: Text(
          //     "All room  available",
          //     style: TextStyles(context).getRegularStyle(),
          //   ),
          // ),
          Expanded(
            child: Consumer <RoomProvider> (
                builder: (context,roomProvider, child) {
                return ListView.builder(
                  padding: EdgeInsets.all(0.0),
                  itemCount: roomProvider.rooms.length,
                  itemBuilder: (context, index) {
                    var count = roomProvider.rooms.length > 10 ? 10 : roomProvider.rooms.length;
                    var animation = Tween(begin: 0.0, end: 1.0).animate(
                        CurvedAnimation(
                            parent: animationController,
                            curve: Interval((1 / count) * index, 1.0,
                                curve: Curves.fastOutSlowIn)));
                    animationController.forward();
                    //room book view and room data
                    return RoomBookView(
                      roomData: roomProvider.rooms[index],
                      animation: animation,
                      animationController: animationController,
                      startDate: startDate!,
                      endDate:  endDate!,
                    );
                  },
                );
              }
            )
          ),
        ],
      ),
    );
  }

  Widget getAppBarUI(BuildContext context, AnimationController animationController) {
    return Padding(
      padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top,
          left: 16,
          right: 16,
          bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.all(
                Radius.circular(32.0),
              ),
              onTap: () {
                Navigator.pop(context);
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(Icons.arrow_back),
              ),
            ),
          ),
          //   ),
          Expanded(
            child: Center(
              child: Text(
                widget.hotelBooking.name,
                style: TextStyles(context).getTitleStyle(),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          badges.Badge(
            badgeContent: Consumer<WishlistProvider>(
              builder: (context, value, child) {
                return Text(
                  value.getCounter().toString(),
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                );
              },
            ),
            //position: badges.BadgePosition(start: 30, bottom: 30),

            child: IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => BottomTabScreen(initialBottomBarType: BottomBarType.Wishlist)));
              },
              icon: const Icon(Icons.shopping_cart),
            ),
          ),
          //   )
        ],
      ),
    );
    // );
  }
}
