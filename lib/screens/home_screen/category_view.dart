import 'package:booking_hotel_app/models/hotel_list_data.dart';
import 'package:booking_hotel_app/utils/text_styles.dart';
import 'package:booking_hotel_app/utils/themes.dart';
import 'package:flutter/material.dart';

class CategoryView extends StatelessWidget {
  final VoidCallback callback;
  final HotelListData popularList;
  final AnimationController animationController;
  final Animation<double> animation;

  const CategoryView({super.key, required this.callback, required this.popularList, required this.animationController, required this.animation});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: animationController,
        builder: (BuildContext context, Widget? child){
          return FadeTransition(
            opacity: animation,
            child: Transform(
              transform: Matrix4.translationValues(100 * (1.0 - animation.value), 0, 0),
              child: child,
            ),
          );
        },
        child: InkWell(
          onTap: (){
            callback();
          },
          child: Padding(
            padding: EdgeInsets.only(left: 16, bottom: 24, top: 16, right: 16),
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
              child: Stack(
                children: [
                  AspectRatio(
                    aspectRatio: 2,
                    child: Image.asset(popularList.imagePath, fit: BoxFit.cover),
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  colors: [
                                    AppTheme.secondaryTextColor.withOpacity(0.4),
                                    AppTheme.secondaryTextColor.withOpacity(0.0)
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                              )
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(left: 8, bottom: 32, top: 8, right: 8),
                              child: Text(
                                popularList.titleTxt,
                                style: TextStyles(context).getBoldStyle().copyWith(
                                  fontSize: 21,
                                  color: AppTheme.whiteColor
                                ),
                              ),
                            ),
                          )
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
    );
  }
}
