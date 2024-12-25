import 'package:booking_hotel_app/providers/auth_provider.dart';
import 'package:booking_hotel_app/providers/booking_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/hotel_list_data.dart';
import '../../routes/route_names.dart';
import '../../utils/text_styles.dart';
import 'hotel_list_view.dart';
import 'hotel_list_view_data.dart';

class UpcomingListView extends StatefulWidget {
  final AnimationController animationController;

  const UpcomingListView({Key? key, required this.animationController})
      : super(key: key);

  @override
  _UpcomingListViewState createState() => _UpcomingListViewState();
}

class _UpcomingListViewState extends State<UpcomingListView> {
  // var hotelList = HotelListData.hotelList;

  @override
  void initState() {
    widget.animationController.forward();
    WidgetsBinding.instance.addPostFrameCallback((_) async{
      Provider.of<BookingProvider>(context, listen: false).resetMyBooking();
      await Provider.of<BookingProvider>(context, listen: false).getMyBookings();
      await Provider.of<AuthProvider>(context, listen: false).fetchProfile();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bookingProvider = Provider.of<BookingProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    return (bookingProvider.myUpcomingBookings.isEmpty)
        ? Center(
            child: Text(
              "No upcoming booking!",
              style: TextStyles(context).getRegularStyle(),
            ),
          )
        : SizedBox(
            child: ListView.builder(
              itemCount: bookingProvider.myUpcomingBookings.length,
              padding: const EdgeInsets.only(top: 8, bottom: 16),
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                var count = bookingProvider.myUpcomingBookings.length > 10
                    ? 10
                    : bookingProvider.myUpcomingBookings.length;
                var animation = Tween(begin: 0.0, end: 1.0).animate(
                    CurvedAnimation(
                        parent: widget.animationController,
                        curve: Interval((1 / count) * index, 1.0,
                            curve: Curves.fastOutSlowIn)));
                widget.animationController.forward();

                return HotelListViewData(
                  callback: () {
                    // NavigationServices(context)
                    //     .gotoRoomBookingScreen(hotelList[index].titleTxt);
                  },
                  myBooking: bookingProvider.myUpcomingBookings[index],
                  myProfile: authProvider.profile,
                  animation: animation,
                  animationController: widget.animationController,
                  isShowDate: (index % 2) != 0,
                );
              },
            ),
          );
  }
}
