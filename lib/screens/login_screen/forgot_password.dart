import 'package:booking_hotel_app/language/appLocalizations.dart';
import 'package:booking_hotel_app/providers/auth_provider.dart';
import 'package:booking_hotel_app/utils/validator.dart';
import 'package:booking_hotel_app/widgets/common_appbar_view.dart';
import 'package:booking_hotel_app/widgets/common_button.dart';
import 'package:booking_hotel_app/widgets/remove_focuse.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../widgets/common_textfield_view.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  String _errorEmail = '';
  TextEditingController _emailController = TextEditingController();

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
          children: [
            CommonAppbarView(
              iconData: Icons.arrow_back_ios_new,
              titleText: AppLocalizations(context).of("forgot_your_Password"),
              onBackClick: () {
                Navigator.pop(context);
              },
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          top: 16, bottom: 16, left: 24, right: 24),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(AppLocalizations(context)
                                .of("resend_email_link")),
                          ),
                        ],
                      ),
                    ),
                    CommonTextFieldView(
                      controller: _emailController,
                      errorText: _errorEmail,
                      titleText: AppLocalizations(context).of("your_mail"),
                      padding: EdgeInsets.only(left: 24, right: 24, bottom: 24),
                      hintText:
                          AppLocalizations(context).of("enter_your_email"),
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (String txt) {},
                    ),
                    CommonButton(
                      padding: EdgeInsets.only(left: 24, right: 24, bottom: 16),
                      buttonText: AppLocalizations(context).of("send"),
                      onTap: () {
                        if (allValidation()) Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool allValidation() {
    bool isValid = true;
    if (_emailController.text.trim().isEmpty) {
      _errorEmail = AppLocalizations(context).of("email_cannot_empty");
      isValid = false;
    } else if (!Validator.validateEmail(_emailController.text.trim())) {
      _errorEmail = AppLocalizations(context).of("enter_valid_email");
      isValid = false;
    } else {
      _errorEmail = "";
    }

    setState(() {});
    return isValid;
  }
}
