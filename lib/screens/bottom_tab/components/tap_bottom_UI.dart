import 'package:booking_hotel_app/utils/text_styles.dart';
import 'package:booking_hotel_app/utils/themes.dart';
import 'package:flutter/material.dart';

class TapBottomUi extends StatelessWidget {
  final IconData icon;
  final Function()? onTap;
  final bool isSelected;
  final String text;
  const TapBottomUi ({super.key, required this.icon, this.onTap, required this.isSelected, required this.text});

  @override
  Widget build(BuildContext context) {
    final color = isSelected ? AppTheme.primaryColor : AppTheme.secondaryTextColor;
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          highlightColor: Colors.transparent,
          splashColor: Theme.of(context).primaryColor.withOpacity(0.2),
          onTap: onTap,
          child: Column(
            children: [
              SizedBox(
                height: 4,
              ),
              Container(
                width: 40,
                height: 32,
                child: Icon(
                  icon,
                  size: 26,
                  color: color,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 0),
                child: FittedBox(
                  fit: BoxFit.fill,
                  child: Text(
                    text,
                    style: TextStyles(context).getDescriptionStyle().copyWith(
                      color: color
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
