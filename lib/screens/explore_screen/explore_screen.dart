import 'package:booking_hotel_app/models/hotel_list_data.dart';
import 'package:booking_hotel_app/screens/mytrip_screen/hotel_list_view.dart';
import 'package:booking_hotel_app/utils/themes.dart';
import 'package:booking_hotel_app/widgets/remove_focuse.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../language/appLocalizations.dart';
import '../../routes/route_names.dart';
import '../../utils/text_styles.dart';
import '../../widgets/common_card.dart';
import '../../widgets/common_search_bar.dart';
import 'components/filter_bar_UI.dart';
import 'components/time_date_view.dart';

class ExploreScreen extends StatefulWidget {
  final String placeName ;
  const ExploreScreen({super.key, this.placeName = ""});

  @override
  State<ExploreScreen> createState() => _HotelHomeScreenState();
}

class _HotelHomeScreenState extends State<ExploreScreen> with TickerProviderStateMixin{
  late AnimationController animationController;
  late AnimationController _animationController;

  TextEditingController placeNameController = TextEditingController();
  TextEditingController HotelNameController = TextEditingController();

  var hotelList = HotelListData.hotelList;
  ScrollController scrollController = new ScrollController();

  int room = 1;
  int add = 2;

  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now().add(Duration(days: 5));

  bool _isShowMap = false;

  final searchBarHeight = 158.0;
  final filterBarHeight = 52.0;

  @override
  void initState() {
    animationController = AnimationController(
        duration: Duration(milliseconds: 1000), vsync: this);
    _animationController =
        AnimationController(duration: Duration(milliseconds: 0), vsync: this);
    scrollController.addListener(() {
      if (scrollController.offset <= 0) {
        _animationController.animateTo(0.0);
      } else if (scrollController.offset > 0.0 &&
          scrollController.offset < searchBarHeight) {
        // we need around searchBarHieght scrolling values in 0.0 to 1.0
        _animationController
            .animateTo((scrollController.offset / searchBarHeight));
      } else {
        _animationController.animateTo(1.0);
      }
    });
    placeNameController.text = widget.placeName;
    super.initState();
  }

  Future<bool> getData() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return true;
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
          children: [
            RemoveFocuse(
              onclick: () {
                FocusScope.of(context).requestFocus(FocusNode());
              },
              child: Column(
                children: [
                  _getAppBarUI(),
                  Expanded(
                      child: Stack(
                        children: [
                          Container(
                            color: AppTheme.scaffoldBackgroundColor,
                            child: ListView.builder(
                              controller: scrollController,
                              itemCount: hotelList.length,
                              padding: EdgeInsets.only(
                                top: 8 + 158 + 52.0
                              ),
                              scrollDirection: Axis.vertical,
                              itemBuilder: (context, index) {
                                var count = hotelList.length > 10 ? 10 : hotelList.length;
                                var animation = Tween(begin: 0.0, end: 1.0)
                                    .animate(CurvedAnimation(
                                    parent: animationController,
                                    curve: Interval(
                                        (1 / count) * index, 1.0,
                                        curve: Curves.fastOutSlowIn)));
                                animationController.forward();
                                return HotelListView(
                                    hotelData: hotelList[index],
                                    animationController: animationController,
                                    animation: animation,
                                    callback: () {
                                      NavigationServices(context).gotoHotelDetails(hotelList[index]);
                                    }
                                );
                              },
                            ),
                          ),
                          AnimatedBuilder(
                            animation: _animationController,
                            builder: (BuildContext context, Widget? child) {
                              return Positioned(
                                top: -searchBarHeight *
                                    (_animationController.value),
                                left: 0,
                                right: 0,
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      color: Theme.of(context)
                                          .scaffoldBackgroundColor,
                                      child: Column(
                                        children: <Widget>[
                                          //hotel search view
                                          _getSearchBarUI(),
                                          // time date and number of rooms view
                                          TimeDateView(),
                                        ],
                                      ),
                                    ),
                                    //hotel price & facilitate  & distance
                                    FilterBarUI(),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      )
                  )
                ],
              ),
            )
          ],
        ),
    );
  }

  Widget _getSearchBarUI() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
      child: Column(
        children: [
          Row(
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding:
                  const EdgeInsets.only(right: 8, top: 8, bottom: 8, left: 8),
                  child: CommonCard(
                    color: AppTheme.backgroundColor,
                    radius: 36,
                    child: CommonSearchBar(
                      textEditingController: HotelNameController ,
                      enabled: true,
                      isShow: false,
                      text: "Hotel name ",
                    ),
                  ),
                ),
              ),

              CommonCard(
                color: AppTheme.primaryColor,
                radius: 36,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {

                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Icon(FontAwesomeIcons.search,
                          size: 20, color: AppTheme.backgroundColor),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding:
                  const EdgeInsets.only(right: 8, top: 8, bottom: 8, left: 8),
                  child: CommonCard(
                    color: AppTheme.backgroundColor,
                    radius: 36,
                    child: CommonSearchBar(
                      textEditingController: placeNameController ,
                      enabled: true,
                      isShow: false,
                      text: "Country",
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _getAppBarUI() {
    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top, left: 8, right: 8),
      child:Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            width: AppBar().preferredSize.height ,
            height: AppBar().preferredSize.height,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.all(Radius.circular(32.0)),
                onTap: () {
                  Navigator.pop(context);
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(Icons.arrow_back),
                ),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                AppLocalizations(context).of("explore"),
                style: TextStyles(context).getTitleStyle(),
              ),
            ),
          ),
          Container(
            width: AppBar().preferredSize.height + 40,
            height: AppBar().preferredSize.height,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.all(
                      Radius.circular(32.0),
                    ),
                    onTap: () {},
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(Icons.favorite_border),
                    ),
                  ),
                ),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.all(
                      Radius.circular(32.0),
                    ),
                    onTap: () {
                      setState(() {
                        _isShowMap = !_isShowMap;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(_isShowMap
                          ? Icons.sort
                          : FontAwesomeIcons.mapMarkedAlt),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
