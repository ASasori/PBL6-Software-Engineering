import 'package:booking_hotel_app/providers/auth_provider.dart';
import 'package:booking_hotel_app/widgets/common_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../language/appLocalizations.dart';
import '../../widgets/common_appbar_view.dart';
import '../../widgets/common_button.dart';
import '../../widgets/common_textfield_view.dart';
import '../../widgets/remove_focuse.dart';

class ChangePasswordScreen extends StatefulWidget {
  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {

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
    final authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      body: RemoveFocuse(
        onclick: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            CommonAppbarView(
              iconData: Icons.arrow_back,
              titleText: AppLocalizations(context).of("change_password"),
              onBackClick: () {
                Navigator.pop(context);
              },
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 16.0, bottom: 16.0, left: 24, right: 24),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              AppLocalizations(context)
                                  .of("enter_your_new_password"),
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Theme.of(context).disabledColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    CommonTextFieldView(
                      controller: authProvider.controllers['password'],
                      errorText: authProvider.errors['password'],
                      titleText:
                          AppLocalizations(context).of("current_password"),
                      padding: const EdgeInsets.only(
                          left: 24, right: 24, bottom: 16),
                      hintText: AppLocalizations(context)
                          .of("enter_current_password"),
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
                      controller: authProvider.controllers['newPassword'],
                      errorText: authProvider.errors['newPassword'],
                      titleText: AppLocalizations(context).of("new_password"),
                      padding: const EdgeInsets.only(
                          left: 24, right: 24, bottom: 16),
                      hintText:
                          AppLocalizations(context).of("enter_new_password"),
                      onChanged: (String txt) {
                        authProvider.validateField('newPassword');
                      },
                      isObsecureText: !authProvider.isNewPasswordVisible,
                      isPasswordField: true,
                      togglePasswordVisibility: () {
                        authProvider.toggleNewPasswordVisibility();
                      },
                      keyboardType: TextInputType.text,
                    ),
                    CommonTextFieldView(
                      controller:
                          authProvider.controllers['confirmNewPassword'],
                      errorText: authProvider.errors['confirmNewPassword'],
                      titleText:
                          AppLocalizations(context).of("confirm_password"),
                      padding: const EdgeInsets.only(
                          left: 24, right: 24, bottom: 16),
                      hintText: AppLocalizations(context)
                          .of("enter_confirm_password"),
                      onChanged: (String txt) {
                        authProvider.validateField('confirmNewPassword');
                      },
                      isObsecureText: !authProvider.isConfirmNewPasswordVisible,
                      isPasswordField: true,
                      togglePasswordVisibility: () {
                        authProvider.toggleConfirmNewPasswordVisibility();
                      },
                      keyboardType: TextInputType.text,
                    ),
                    CommonButton(
                      padding: const EdgeInsets.only(
                          left: 24, right: 24, bottom: 16),
                      buttonText: AppLocalizations(context).of("Apply_text"),
                      onTap: () async {
                        if (authProvider.validateChangePassword()) {
                          bool status = await authProvider.changePassword(
                              authProvider.controllers['password']!.text.trim(),
                              authProvider.controllers['newPassword']!.text.trim());
                          if (status) {
                            authProvider.resetController();
                            authProvider.resetError();
                            authProvider.resetPasswordVisible();
                          }
                          CommonSnackBar.show(
                            context: context,
                            iconData: status
                                ? Icons.check_circle
                                : Icons.error_outline,
                            iconColor: status ? Colors.white : Colors.red,
                            message: status
                                ? "Change password successfully"
                                : "Failed to change password!",
                            backgroundColor: status
                                ? Theme.of(context).primaryColor
                                : Colors.black87,
                          );
                        }
                      },
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}