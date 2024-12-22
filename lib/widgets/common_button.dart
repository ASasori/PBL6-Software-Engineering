import 'package:booking_hotel_app/utils/text_styles.dart';
import 'package:booking_hotel_app/widgets/tap_effect.dart';
import 'package:flutter/material.dart';

class CommonButton extends StatelessWidget{
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final String? buttonText;
  final Widget? buttonTextWidget;
  final Color? textColor, backgroundColor;
  final bool? isClickable ;
  final double radius;

  const CommonButton({super.key, this.onTap, this.padding, this.buttonText, this.buttonTextWidget, this.textColor, this.backgroundColor, this.isClickable = true,  this.radius = 24});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: padding ?? EdgeInsets.symmetric(),
        child: TapEffect(
          isClickable: isClickable!,
          onclick: onTap ?? () {},
          child: SizedBox(
            height: 48,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(radius),
              ),
              color: backgroundColor ?? Theme.of(context).primaryColor,
              shadowColor: Colors.black12.withOpacity(Theme.of(context).brightness == Brightness.dark ? 0.6 : 0.2),
              child: Center(
                child: buttonTextWidget ?? Text(
                    buttonText ?? "",
                    style: TextStyles(context).getRegularStyle().copyWith(
                      color: textColor,
                      fontSize: 16
                    ),
                ),
              ),
            ),
          ),
        ),
    );
  }
}
