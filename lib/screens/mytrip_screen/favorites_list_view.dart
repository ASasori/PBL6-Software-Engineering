import 'package:flutter/material.dart';

import '../../models/hotel_list_data.dart';
import '../../routes/route_names.dart';
import '../home_screen/hotel_list_view.dart';

class FavoritesListView extends StatefulWidget {
  final AnimationController animationController;

  const FavoritesListView({Key? key, required this.animationController})
      : super(key: key);
  @override
  _FavoritesListViewState createState() => _FavoritesListViewState();
}

class _FavoritesListViewState extends State<FavoritesListView> {
  var hotelList = HotelListData.hotelList;

  @override
  void initState() {
    widget.animationController.forward();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        itemCount: hotelList.length,
        padding: EdgeInsets.only(top: 8, bottom: 8),
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) {
          var count = hotelList.length > 10 ? 10 : hotelList.length;
          var animation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
              parent: widget.animationController,
              curve: Interval((1 / count) * index, 1.0,
                  curve: Curves.fastOutSlowIn)));
          widget.animationController.forward();
          //Favorites hotel data list and UI View
          // return HotelListView(
          //   callback: () {
          //     NavigationServices(context)
          //         .gotoRoomBookingScreen(hotelList[index].titleTxt);
          //   },
          //   hotelListData: hotelList[index],
          //   animation: animation,
          //   animationController: widget.animationController,
          // );
          return Text('Fixing services, update later');
        },
      ),
    );
  }
}