import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/hotel_list_data.dart';
import '../../providers/auth_provider.dart';
import '../../providers/booking_provider.dart';
import '../../routes/route_names.dart';
import '../../utils/text_styles.dart';
import 'hotel_list_view_data.dart';

class FinishTripView extends StatefulWidget {
  final AnimationController animationController;

  const FinishTripView({Key? key, required this.animationController})
      : super(key: key);

  @override
  _FinishTripViewState createState() => _FinishTripViewState();
}

class _FinishTripViewState extends State<FinishTripView> {
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
    return (bookingProvider.myFinishedBookings.isEmpty)
        ? Center(
            child: Text(
              "No finished booking!",
              style: TextStyles(context).getRegularStyle(),
            ),
          )
        : SizedBox(
            child: ListView.builder(
              itemCount: bookingProvider.myFinishedBookings.length,
              padding: EdgeInsets.only(top: 8, bottom: 16),
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                var count = bookingProvider.myFinishedBookings.length > 10
                    ? 10
                    : bookingProvider.myFinishedBookings.length;
                var animation = Tween(begin: 0.0, end: 1.0).animate(
                    CurvedAnimation(
                        parent: widget.animationController,
                        curve: Interval((1 / count) * index, 1.0,
                            curve: Curves.fastOutSlowIn)));
                widget.animationController.forward();
                return HotelListViewData(
                  callback: () {
                    // NavigationServices(context)
                    //     .gotoRoomBookingScreen(hotelList[index]);
                  },
                  myBooking: bookingProvider.myFinishedBookings[index],
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
