import 'package:booking_hotel_app/providers/auth_provider.dart';
import 'package:booking_hotel_app/routes/route_names.dart';
import 'package:booking_hotel_app/utils/text_styles.dart';
import 'package:booking_hotel_app/utils/themes.dart';
import 'package:booking_hotel_app/widgets/remove_focuse.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../language/appLocalizations.dart';
import '../../widgets/common_appbar_view.dart';
import '../../widgets/common_button.dart';
import '../../widgets/common_snack_bar.dart';
import '../../widgets/common_textfield_view.dart';
import 'facebook_google_button_view.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
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
                titleText: AppLocalizations(context).of("sign_up"),
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
                          padding: const EdgeInsets.only(
                              left: 24, right: 24, top: 24, bottom: 16),
                          hintText:
                              AppLocalizations(context).of("enter_your_email"),
                          keyboardType: TextInputType.emailAddress,
                          onChanged: (String txt) {
                            authProvider.validateField('email');
                          },
                        ),
                        CommonTextFieldView(
                          controller: authProvider.controllers['username'],
                          errorText: authProvider.errors['username'],
                          titleText: AppLocalizations(context).of("user_name"),
                          padding: const EdgeInsets.only(
                              left: 24, right: 24, bottom: 16),
                          hintText: AppLocalizations(context)
                              .of("enter_your_user_name"),
                          onChanged: (String txt) {
                            authProvider.validateField('username');
                          },
                          keyboardType: TextInputType.text,
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
                          isObsecureText: !authProvider.isPasswordVisible,
                          isPasswordField: true,
                          togglePasswordVisibility: () {
                            authProvider.togglePasswordVisibility();
                          },
                          keyboardType: TextInputType.text,
                        ),
                        CommonTextFieldView(
                          controller:
                              authProvider.controllers['confirmPassword'],
                          errorText: authProvider.errors['confirmPassword'],
                          titleText:
                              AppLocalizations(context).of("confirm_password"),
                          padding: const EdgeInsets.only(
                              left: 24, right: 24, bottom: 16),
                          hintText: AppLocalizations(context)
                              .of("enter_confirm_password"),
                          onChanged: (String txt) {
                            authProvider.validateField('confirmPassword');
                          },
                          isObsecureText:
                              !authProvider.isConfirmPasswordVisible,
                          isPasswordField: true,
                          togglePasswordVisibility: () {
                            authProvider.toggleConfirmPasswordVisibility();
                          },
                          keyboardType: TextInputType.text,
                        ),
                        CommonButton(
                          padding: const EdgeInsets.only(
                              left: 24, right: 24, bottom: 16),
                          buttonText: AppLocalizations(context).of("sign_up"),
                          onTap: () async {
                            String email =
                                authProvider.controllers['email']!.text.trim();
                            String password = authProvider
                                .controllers['password']!.text
                                .trim();
                            String username = authProvider
                                .controllers['username']!.text
                                .trim();
                            if (authProvider.validateRegister()) {}
                            bool isSuccess = await authProvider.register(
                                email, password, username);
                            if (isSuccess) {
                              CommonSnackBar.show(
                                  context: context,
                                  iconData: Icons.check_circle,
                                  iconColor: Colors.white,
                                  message: "Register successfully",
                                  backgroundColor:
                                      Theme.of(context).primaryColor);
                              NavigationServices(context).gotoLoginScreen();
                            } else {
                              CommonSnackBar.show(
                                  context: context,
                                  iconData: Icons.error_outline,
                                  iconColor: Colors.red,
                                  message:
                                      "User with this email already exists!",
                                  backgroundColor: Colors.black87);
                            }
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16),
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
                              AppLocalizations(context)
                                  .of("already_have_account"),
                            ),
                            InkWell(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(8)),
                              onTap: () {
                                NavigationServices(context).gotoLoginScreen();
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Text(
                                  AppLocalizations(context).of("login"),
                                  style: TextStyles(context)
                                      .getRegularStyle()
                                      .copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: AppTheme.primaryColor),
                                ),
                              ),
                            ),
                          ],
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
}
