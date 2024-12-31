import 'package:booking_hotel_app/screens/mytrip_screen/hotel_list_view.dart';
import 'package:booking_hotel_app/utils/themes.dart';
import 'package:booking_hotel_app/widgets/common_button.dart';
import 'package:booking_hotel_app/widgets/remove_focuse.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../../language/appLocalizations.dart';
import '../../providers/hotel_provider.dart';
import '../../routes/route_names.dart';
import '../../utils/text_styles.dart';
import '../../widgets/common_card.dart';
import '../../widgets/common_search_bar.dart';
import 'components/filter_bar_UI.dart';

class ExploreScreen extends StatefulWidget {
  final String placeName;

  const ExploreScreen({super.key, this.placeName = ""});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen>
    with TickerProviderStateMixin {
  late AnimationController animationController;
  late AnimationController _animationController;

  TextEditingController placeNameController = TextEditingController();
  TextEditingController hotelNameController = TextEditingController();

  ScrollController scrollController = new ScrollController();

  bool _isShowMap = false;

  final searchBarHeight = 190.0;
  final filterBarHeight = 52.0;

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    _animationController =
        AnimationController(duration: Duration(milliseconds: 0), vsync: this);
    scrollController.addListener(() {
      if (scrollController.offset <= 0) {
        _animationController.animateTo(0.0);
      } else if (scrollController.offset > 0.0 &&
          scrollController.offset < searchBarHeight) {
        _animationController
            .animateTo((scrollController.offset / searchBarHeight));
      } else {
        _animationController.animateTo(1.0);
      }
    });
    placeNameController.text = widget.placeName;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<HotelProvider>(context, listen: false).fetchHotelsByLocation(
          widget.placeName, hotelNameController.text.trim(), "", "");
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
      body: Stack(
        children: [
          RemoveFocuse(
            onclick: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: Consumer<HotelProvider>(
              builder: (context, hotelProvider, child) {
                return Column(
                  children: [
                    _getAppBarUI(),
                    Expanded(
                      child: Stack(
                        children: [
                          if (hotelProvider.isLoading)
                            const Center(child: CircularProgressIndicator())
                          else if (hotelProvider.hotelsByLocation.isEmpty)
                            const Center(child: Text('No hotels found'))
                          else
                            ListView.builder(
                              controller: scrollController,
                              itemCount: hotelProvider.hotelsByLocation.length,
                              padding:
                                  const EdgeInsets.only(top: 8 + 190 + 52.0),
                              scrollDirection: Axis.vertical,
                              itemBuilder: (context, index) {
                                var count =
                                    hotelProvider.hotelsByLocation.length > 10
                                        ? 10
                                        : hotelProvider.hotelsByLocation.length;
                                var animation = Tween(begin: 0.0, end: 1.0)
                                    .animate(CurvedAnimation(
                                        parent: animationController,
                                        curve: Interval(
                                            (1 / count) * index, 1.0,
                                            curve: Curves.fastOutSlowIn)));
                                animationController.forward();
                                var hotel =
                                    hotelProvider.hotelsByLocation[index];
                                return HotelListView(
                                  hotelByLocation: hotel,
                                  animationController: animationController,
                                  animation: animation,
                                  callback: () {
                                    NavigationServices(context)
                                        .gotoHotelDetails(hotelProvider
                                            .hotelsByLocation[index]);
                                  },
                                );
                              },
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
                                  children: [
                                    Container(
                                      color: Theme.of(context)
                                          .scaffoldBackgroundColor,
                                      child: _getSearchBarUI(hotelProvider),
                                    ),
                                    FilterBarUi(
                                      hotelListData:
                                          hotelProvider.hotelsByLocation,
                                      onFilterChanged:
                                          (RangeValues values) async {
                                        await hotelProvider
                                            .fetchHotelsByLocation(
                                                placeNameController.text.trim(),
                                                hotelNameController.text.trim(),
                                                values.start.toString(),
                                                values.end.toString());
                                      },
                                      onSortChanged: (int selectedIndex) {
                                        hotelProvider.sortHotel(selectedIndex);
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _getSearchBarUI(HotelProvider hotelProvider) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
      child: Column(
        children: [
          Row(
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                      right: 8, top: 8, bottom: 8, left: 8),
                  child: CommonCard(
                    color: AppTheme.backgroundColor,
                    radius: 36,
                    child: CommonSearchBar(
                      textEditingController: hotelNameController,
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
                    onTap: () async {
                      String name = hotelNameController.text.trim();
                      String location = placeNameController.text.trim();
                      await hotelProvider.fetchHotelsByLocation(
                          location, name, "", "");
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
                  padding: const EdgeInsets.only(
                      right: 8, top: 8, bottom: 8, left: 8),
                  child: CommonCard(
                    color: AppTheme.backgroundColor,
                    radius: 36,
                    child: CommonSearchBar(
                      textEditingController: placeNameController,
                      enabled: true,
                      isShow: false,
                      text: "Location",
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          CommonButton(
            onTap: () async {
              hotelNameController.clear();
              placeNameController.clear();
              await hotelProvider.fetchHotelsByLocation("", "", "", "");
            },
            padding: const EdgeInsets.symmetric(horizontal: 8),
            buttonText: 'View all',
          ),
        ],
      ),
    );
  }

  Widget _getAppBarUI() {
    return Padding(
      padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top, left: 8, right: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(
            width: AppBar().preferredSize.height,
            height: AppBar().preferredSize.height,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: const BorderRadius.all(Radius.circular(32.0)),
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(Icons.arrow_back),
                ),
              ),
            ),
          ),
          // const SizedBox(width: 40),
          Expanded(
            child: Center(
              child: Text(
                AppLocalizations(context).of("explore"),
                style: TextStyles(context).getTitleStyle(),
              ),
            ),
          ),
          SizedBox(
            width: AppBar().preferredSize.height,
            height: AppBar().preferredSize.height,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: const BorderRadius.all(
                  Radius.circular(32.0),
                ),
                onTap: () {
                  setState(() {
                    _isShowMap = !_isShowMap;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                      _isShowMap ? Icons.sort : FontAwesomeIcons.mapMarkedAlt),
                ),
              ),
            ),
          ),
          // SizedBox(
          //   width: AppBar().preferredSize.height + 40,
          //   height: AppBar().preferredSize.height,
          //   child: Row(
          //     crossAxisAlignment: CrossAxisAlignment.center,
          //     mainAxisAlignment: MainAxisAlignment.end,
          //     children: <Widget>[
          //       Material(
          //         color: Colors.transparent,
          //         child: InkWell(
          //           borderRadius: const BorderRadius.all(
          //             Radius.circular(32.0),
          //           ),
          //           onTap: () {},
          //           child: const Padding(
          //             padding: EdgeInsets.all(8.0),
          //             child: Icon(Icons.refresh),
          //           ),
          //         ),
          //       ),
          //       Material(
          //         color: Colors.transparent,
          //         child: InkWell(
          //           borderRadius: const BorderRadius.all(
          //             Radius.circular(32.0),
          //           ),
          //           onTap: () {
          //             setState(() {
          //               _isShowMap = !_isShowMap;
          //             });
          //           },
          //           child: Padding(
          //             padding: const EdgeInsets.all(8.0),
          //             child: Icon(_isShowMap
          //                 ? Icons.sort
          //                 : FontAwesomeIcons.mapMarkedAlt, size: 20,),
          //           ),
          //         ),
          //       ),
          //     ],
          //   ),
          // )
        ],
      ),
    );
  }
}
