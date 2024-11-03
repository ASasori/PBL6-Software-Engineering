import 'package:booking_hotel_app/language/appLocalizations.dart';
import 'package:booking_hotel_app/models/hotel.dart';
import 'package:booking_hotel_app/screens/home_screen/home_slider_view.dart';
import 'package:booking_hotel_app/screens/home_screen/hotel_list_view.dart';
import 'package:booking_hotel_app/screens/home_screen/popular_list_view.dart';
import 'package:booking_hotel_app/screens/home_screen/title_view.dart';
import 'package:booking_hotel_app/providers/theme_provider.dart';
import 'package:booking_hotel_app/routes/route_names.dart';
import 'package:booking_hotel_app/widgets/bottom_top_move_animation_view.dart';
import 'package:booking_hotel_app/widgets/common_button.dart';
import 'package:booking_hotel_app/widgets/common_card.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../providers/hotel_provider.dart';
import '../../utils/text_styles.dart';
import '../../utils/themes.dart';
import '../../widgets/common_search_bar.dart';

class HomeScreen extends StatefulWidget {
  final AnimationController animationController;
  const HomeScreen({super.key, required this.animationController});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late ScrollController controller;
  late AnimationController _animationController;
  var sliderImageHeight = 0.0;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 0));
    widget.animationController.forward();
    controller = ScrollController(initialScrollOffset: 0.0);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<HotelProvider>(context, listen: false).fetchHotels();
    });

    controller.addListener(() {
      if (mounted) {
        if (controller.offset < 0) {
          // set a static half scrolling values
          _animationController.animateTo(0.0);
        }
        if (controller.offset > 0.0 && controller.offset < sliderImageHeight) {
          // we need arround half crolling value
          if (controller.offset < (sliderImageHeight / 1.5)) {
            _animationController.animateTo(
                controller.offset / sliderImageHeight);
          } else {
            _animationController.animateTo(
                (sliderImageHeight / 1.5) / sliderImageHeight);
          }
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    sliderImageHeight = MediaQuery
        .of(context)
        .size
        .width * 1.3;
    return BottomTopMoveAnimationView(
        animationController: widget.animationController,
        child: Consumer2<HotelProvider, ThemeProvider>(
            builder: (context, hotelProvider, themeProvider, child) {
              return Stack(
                children: [
                  Container(
                    color: AppTheme.scaffoldBackgroundColor,
                    child: hotelProvider.isLoading
                        ? Center(
                        child: CircularProgressIndicator()) // Loading indicator
                        : ListView.builder(
                        controller: controller,
                        itemCount: 4,
                        // Số lượng mục cần hiển thị
                        padding: EdgeInsets.only(
                            top: sliderImageHeight + 32, bottom: 16),
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) {
                          var animation = Tween(begin: 0.0, end: 1.0).animate(
                            CurvedAnimation(
                                parent: widget.animationController,
                                curve: Curves.fastOutSlowIn),
                          );
                          if (index == 0) {
                            return TitleView(
                              titleText: AppLocalizations(context).of(
                                  "popular_destination"),
                              animationController: widget.animationController,
                              animation: animation,
                              click: () {},
                              isLeftButton: true,
                            );
                          } else if (index == 1) {
                            return Padding(
                              padding: EdgeInsets.all(8),
                              child: PopularListView(
                                animationController: widget.animationController,
                                callBack: (index) {},
                              ),
                            );
                          } else if (index == 2) {
                            return TitleView(
                              titleText: AppLocalizations(context).of(
                                  "best_deal"),
                              subTxt: AppLocalizations(context).of("view_all"),
                              animationController: widget.animationController,
                              animation: animation,
                              click: () {},
                              isLeftButton: true,
                            );
                          } else {
                            return getDealListView(hotelProvider
                                .hotels); // Hiển thị danh sách hotel
                          }
                        }
                    ),
                  ),
                  //Animated slider UI
                  _sliderUI(),
                  //View hotel button UI for on click event
                  _viewHotelButton(_animationController),
                  // Search bar
                  Positioned(
                    top: 0,
                    right: 0,
                    left: 0,
                    child: Container(
                      height: 80,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              colors: [
                                Theme
                                    .of(context)
                                    .scaffoldBackgroundColor
                                    .withOpacity(0.4),
                                Theme
                                    .of(context)
                                    .scaffoldBackgroundColor
                                    .withOpacity(0.0),
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter
                          )
                      ),
                    ),
                  ),
                  Positioned(
                    top: MediaQuery
                        .of(context)
                        .padding
                        .top,
                    left: 0,
                    right: 0,
                    child: searchUI(),
                  ),
                ],
              );
            }
        )
    );
  }

  _sliderUI() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: AnimatedBuilder(
          animation: _animationController,
          builder: (BuildContext context, Widget? child) {
            var opacity = 1.0 -
                (_animationController.value > 0.64 ? 1.0 : _animationController
                    .value);
            return SizedBox(
                height: sliderImageHeight * (1.0 - _animationController.value),
                child: HomeSliderView(
                    opValue: opacity,
                    click: () {
                    }
                )
            );
          }
      ),

    );
  }

  _viewHotelButton(AnimationController animationController) {
    return AnimatedBuilder(
        animation: animationController,
        builder: (BuildContext context, Widget? child) {
          var opacity = 1.0 -
              (_animationController.value > 0.64 ? 1.0 : _animationController
                  .value);
          return Positioned(
            left: 0,
            right: 0,
            top: 0,
            height: sliderImageHeight * (1.0 - _animationController.value),
            child: Stack(
              children: [
                Positioned(
                  bottom: 32,
                  left: 24,
                  child: Opacity(
                    opacity: opacity,
                    child: CommonButton(
                      onTap: () {
                        if (opacity != 0) {
                          NavigationServices(context).gotoHotelHomeScreen();
                        }
                      },
                      buttonTextWidget: Padding(
                        padding: EdgeInsets.only(
                          left: 24,
                          right: 24,
                          top: 8,
                          bottom: 8,
                        ),
                        child: Text(
                          AppLocalizations(context).of("view_hotel"),
                          style: TextStyles(context).getTitleStyle().copyWith(
                              color: AppTheme.whiteColor,
                              fontSize: 18
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
    );
  }

  searchUI() {
    return Padding(
      padding: EdgeInsets.only(left: 24, right: 24, top: 16),
      child: CommonCard(
        radius: 36,
        child: InkWell(
          borderRadius: BorderRadius.all(Radius.circular(30)),
          onTap: () {
            NavigationServices(context).gotoHotelHomeScreen();
          },
          child: CommonSearchBar(
            iconData: FontAwesomeIcons.search,
            enabled: true,
            text: AppLocalizations(context).of("where_are_you_going"),
          ),
        ),
      ),
    );
  }

  Widget getDealListView(List<Hotel> hotelList) {
    return Padding(
      padding: EdgeInsets.only(top: 8),
      child: Column(
        children: List.generate(hotelList.length, (index) {
          var hotel = hotelList[index];
          var animation = Tween(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(
              parent: widget.animationController,
              curve: Interval(0.0, 1.0, curve: Curves.fastOutSlowIn),
            ),
          );
          // HotelListView
          return HotelListView(
            callback: () {
              // Xử lý khi nhấn vào từng khách sạn
              // NavigationServices(context).gotoHotelDetails(hotel);
            },
            hotelListData: hotel,
            animationController: widget.animationController,
            animation: animation,
          );
        }),
      ),
    );
  }
}

