import 'package:booking_hotel_app/models/hotel_list_data.dart';
import 'package:booking_hotel_app/screens/home_screen/category_view.dart';
import 'package:booking_hotel_app/routes/route_names.dart';
import 'package:booking_hotel_app/widgets/bottom_top_move_animation_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/hotel_provider.dart';

class PopularListView extends StatefulWidget {
  final Function(int) callBack;
  final AnimationController animationController;
  const PopularListView({super.key, required this.callBack, required this.animationController});

  @override
  State<PopularListView> createState() => _PopularListViewState();
}

class _PopularListViewState extends State<PopularListView> with TickerProviderStateMixin {
  AnimationController? animationController;

  @override
  void initState() {
    animationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1000)
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final hotelProvider = Provider.of<HotelProvider>(context, listen: false).fetchLocations();
    });
    super.initState();
  }

  Future<bool> getData() async {
    await Future.delayed(Duration(milliseconds: 50));
    return true;
  }

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return BottomTopMoveAnimationView(
        animationController: animationController!,
        child: Container(
          height: 180,
          width: double.infinity,
          child: Consumer<HotelProvider> (
            builder: (context, hotelProvider, child) {
              if (hotelProvider.isLoading){
                return const Center (child: CircularProgressIndicator());
              }
              var locations = hotelProvider.locations;
              if (locations.isEmpty){
                return Center(child: Text('No locations is available'),);
              }
              return FutureBuilder(
                  future: getData(),
                  builder: (context, snapshot){
                    if (!snapshot.hasData) {
                      return SizedBox();
                    } else {
                      return ListView.builder(
                        padding: EdgeInsets.only(top: 0, bottom: 0, right: 24, left: 8),
                        itemCount: locations.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          var count = locations.length;
                          var animation = Tween(begin: 0.0, end: 1.0).animate(
                              CurvedAnimation(
                                  parent: animationController!,
                                  curve: Interval(( 1 / count) * index, 1.0, curve: Curves.fastOutSlowIn)
                              ),
                          );
                          animationController?.forward();
                          // Population animation photo and text view
                          return CategoryView(
                            porpularLocation: locations[index],
                            animationController: animationController!,
                            animation: animation,
                            callback: () {
                              widget.callBack(index);
                         //     NavigationServices(context).gotoHotelHomeScreen(locations[index].location);
                            }
                          );
                        }
                      );
                    }
                  }
              );
            }
          )
        )
    );
  }
}
