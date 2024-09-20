import 'package:booking_hotel_app/routes/route_names.dart';
import 'package:booking_hotel_app/utils/text_styles.dart';
import 'package:booking_hotel_app/utils/themes.dart';
import 'package:booking_hotel_app/widgets/remove_focuse.dart';
import 'package:flutter/material.dart';

import '../../language/appLocalizations.dart';
import '../../utils/validator.dart';
import '../../widgets/common_appbar_view.dart';
import '../../widgets/common_button.dart';
import '../../widgets/common_textfield_view.dart';
import 'facebook_google_button_view.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  String _errorEmail = '';
  TextEditingController _emailController = TextEditingController();
  String _errorPassword = '';
  TextEditingController _passwordController = TextEditingController();
  String _errorFirstName = '';
  TextEditingController _firstNameController = TextEditingController();
  String _errorLastName = '';
  TextEditingController _lastNameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RemoveFocuse(
        onclick: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CommonAppbarView(
                iconData: Icons.arrow_back_ios_new,
                titleText: AppLocalizations(context).of("sign_up"),
                onBackClick: (){
                  Navigator.pop(context);
                }
            ),
            Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 32),
                        child: FacebookGoogleButtonView(),
                      ),
                      CommonTextFieldView(
                        controller: _emailController,
                        errorText: _errorEmail,
                        titleText: AppLocalizations(context).of("your_mail"),
                        padding: EdgeInsets.only(left: 24, right: 24, top: 24, bottom: 16),
                        hintText: AppLocalizations(context).of("enter_your_email"),
                        keyboardType: TextInputType.emailAddress,
                        onChanged: (String txt) {},
                      ),
                      CommonTextFieldView(
                        controller: _passwordController,
                        errorText: _errorPassword,
                        titleText: AppLocalizations(context).of("password"),
                        padding: EdgeInsets.only(left: 24, right: 24, bottom: 16),
                        hintText: AppLocalizations(context).of("enter_password"),
                        onChanged: (String txt) {},
                        isObsecureText: true,
                        keyboardType: TextInputType.text,
                      ),
                      CommonTextFieldView(
                        controller: _firstNameController,
                        errorText: _errorFirstName,
                        titleText: AppLocalizations(context).of("first_name"),
                        padding: EdgeInsets.only(left: 24, right: 24, bottom: 16),
                        hintText: AppLocalizations(context).of("enter_first_name"),
                        keyboardType: TextInputType.name,
                        onChanged: (String txt) {},
                      ),
                      CommonTextFieldView(
                        controller: _lastNameController,
                        errorText: _errorLastName,
                        titleText: AppLocalizations(context).of("last_name"),
                        padding: EdgeInsets.only(left: 24, right: 24, bottom: 24),
                        hintText: AppLocalizations(context).of("enter_last_name"),
                        onChanged: (String txt) {},
                        keyboardType: TextInputType.name,
                      ),
                      CommonButton(
                        padding: EdgeInsets.only(left: 24,right: 24,bottom: 16),
                        buttonText: AppLocalizations(context).of("sign_up"),
                        onTap: () {
                          if (allValidation()) NavigationServices(context).gotoBottomTabScreen();

                        },
                      ),
                      Padding(
                        padding: EdgeInsets.all(16),
                        child: Text(
                          AppLocalizations(context).of("terms_agreed"),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            AppLocalizations(context).of("already_have_account"),
                          ),
                          InkWell(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            onTap: () {
                              NavigationServices(context).gotoLoginScreen();
                            },
                            child: Padding(
                              padding: EdgeInsets.all(4.0),
                              child: Text(
                                AppLocalizations(context).of("login"),
                                style: TextStyles(context).getRegularStyle().copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.primaryColor
                                ),
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
            )
          ],
        ),
      ),
    );
  }

  bool allValidation() {
    bool isValid = true;
    if (_emailController.text.trim().isEmpty){
      _errorEmail = AppLocalizations(context).of("email_cannot_empty");
      isValid = false;
    } else if (!Validator.validateEmail(_emailController.text.trim())) {
      _errorEmail = AppLocalizations(context).of("enter_valid_email");
      isValid = false;
    } else {
      _errorEmail = "";
    }

    if (_passwordController.text.trim().isEmpty){
      _errorPassword = AppLocalizations(context).of("password_cannot_empty");
      isValid = false;
    } else if (_passwordController.text.trim().length < 8) {
      _errorPassword = AppLocalizations(context).of("valid_password");
      isValid = false;
    } else {
      _errorPassword = "";
    }

    if (_firstNameController.text.trim().isEmpty){
      _errorFirstName = AppLocalizations(context).of("first_name_cannot_empty");
      isValid = false;
    }  else {
      _errorFirstName = "";
    }

    if (_lastNameController.text.trim().isEmpty){
      _errorLastName = AppLocalizations(context).of("last_name_cannot_empty");
      isValid = false;
    }  else {
      _errorLastName = "";
    }
    setState(() {

    });
    return isValid;
  }

}
