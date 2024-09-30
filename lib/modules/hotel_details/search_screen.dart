import 'package:booking_hotel_app/language/appLocalizations.dart';
import 'package:booking_hotel_app/models/hotel_list_data.dart';
import 'package:booking_hotel_app/modules/hotel_details/search_type_list_view.dart';
import 'package:booking_hotel_app/modules/hotel_details/search_view.dart';
import 'package:booking_hotel_app/utils/themes.dart';
import 'package:booking_hotel_app/widgets/common_appbar_view.dart';
import 'package:booking_hotel_app/widgets/common_card.dart';
import 'package:booking_hotel_app/widgets/common_search_bar.dart';
import 'package:booking_hotel_app/widgets/remove_focuse.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> with TickerProviderStateMixin {
  List<HotelListData> lastsSearchList = HotelListData.lastsSearchesList;
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
    return Scaffold(
      backgroundColor: AppTheme.scaffoldBackgroundColor,
      body: RemoveFocuse(
        onclick: (){
            FocusScope.of(context).requestFocus(FocusNode());
          },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CommonAppbarView(
              iconData: Icons.close,
              titleText: AppLocalizations(context).of("search_hotel"),
              onBackClick: (){
                Navigator.pop(context);
              }
            ),
            Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left:24, right: 24, top:16, bottom: 16),
                        child: CommonCard(
                          radius: 36,
                          color: AppTheme.backgroundColor,
                          child: CommonSearchBar(
                            textEditingController: myController,
                            iconData: FontAwesomeIcons.search,
                            enabled: true,
                            text: AppLocalizations(context).of("where_are_you_going"),
                          ),
                        ),
                      ),
                      SearchTypeListView(),
                      Padding(
                        padding: EdgeInsets.only(left: 24,right: 24,top: 8),
                        child: Row(
                          children: [
                            Expanded(
                                child: Text(
                                  AppLocalizations(context).of("Last_search"),
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    letterSpacing: 0.5
                                  ),
                                )
                            ),
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.all(Radius.circular(4.0)),
                                onTap: () {
                                  setState(() {
                                    myController.text = "";
                                  });
                                },
                                child: Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Row(
                                    children: [
                                      Text(
                                        AppLocalizations(context).of("clear_all"),
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                          color: Theme.of(context).primaryColor
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                
                              ),
                            )
                          ],
                        ),
                      )
                    ] +
                    getPList(myController.text.toString()) +
                    [
                      SizedBox(
                        height: MediaQuery.of(context).padding.bottom + 16,
                      )
                    ]

                  ),
                )
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> getPList(String searchValue) {
    List<Widget> noList = [];
    var count = 0;
    final columnCount = 2;
    List<HotelListData> curList = lastsSearchList.where((element) => element.titleTxt.toLowerCase().contains(searchValue.toLowerCase())).toList();
    for (var i = 0; i < curList.length / columnCount; i++){
      List<Widget> listUI = [];
      for (var j = 0; j < columnCount; j++){
        try {
          final data = curList[count];
          var animation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
              parent: animationController,
              curve: Interval((1 / curList.length) * count, 1.0,  curve: Curves.fastOutSlowIn)
          ));
          animationController.forward();
          listUI.add(Expanded(child: SearchView(
              hotelInfo: data,
              animationController: animationController,
              animation: animation))
          );
          count +=1;
        } catch (e) {};
      }
      noList.add(Padding(
        padding: EdgeInsets.only(left: 16, right: 16),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: listUI
        ),
      ));
    }
    return noList;
  }
}
