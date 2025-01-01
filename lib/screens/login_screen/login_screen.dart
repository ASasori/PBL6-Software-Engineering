import 'package:booking_hotel_app/language/appLocalizations.dart';
import 'package:booking_hotel_app/screens/login_screen/facebook_google_button_view.dart';
import 'package:booking_hotel_app/routes/route_names.dart';
import 'package:booking_hotel_app/widgets/common_appbar_view.dart';
import 'package:booking_hotel_app/widgets/common_button.dart';
import 'package:booking_hotel_app/widgets/common_textfield_view.dart';
import 'package:booking_hotel_app/widgets/remove_focuse.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/common_snack_bar.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<StatefulWidget> createState() => _LoginScreen();
}

class _LoginScreen extends State<LoginScreen> {
  bool _isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AuthProvider>(context, listen: false).resetError();
      Provider.of<AuthProvider>(context, listen: false).resetController();
      Provider.of<AuthProvider>(context, listen: false).resetPasswordVisible();
    });
  }

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
                titleText: AppLocalizations(context).of("login"),
                onBackClick: () {
                  Navigator.pop(context);
                }),
            Expanded(
              child: SingleChildScrollView(
                child: Consumer<AuthProvider>(
                  builder: (context, authProvider, child) {
                    return Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 32),
                          child: FacebookGoogleButtonView(),
                        ),
                        CommonTextFieldView(
                          controller: authProvider.controllers['email'],
                          errorText: authProvider.errors['email'],
                          titleText: AppLocalizations(context).of("your_mail"),
                          padding:
                              EdgeInsets.only(left: 24, right: 24, top: 24),
                          hintText:
                              AppLocalizations(context).of("enter_your_email"),
                          keyboardType: TextInputType.emailAddress,
                          onChanged: (String txt) {
                            authProvider.validateField('email');
                          },
                        ),
                        CommonTextFieldView(
                          controller: authProvider.controllers['password'],
                          errorText: authProvider.errors['password'],
                          titleText: AppLocalizations(context).of("password"),
                          padding: const EdgeInsets.only(
                              left: 24, right: 24, bottom: 16),
                          hintText:
                              AppLocalizations(context).of("enter_password"),
                          onChanged: (String txt) {
                            authProvider.validateField('password');
                          },
                          isObsecureText: !_isPasswordVisible,
                          isPasswordField: true,
                          togglePasswordVisibility: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                          keyboardType: TextInputType.text,
                        ),
                        _forgotYourPassword(),
                        CommonButton(
                          padding: const EdgeInsets.only(
                              left: 24, right: 24, bottom: 16),
                          buttonText: AppLocalizations(context).of("login"),
                          onTap: () async {
                            if (authProvider.validateLogin()) {
                              bool isSuccess = await authProvider.login(
                                  authProvider.controllers['email']!.text
                                      .trim(),
                                  authProvider.controllers['password']!.text
                                      .trim());
                              if (isSuccess) {
                                CommonSnackBar.show(
                                    context: context,
                                    iconData: Icons.check_circle,
                                    iconColor: Colors.white,
                                    message: "Login successfully",
                                    backgroundColor:
                                        Theme.of(context).primaryColor);
                                NavigationServices(context)
                                    .gotoBottomTabScreen();
                              } else {
                                CommonSnackBar.show(
                                    context: context,
                                    iconData: Icons.error_outline,
                                    iconColor: Colors.red,
                                    message: "Email or password is incorrect",
                                    backgroundColor: Colors.black87);
                              }
                            }
                          },
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _forgotYourPassword() {
    return Padding(
      padding: const EdgeInsets.only(top: 8, right: 16, bottom: 8, left: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            onTap: () {
              NavigationServices(context).gotoForgotPasswordScreen();
            },
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Text(AppLocalizations(context).of("forgot_your_Password")),
            ),
          ),
        ],
      ),
    );
  }
}
