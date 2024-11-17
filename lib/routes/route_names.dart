import 'package:booking_hotel_app/models/hotel_list_data.dart';
import 'package:booking_hotel_app/screens/bottom_tab/bottom_tab_screen.dart';
import 'package:booking_hotel_app/screens/hotel_detail_screen/review_list_screen.dart';
import 'package:booking_hotel_app/screens/hotel_detail_screen/room_booking_screen.dart';
import 'package:booking_hotel_app/screens/login_screen/forgot_password.dart';
import 'package:booking_hotel_app/screens/login_screen/login_screen.dart';
import 'package:booking_hotel_app/screens/login_screen/sign_up_screen.dart';
import 'package:booking_hotel_app/routes/routes.dart';
import 'package:booking_hotel_app/screens/profile_screen/change_password_screen.dart';
import 'package:booking_hotel_app/screens/profile_screen/edit_profile_screen.dart';
import 'package:booking_hotel_app/screens/profile_screen/help_center_screen.dart';
import 'package:booking_hotel_app/screens/profile_screen/setting_screen.dart';
import 'package:flutter/material.dart';


import '../screens/explore_screen/filter_screen/filter_screen.dart';
import '../screens/explore_screen/explore_screen.dart';
import '../screens/hotel_detail_screen/hotel_detail_screen.dart';
import '../utils/enum.dart';

class NavigationServices {
  final BuildContext context;
  NavigationServices(this.context);

  Future<dynamic> _pushMasterialPageRoute (Widget widget, {bool fullscreenDialog = false}) async {
    return await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => widget, fullscreenDialog: fullscreenDialog
      )
    );
  }

  void goToSlashScreen(){
    Navigator.pushNamedAndRemoveUntil(context, RoutesName.Slash, (Route<dynamic> route) => false);
  }
  void goToIntroductionScreen(){
    Navigator.pushNamedAndRemoveUntil(context, RoutesName.IntroductionScreen, (Route<dynamic> route) => false);
  }

  Future<dynamic> gotoLoginScreen() async {
    return _pushMasterialPageRoute(LoginScreen());
  }

  Future<dynamic> gotoForgotPasswordScreen() async {
    return _pushMasterialPageRoute(ForgotPassword());
  }

  Future<dynamic> gotoSignUpScreen() async {
    return _pushMasterialPageRoute(SignUpScreen());
  }

  Future<dynamic> gotoBottomTabScreen({BottomBarType? bottomBarType}) async {
    return _pushMasterialPageRoute(BottomTabScreen(initialBottomBarType: bottomBarType==null ? BottomBarType.Explore : bottomBarType,));
  }

  Future<dynamic> gotoExploreScreen([String place = ""]) async {
    return _pushMasterialPageRoute(ExploreScreen(placeName: place,));
  }

  Future<dynamic> gotoFiltersScreen() async {
    return _pushMasterialPageRoute(FiltersScreen());
  }

  Future<dynamic> gotoRoomBookingScreen(HotelListData hotelListData) async {
    return _pushMasterialPageRoute(RoomBookingScreen(hotelListData: hotelListData));
  }

  Future<dynamic> gotoHotelDetails(HotelListData hotelData) {
    return _pushMasterialPageRoute(HotelDetailScreen(
      hotelData: hotelData
    ));
  }

  Future<dynamic> gotoReviewsListScreen() {
    return _pushMasterialPageRoute(ReviewListScreen());
  }


  Future<Future> gotoEditProfileScreen()  async{
    return await _pushMasterialPageRoute(EditProfileScreen());
  }


  Future<Future> gotoChangePasswordScreen()  async{
    return await _pushMasterialPageRoute(ChangePasswordScreen());
  }

  Future<Future> gotoHelpCenterScreen()  async{
    return await _pushMasterialPageRoute(HelpCenterScreen());
  }

  Future<Future> gotoSettingsScreen()  async{
    return await _pushMasterialPageRoute(SettingsScreen());
  }

  
}