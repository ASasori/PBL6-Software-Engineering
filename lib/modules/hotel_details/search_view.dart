import 'package:booking_hotel_app/models/hotel_list_data.dart';
import 'package:booking_hotel_app/utils/helper.dart';
import 'package:booking_hotel_app/utils/text_styles.dart';
import 'package:booking_hotel_app/utils/themes.dart';
import 'package:booking_hotel_app/widgets/common_card.dart';
import 'package:booking_hotel_app/widgets/list_cell_animation_view.dart';
import 'package:flutter/material.dart';

class SearchView extends StatelessWidget {
  final HotelListData hotelInfo;
  final AnimationController animationController;
  final Animation<double> animation;

  const SearchView({super.key, required this.hotelInfo, required this.animationController, required this.animation});

  @override
  Widget build(BuildContext context) {
    return ListCellAnimationView(
        animation: animation,
        animationController: animationController,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: AspectRatio(
            aspectRatio: 0.75,
            child: CommonCard(
              radius: 16,
              color: AppTheme.backgroundColor,
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(16)),
                child: Column(
                  children: [
                    AspectRatio(
                      aspectRatio: 1.5,
                      child: Image.asset(
                        hotelInfo.imagePath,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              hotelInfo.titleTxt,
                              style: TextStyles(context).getBoldStyle(),
                            ),
                            Text(
                              Helper.getRoomText(hotelInfo.roomData!),
                              style: TextStyles(context).getRegularStyle().copyWith(
                                fontWeight: FontWeight.w100,
                                fontSize: 12,
                                color: Theme.of(context).disabledColor.withOpacity(0.6)
                              ),
                            ),
                            Text(
                              Helper.getListSearchedDate(hotelInfo.date!),
                              style: TextStyles(context).getRegularStyle().copyWith(
                                  fontWeight: FontWeight.w100,
                                  fontSize: 12,
                                  color: Theme.of(context).disabledColor.withOpacity(0.6)
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                )
              ),
            ),
          ),
        )
    );
  }
}
