import 'dart:convert';

import 'package:booking_hotel_app/language/appLocalizations.dart';
import 'package:booking_hotel_app/widgets/common_card.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../models/hotel_list_data.dart';

class SearchTypeListView extends StatefulWidget {
  const SearchTypeListView({super.key});

  @override
  State<SearchTypeListView> createState() => _SearchTypeListViewState();
}

class _SearchTypeListViewState extends State<SearchTypeListView> with TickerProviderStateMixin{
  List<HotelListData> hotelTypeList = HotelListData.hotelTypeList;
  late AnimationController animationController;
  final myController = TextEditingController();

  @override
  void initState() {
    animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 2000));

    super.initState();
  }
  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height*0.2,
      child: ListView.builder(
        padding: EdgeInsets.only(top: 0, right: 16, left: 16),
        itemCount: hotelTypeList.length,
        scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            var count = hotelTypeList.length;
            var animation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
                parent: animationController,
                curve: Interval((1 / count) * index, 1.0)
              ));
            animationController.forward();
            return AnimatedBuilder(
                animation: animationController,
                builder: (BuildContext context, Widget? child){
                  return FadeTransition(
                    opacity: animation,
                    child: Transform(
                      transform: Matrix4.translationValues(50 * (1.0 - animation.value), 0.0, 0.0),
                      child: Padding(
                        padding: EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0, top: 0),
                        child: Column(
                          children: [
                            Stack(
                              children: [
                                Container(
                                  width:  MediaQuery.of(context).size.width*0.2,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor,
                                    borderRadius: BorderRadius.all(Radius.circular( MediaQuery.of(context).size.width*0.2)),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Theme.of(context).dividerColor,
                                        blurRadius: 8,
                                        offset: Offset(4,4)
                                      ),
                                    ]
                                  ),
                                  child: ClipRRect(
                                    borderRadius:  BorderRadius.all(Radius.circular( MediaQuery.of(context).size.width*0.2)),
                                    child: AspectRatio(
                                      aspectRatio: 1,
                                      child: Image.asset(hotelTypeList[index].imagePath, fit: BoxFit.cover,),
                                    ),
                                  ),
                                ),
                              Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.all(Radius.circular(MediaQuery.of(context).size.width*0.2)),
                                  highlightColor: Colors.transparent,
                                  splashColor: Theme.of(context).primaryColor.withOpacity(0.4),
                                  onTap: () {
                                    setState(() {
                                      hotelTypeList[index].isSelected = !hotelTypeList[index].isSelected;
                                    });
                                  },
                                  child: Opacity(
                                    opacity: hotelTypeList[index].isSelected ? 1.0 : 0.0,
                                    child: CommonCard(
                                      color: Theme.of(context).primaryColor.withOpacity(0.4),
                                      radius: 48,
                                      child: SizedBox(
                                        height: MediaQuery.of(context).size.width * 0.2,
                                        width: MediaQuery.of(context).size.width * 0.2,
                                        child: Center(
                                          child: Icon(
                                            FontAwesomeIcons.check,
                                            color: Theme.of(context).scaffoldBackgroundColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 4),
                              child: Text(
                                AppLocalizations(context).of(hotelTypeList[index].titleTxt),
                                maxLines: 2,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }
            );
          }
      ),
    );
  }
}
