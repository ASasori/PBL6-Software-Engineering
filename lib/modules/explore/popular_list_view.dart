import 'package:booking_hotel_app/models/hotel_list_data.dart';
import 'package:booking_hotel_app/modules/explore/category_view.dart';
import 'package:booking_hotel_app/routes/route_names.dart';
import 'package:booking_hotel_app/widgets/bottom_top_move_animation_view.dart';
import 'package:flutter/material.dart';

class PopularListView extends StatefulWidget {
  final Function(int) callBack;
  final AnimationController animationController;
  const PopularListView({super.key, required this.callBack, required this.animationController});

  @override
  State<PopularListView> createState() => _PopularListViewState();
}

class _PopularListViewState extends State<PopularListView> with TickerProviderStateMixin {
  var popularList = HotelListData.popularList;
  AnimationController? animationController;

  @override
  void initState() {
    animationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1000)
    );
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
          child: Container(
            height: 180,
            width: double.infinity,
            child: FutureBuilder(
                future: getData(),
                builder: (context, snapshot){
                  if (!snapshot.hasData) {
                    return SizedBox();
                  } else {
                    return ListView.builder(
                      padding: EdgeInsets.only(top: 0, bottom: 0, right: 24, left: 8),
                      itemCount: popularList.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        var count = popularList.length;
                        var animation = Tween(begin: 0.0, end: 1.0).animate(
                            CurvedAnimation(
                                parent: animationController!,
                                curve: Interval(( 1 / count) * index, 1.0, curve: Curves.fastOutSlowIn)
                            ),
                        );
                        animationController?.forward();
                        // Population animation photo and text view
                        return CategoryView(
                          popularList: popularList[index],
                          animationController: animationController!,
                          animation: animation,
                          callback: () {
                            widget.callBack(index);
                            NavigationServices(context).gotoHotelHomeScreen(popularList[index].titleTxt);
                          } 
                        );
                      }
                    );
                  }
                }
            ),
          )
        )
    );
  }
}
