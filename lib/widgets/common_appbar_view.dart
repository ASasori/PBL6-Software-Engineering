import 'package:booking_hotel_app/utils/text_styles.dart';
import 'package:booking_hotel_app/utils/themes.dart';
import 'package:flutter/material.dart';

class CommonAppbarView extends StatelessWidget {
  final double? topPadding;
  final Widget? backWidget;
  final String titleText;
  final VoidCallback onBackClick;
  final IconData? iconData;

  const CommonAppbarView({super.key, this.topPadding, this.backWidget, required this.titleText, required this.onBackClick, this.iconData});

  @override
  Widget build(BuildContext context) {
    final paddingTop = topPadding ?? MediaQuery.of(context).padding.top;
    return Padding(
      padding: EdgeInsets.only(top: paddingTop),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: AppBar().preferredSize.height,
            child: Padding(
              padding: EdgeInsets.only(top: 8, left: 8, right: 8),
              child: Container(
                width: AppBar().preferredSize.height - 8,
                height: AppBar().preferredSize.height - 8,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.all(Radius.circular(32)),
                    onTap: onBackClick,
                    child: Padding(
                        padding: EdgeInsets.all(8),
                        child: backWidget ?? Icon(iconData, color: AppTheme.primaryTextColor,),
                    ),
                  ),
                ),
              ),
            )
          ),
          Padding(
            padding: EdgeInsets.only(top: 4, left:  24, right: 24),
            child: Text(
              titleText,
              style: TextStyles(context).getTitleStyle(),
            ),
          )
        ],
      ),
    );
  }
}
