import 'package:booking_hotel_app/utils/text_styles.dart';
import 'package:booking_hotel_app/utils/themes.dart';
import 'package:flutter/material.dart';

class CommonSearchBar extends StatelessWidget {
  final String? text;
  final bool enabled, isShow;
  final double height;
  final IconData? iconData;
  final TextEditingController? textEditingController;
  const CommonSearchBar({super.key, this.text,this.enabled = false, this.isShow = true, this.height = 48, this.iconData, this.textEditingController});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 16.0, right: 16.0),
      child: Container(
        height: height,
        child: Center(
          child: Center(
            child: Row(
              children: [
                isShow == true ? Icon(iconData, size: 19, color: Theme.of(context).primaryColor,) : SizedBox(),
                isShow == true ? SizedBox(width: 8,) : SizedBox(),
                Expanded(
                  child: TextField(
                    controller: textEditingController,
                    maxLines: 1,
                    enabled: enabled,
                    onChanged: (String text) {

                    },
                    cursorColor: Theme.of(context).primaryColor,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(0),
                      errorText: null,
                      border: InputBorder.none,
                      hintText: text,
                      hintStyle: TextStyles(context).getDescriptionStyle().copyWith(
                        color: AppTheme.secondaryTextColor,
                        fontSize: 18
                      )
                    ),
                  ),
                )

              ],
            ),
          ),
        ),
      ),
    );
  }
}
