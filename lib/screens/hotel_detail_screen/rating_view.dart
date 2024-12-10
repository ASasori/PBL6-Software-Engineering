import 'package:booking_hotel_app/utils/helper.dart';
import 'package:flutter/material.dart';
import '../../language/appLocalizations.dart';
import '../../utils/text_styles.dart';
import '../../utils/themes.dart';
import '../../widgets/common_card.dart';

class RatingView extends StatelessWidget {
  final double hotelRating;
  const RatingView({super.key, required this.hotelRating}) ;

  @override
  Widget build(BuildContext context) {
    return CommonCard(
      color: AppTheme.backgroundColor,
      radius: 16,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                SizedBox(
                  width: 60,
                  child: Text(
                    (hotelRating).toStringAsFixed(1),
                    textAlign: TextAlign.left,
                    style: TextStyles(context).getBoldStyle().copyWith(
                      fontSize: 38,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          AppLocalizations(context).of("Overall_rating"),
                          textAlign: TextAlign.left,
                          style: TextStyles(context).getRegularStyle().copyWith(
                            // fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color: Theme.of(context)
                                .disabledColor
                                .withOpacity(0.8),
                          ),
                        ),
                        Helper.ratingStar(hotelRating: hotelRating),
                      ],
                    ),
                  ),
                )
              ],
            ),
            // const SizedBox(height: 4,),
            // getBarUI('room', 95.0, context),
            // const SizedBox(height: 4,),
            // getBarUI('service', 80.0, context),
            // const SizedBox(height: 4,),
            // getBarUI('location', 65.0, context),
            // const SizedBox(height: 4,),
            // getBarUI('price', 85, context),
          ],
        ),
      ),
    );
  }

  Widget getBarUI(String text, double percent, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        SizedBox(
          width: 70,
          child: Text(
            AppLocalizations(context).of(text),
            textAlign: TextAlign.left,
            style: TextStyles(context).getRegularStyle().copyWith(
              // fontWeight: FontWeight.w500,
              fontSize: 14,
              color: Theme.of(context).disabledColor.withOpacity(0.8),
            ),
          ),
        ),
        SizedBox(
          width: 8,
        ),
        Expanded(
          child: Row(
            children: <Widget>[
              Expanded(
                flex: percent.toInt(),
                child: Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: SizedBox(
                      height: 4,
                      child: CommonCard(
                        color: AppTheme.primaryColor,
                        radius: 8,
                      ),
                    )),
              ),
              Expanded(
                flex: 100 - percent.toInt(),
                child: SizedBox(),
              )
            ],
          ),
        )
      ],
    );
  }
}