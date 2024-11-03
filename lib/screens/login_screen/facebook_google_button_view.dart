import 'package:booking_hotel_app/widgets/common_button.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FacebookGoogleButtonView extends StatelessWidget {
  const FacebookGoogleButtonView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          SizedBox(
            width: 24,
          ),
          Expanded(
              child: CommonButton(
                padding: EdgeInsets.zero,
                backgroundColor: Color(0x0ff3c5799),
                buttonTextWidget: _buttonTextUI(),
              )
          ),
          SizedBox(
            width: 24,
          ),
          Expanded(
              child: CommonButton(
                padding: EdgeInsets.zero,
                backgroundColor: Color(0xFFDB4437),
                buttonTextWidget: _buttonTextUI(isFaceBook: false),
              )
          ),
          SizedBox(
            width: 24,
          ),
        ],
      ),
    );
  }

  Widget _buttonTextUI({bool isFaceBook = true}){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
            isFaceBook ? FontAwesomeIcons.facebook : FontAwesomeIcons.google,
            size: 24,
            color: Colors.white,
        ),
        SizedBox(
          width: 24,
        ),
        Text(
          isFaceBook ? "Facebook" : "Google",
          style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16, color: Colors.white),
        )
      ],
    );
  }
}
