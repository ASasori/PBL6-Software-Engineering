import 'package:booking_hotel_app/modules/bottom_tab/bottom_tab_screen.dart';
import 'package:booking_hotel_app/modules/login/forgot_password.dart';
import 'package:booking_hotel_app/modules/login/login_screen.dart';
import 'package:booking_hotel_app/modules/login/sign_up_screen.dart';
import 'package:booking_hotel_app/routes/routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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

  Future<dynamic> gotoBottomTabScreen() async {
    return _pushMasterialPageRoute(BottomTabScreen());
  }
}