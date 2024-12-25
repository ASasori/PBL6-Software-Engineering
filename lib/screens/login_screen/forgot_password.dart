import 'package:booking_hotel_app/language/appLocalizations.dart';
import 'package:booking_hotel_app/providers/auth_provider.dart';
import 'package:booking_hotel_app/utils/validator.dart';
import 'package:booking_hotel_app/widgets/common_appbar_view.dart';
import 'package:booking_hotel_app/widgets/common_button.dart';
import 'package:booking_hotel_app/widgets/remove_focuse.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../widgets/common_snack_bar.dart';
import '../../widgets/common_textfield_view.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AuthProvider>(context, listen: false).resetError();
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
                      padding: const EdgeInsets.only(
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
                      controller: authProvider.controllers['email'],
                      errorText: authProvider.errors['email'],
                      titleText: AppLocalizations(context).of("your_mail"),
                      padding: EdgeInsets.only(left: 24, right: 24, top: 24),
                      hintText:
                      AppLocalizations(context).of("enter_your_email"),
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (String txt) {
                        authProvider.validateField('email');
                      },
                    ),
                    const SizedBox(height: 30),
                    CommonButton(
                      padding: EdgeInsets.only(left: 24, right: 24, bottom: 16),
                      buttonText: AppLocalizations(context).of("send"),
                      onTap: () async {
                        if (authProvider.validateForgotPassword()) {
                          final status =
                          await authProvider.resetPasswordByEmail(
                              authProvider.controllers['email']!.text.trim());
                          CommonSnackBar.show(
                            context: context,
                            iconData: status
                                ? Icons.check_circle
                                : Icons.error_outline,
                            iconColor: status ? Colors.white : Colors.red,
                            message: status
                                ? 'Reset password email has been sent'
                                : 'No account associated with this email',
                            backgroundColor: status
                                ? Theme
                                .of(context)
                                .primaryColor
                                : Colors.black87,
                          );
                        }
                        ;
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
}