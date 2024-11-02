import 'package:booking_hotel_app/language/appLocalizations.dart';
import 'package:booking_hotel_app/screens/login_screen/facebook_google_button_view.dart';
import 'package:booking_hotel_app/routes/route_names.dart';
import 'package:booking_hotel_app/utils/validator.dart';
import 'package:booking_hotel_app/widgets/common_appbar_view.dart';
import 'package:booking_hotel_app/widgets/common_button.dart';
import 'package:booking_hotel_app/widgets/common_textfield_view.dart';
import 'package:booking_hotel_app/widgets/remove_focuse.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<StatefulWidget> createState() => _LoginScreen();
}

class _LoginScreen extends State<LoginScreen> {
  String _errorEmail = '';
  TextEditingController _emailController = TextEditingController();
  String _errorPassword = '';
  TextEditingController _passwordController = TextEditingController();
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
                          padding: EdgeInsets.only(left: 24, right: 24, top: 24),
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
                        _forgotYourPassword(),
                        CommonButton(
                          padding: EdgeInsets.only(left: 24,right: 24,bottom: 16),
                          buttonText: AppLocalizations(context).of("login"),
                          onTap: () {
                            if (allValidation())
                              NavigationServices(context).gotoBottomTabScreen();
                          },
                        )
                      ],
                    ),
                  )
              )
            ],
          ),
      ),
    );
  }

  _forgotYourPassword() {
    return Padding(
      padding: EdgeInsets.only(top: 8, right: 16, bottom: 8,left: 16),
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
              padding: EdgeInsets.all(8),
              child: Text(
                AppLocalizations(context).of("forgot_your_Password")
              ),
            ),
          )
        ],
      )
    );
  }

  bool allValidation()  {
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

    setState(() {

    });

    // isValid =  login(_emailController.text.trim(), _passwordController.text.trim()) as bool;
    return isValid;
  }

}

Future<String?> fetchCsrfToken() async {
  try {
    final response = await http.get(Uri.parse('http://192.168.43.246:8000/receptionist/get-csrf-token/'));

    if (response.statusCode == 200) {
      // Get cookie from headers
      final cookies = response.headers['set-cookie'];
      if (cookies != null) {
        // Find CSRF token in the cookie
        final csrfToken = RegExp(r'csrftoken=([^;]+)').firstMatch(cookies);
        if (csrfToken != null) {
          print( csrfToken.group(1));
          return csrfToken.group(1); // Return CSRF token value

        } else {
          print("CSRF token not found in cookies.");
        }
      } else {
        print("No cookies in the response headers.");
      }
    } else {
      print("Error: Received status code ${response.statusCode}");
    }
  } catch (e) {
    print("An error occurred: $e");
  }

  return null;
}

Future<bool> login(String email, String password) async {

  final csrfToken = await fetchCsrfToken();

  final response = await http.post(
    Uri.parse('http://192.168.43.246:8000/user/api/userauths/login/'),
    headers: {
      'Content-Type': 'application/json',
      'X-CSRFToken': csrfToken ?? '', // Thêm CSRF token vào header
    },
    body: jsonEncode({
      'email': email,
      'password': password,
    }),
  );

  if (response.statusCode == 200) {
    // Đăng nhập thành công
    print('Login successful: ${response.body}');
    return true;
  } else {
    // Xử lý lỗi
    print('Login failed: ${response.body}');
    return false;
  }
}
