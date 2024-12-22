import 'package:booking_hotel_app/models/review.dart';
import 'package:booking_hotel_app/models/wishlist_item.dart';
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
import 'package:booking_hotel_app/screens/wishlist_screen/checkout_screen.dart';
import 'package:flutter/material.dart';


import '../models/hotel.dart';
import '../models/profile.dart';
import '../models/user.dart';
import '../screens/explore_screen/filter_screen/filter_screen.dart';
import '../screens/explore_screen/explore_screen.dart';
import '../screens/hotel_detail_screen/hotel_detail_screen.dart';
import '../screens/mytrip_screen/upcoming_list_view.dart';
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
    return _pushMasterialPageRoute(BottomTabScreen(initialBottomBarType: bottomBarType==null ? BottomBarType.Home : bottomBarType,));
  }

  Future<dynamic> gotoExploreScreen([String place = ""]) async {
    return _pushMasterialPageRoute(ExploreScreen(placeName: place,));
  }

  Future<dynamic> gotoFiltersScreen() async {
    return _pushMasterialPageRoute(FiltersScreen());
  }

  Future<dynamic> gotoRoomBookingScreen(Hotel hotelBooking) async {
    return _pushMasterialPageRoute(RoomBookingScreen(hotelBooking: hotelBooking));
  }

  Future<dynamic> gotoHotelDetails(Hotel hotelData) {
    return _pushMasterialPageRoute(HotelDetailScreen(
      hotelData: hotelData
    ));
  }

  Future<dynamic> gotoReviewsListScreen(List<Review> reviewList) {
    return _pushMasterialPageRoute(ReviewListScreen(reviewList: reviewList,));
  }

  Future<dynamic> gotoCheckoutScreen(WishlistItem cartItem) {
    return _pushMasterialPageRoute(CheckoutScreen(cartItem: cartItem,));
  }

  Future<void> gotoEditProfileScreen(User user, Profile profile)  async{
    return await _pushMasterialPageRoute(EditProfileScreen(user: user, profile: profile,));
  }

  Future<void> gotoChangePasswordScreen()  async{
    return await _pushMasterialPageRoute(ChangePasswordScreen());
  }

  Future<void> gotoHelpCenterScreen()  async{
    return await _pushMasterialPageRoute(HelpCenterScreen());
  }

  Future<void> gotoSettingsScreen()  async{
    return await _pushMasterialPageRoute(SettingsScreen());
  }
}