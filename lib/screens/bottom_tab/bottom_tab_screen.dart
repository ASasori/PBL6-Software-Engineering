import 'package:booking_hotel_app/language/appLocalizations.dart';
import 'package:booking_hotel_app/screens/bottom_tab/components/tap_bottom_UI.dart';
import 'package:booking_hotel_app/screens/explore_screen/explore_screen.dart';
import 'package:booking_hotel_app/screens/profile_screen/profile_screen.dart';
import 'package:booking_hotel_app/screens/wishlist_screen/wishlist_screen.dart';
import 'package:booking_hotel_app/utils/themes.dart';
import 'package:booking_hotel_app/widgets/common_card.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../utils/enum.dart';
import '../home_screen/home_screen.dart';
import '../mytrip_screen/my_trips_screen.dart';

class BottomTabScreen extends StatefulWidget {
  final BottomBarType initialBottomBarType ;

  const BottomTabScreen({super.key, required this.initialBottomBarType});

  @override
  State<BottomTabScreen> createState() => _BottomTabScreenState();
}

class _BottomTabScreenState extends State<BottomTabScreen> with TickerProviderStateMixin {
  late AnimationController animationController;
  Widget _indexView = Container();
  BottomBarType? bottomBarType;
  bool _isFirstTime = true;

  @override
  void initState() {
    bottomBarType = widget.initialBottomBarType;
    animationController = AnimationController(
      duration: Duration(milliseconds: 400),
      vsync: this
    );
    _indexView = Container();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (bottomBarType == BottomBarType.Wishlist) {
        _LoadingWishlistScreen();
      } else {
        _startLoadingScreen();
      }
    });

    super.initState();
  }

  Future _startLoadingScreen() async  {
    await Future.delayed(const Duration(milliseconds: 480));
    setState(() {
      _isFirstTime = false;
      _indexView = HomeScreen(animationController: animationController,);
      animationController.forward();
    });
  }

  Future _LoadingExploreScreen() async  {
    await Future.delayed(const Duration(milliseconds: 480));
    setState(() {
      _isFirstTime = false;
      _indexView = ExploreScreen();
      animationController.forward();
    });
  }

  Future _LoadingWishlistScreen() async  {
    await Future.delayed(const Duration(milliseconds: 480));
    if (mounted) {
      setState(() {
        print("WishList okee");
        _isFirstTime = false;
        _indexView = WishlistScreen(animationController: animationController);
        animationController.forward();
      });
    }
  }


  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Consumer(
        builder: (_, provider, child) => Scaffold(
          bottomNavigationBar: Container(
            height: 61 + MediaQuery.of(context).padding.bottom,
            child: getBottomBarUI(bottomBarType!),
          ),
          body: _isFirstTime ? Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
            ),
          ) : _indexView,
        )
    );
  }

  getBottomBarUI(BottomBarType bottomBarType) {
    return CommonCard(
      radius: 0,
      color: AppTheme.backgroundColor,
      child: Column(
        children: [
          Row(
            children: [
              TapBottomUi(
                icon: Icons.home,
                isSelected: bottomBarType == BottomBarType.Home,
                text: AppLocalizations(context).of("home"),
                onTap: () {
                  tabClick(BottomBarType.Home);
                },
              ),
              TapBottomUi(
                  icon: Icons.search,
                  isSelected: bottomBarType == BottomBarType.Explore,
                  text: AppLocalizations(context).of("explore"),
                  onTap: () {
                    tabClick(BottomBarType.Explore);
                  },
              ),
              TapBottomUi(
                icon: FontAwesomeIcons.heart,
                isSelected: bottomBarType == BottomBarType.Trips,
                text: AppLocalizations(context).of("trips"),
                onTap: () {
                  tabClick(BottomBarType.Trips);
                },
              ),
              TapBottomUi(
                icon: FontAwesomeIcons.opencart,
                isSelected: bottomBarType == BottomBarType.Wishlist,
                text: "Wishlist",
                onTap: () {
                  tabClick(BottomBarType.Wishlist);
                },
              ),
              TapBottomUi(
                icon:  FontAwesomeIcons.user,
                isSelected: bottomBarType == BottomBarType.Profile,
                text: AppLocalizations(context).of("profile"),
                onTap: () {
                  tabClick(BottomBarType.Profile);
                },
              ),
            ],
          ),
          SizedBox(
            height: MediaQuery.of(context).padding.bottom,
          )
        ],
      ),
    );
  }
  void tabClick(BottomBarType tabType){
    if (tabType != bottomBarType){
      bottomBarType = tabType;
      animationController.reverse().then((value) {
          if (tabType == BottomBarType.Home){
            setState(() {
              _isFirstTime = false;
              _indexView = HomeScreen(animationController: animationController);
            });
          }else if (tabType == BottomBarType.Explore) {
            setState(() {
              _indexView = ExploreScreen(placeName: "");
            });
          }
          else if (tabType == BottomBarType.Trips) {
            setState(() {
              _indexView = MyTripsScreen(animationController: animationController);
            });
          } else if (tabType == BottomBarType.Wishlist) {
            setState(() {
              _indexView = WishlistScreen(animationController: animationController);
            });
          } else if (tabType == BottomBarType.Profile){
            setState(() {
              _indexView = ProfileScreen(animationController: animationController);
            });
          }
        }
      );
    }
  }
}


