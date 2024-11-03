import 'package:booking_hotel_app/utils/text_styles.dart';
import 'package:booking_hotel_app/utils/themes.dart';
import 'package:flutter/material.dart';

class TitleView extends StatelessWidget {
  final String titleText, subTxt;
  final AnimationController animationController;
  final Animation<double> animation;
  final VoidCallback click;
  final bool isLeftButton;

  const TitleView({
    super.key,
    this.titleText = "",
    this.subTxt = "",
    required this.animationController,
    required this.animation,
    required this.click,
    this.isLeftButton = false
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: animation,
        builder: (BuildContext context, Widget? widget){
          return FadeTransition(
            opacity: animation,
            child: Transform(
              transform: Matrix4.translationValues(0.0, 30*(1.0 - animation.value), 0.0),
              child: Padding(
                padding: EdgeInsets.only(left: 24, right: 24),
                child: Row(
                  children: [
                    Text(
                      titleText,
                      textAlign: TextAlign.left,
                      style: TextStyles(context).getBoldStyle().copyWith(fontSize: 18),
                    ),
                    Expanded(
                      child: SizedBox(
                      ),
                    ),
                    isLeftButton ? Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.all(Radius.circular(4.0)),
                        onTap: () {
                          return click();
                        },
                        child: Padding(
                          padding: EdgeInsets.only(left: 8,right: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                subTxt,
                                textAlign: TextAlign.left,
                                style: TextStyles(context).getBoldStyle().copyWith(fontSize: 16, color: AppTheme.primaryColor),
                              ),
                              SizedBox(
                                height: 38,
                                width: 26,
                                child: Icon(
                                  Icons.arrow_forward_ios,
                                  size: 18,
                                  color: Theme.of(context).primaryColor
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ) : SizedBox()
                  ],
                ),
              ),
            ),
          );
        }
    );
  }
}
