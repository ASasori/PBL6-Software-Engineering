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
  String _errorCurrentPassword = '';
  String _errorNewPassword = '';
  String _errorConfirmPassword = '';
  TextEditingController _newController = TextEditingController();
  TextEditingController _confirmController = TextEditingController();
  TextEditingController _currentController = TextEditingController();

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
                      controller: _currentController,
                      titleText:
                          AppLocalizations(context).of("current_password"),
                      padding: EdgeInsets.only(left: 24, right: 24, bottom: 16),
                      hintText: AppLocalizations(context)
                          .of('enter_current_password'),
                      keyboardType: TextInputType.visiblePassword,
                      isObsecureText: true,
                      onChanged: (String txt) {},
                      errorText: _errorCurrentPassword,
                    ),
                    CommonTextFieldView(
                      controller: _newController,
                      titleText: AppLocalizations(context).of("new_password"),
                      padding: EdgeInsets.only(left: 24, right: 24, bottom: 16),
                      hintText:
                          AppLocalizations(context).of('enter_new_password'),
                      keyboardType: TextInputType.visiblePassword,
                      isObsecureText: true,
                      onChanged: (String txt) {},
                      errorText: _errorNewPassword,
                    ),
                    CommonTextFieldView(
                      controller: _confirmController,
                      titleText:
                          AppLocalizations(context).of("confirm_password"),
                      padding: EdgeInsets.only(left: 24, right: 24, bottom: 24),
                      hintText: AppLocalizations(context)
                          .of("enter_confirm_password"),
                      keyboardType: TextInputType.visiblePassword,
                      isObsecureText: true,
                      onChanged: (String txt) {},
                      errorText: _errorConfirmPassword,
                    ),
                    CommonButton(
                      padding: EdgeInsets.only(left: 24, right: 24, bottom: 16),
                      buttonText: AppLocalizations(context).of("Apply_text"),
                      onTap: () async {
                        if (_allValidation()) {
                          bool status = await authProvider.changePassword(
                              _currentController.text.trim(),
                              _newController.text.trim());
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
                          // Navigator.pop(context);
                        }
                      },
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

  bool _allValidation() {
    bool isValid = true;

    if (_currentController.text.trim().isEmpty) {
      _errorCurrentPassword =
          AppLocalizations(context).of('password_cannot_empty');
      isValid = false;
    } else if (_newController.text.trim().length < 6) {
      _errorCurrentPassword =
          AppLocalizations(context).of('valid_new_password');
      isValid = false;
    } else {
      _errorCurrentPassword = '';
    }

    if (_newController.text.trim().isEmpty) {
      _errorNewPassword = AppLocalizations(context).of('password_cannot_empty');
      isValid = false;
    } else if (_newController.text.trim().length < 6) {
      _errorNewPassword = AppLocalizations(context).of('valid_new_password');
      isValid = false;
    } else {
      _errorNewPassword = '';
    }
    if (_confirmController.text.trim().isEmpty) {
      _errorConfirmPassword =
          AppLocalizations(context).of('password_cannot_empty');
      isValid = false;
    } else if (_newController.text.trim() != _confirmController.text.trim()) {
      _errorConfirmPassword =
          AppLocalizations(context).of('password_not_match');
      isValid = false;
    } else {
      _errorConfirmPassword = '';
    }
    setState(() {});
    return isValid;
  }
}
