import 'package:booking_hotel_app/utils/localfiles.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:smooth_star_rating_null_safety/smooth_star_rating_null_safety.dart';

import '../../language/appLocalizations.dart';
import '../../models/hotel_list_data.dart';
import '../../models/review.dart';
import '../../utils/text_styles.dart';
import '../../utils/themes.dart';
import '../../widgets/common_card.dart';
import '../../widgets/list_cell_animation_view.dart';

class ReviewsView extends StatelessWidget {
  final VoidCallback callback;
  final Review review;
  final AnimationController animationController;
  final Animation<double> animation;

  const ReviewsView({
    Key? key,
    required this.review,
    required this.animationController,
    required this.animation,
    required this.callback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListCellAnimationView(
      animation: animation,
      animationController: animationController,
      yTranslation: 40,
      child: Padding(
        padding: const EdgeInsets.only(left: 24, right: 24, top: 16),
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: 48,
                    child: CommonCard(
                      radius: 8,
                      color: AppTheme.whiteColor,
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: CachedNetworkImage(
                            placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                            imageUrl: review.profileImage!,
                            errorWidget: (context, url, error) => Icon(Icons.error),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      // reviewsList.titleTxt,
                      review.email!,
                      style: TextStyles(context).getBoldStyle().copyWith(
                        fontSize: 14,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          AppLocalizations(context).of("last_update"),
                          style: new TextStyles(context)
                              .getDescriptionStyle()
                              .copyWith(
                            fontWeight: FontWeight.w100,
                            color: Theme.of(context).disabledColor,
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          review.date!,
                          style: new TextStyles(context)
                              .getDescriptionStyle()
                              .copyWith(
                            fontWeight: FontWeight.w100,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Text(
                          "(${review.rating})",
                          style: new TextStyles(context)
                              .getRegularStyle()
                              .copyWith(
                            fontWeight: FontWeight.w100,
                          ),
                        ),
                          SmoothStarRating(
                            allowHalfRating: true,
                            starCount: 5,
                            rating: review.rating!.toDouble(),
                            size: 16,
                            color: Theme.of(context).primaryColor,
                            borderColor: Theme.of(context).primaryColor,
                          ),
                      ],
                    ),
                  ],
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8, left: 8,right: 8,bottom: 16),
              child: Text(
                review.reviewText!,
                style: TextStyles(context).getDescriptionStyle().copyWith(
                  fontWeight: FontWeight.w100,
                  color: Colors.black87,
                ),
              ),
            ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.end,
            //   // crossAxisAlignment: CrossAxisAlignment.center,
            //   // mainAxisAlignment: MainAxisAlignment.end,
            //   children: <Widget>[
            //     Material(
            //       color: Colors.transparent,
            //       child: InkWell(
            //         borderRadius: BorderRadius.all(Radius.circular(4.0)),
            //         onTap: () {},
            //         child: Padding(
            //           padding: const EdgeInsets.only(left: 8),
            //           child: Row(
            //             children: <Widget>[
            //               Text(
            //                 AppLocalizations(context).of("reply"),
            //                 textAlign: TextAlign.left,
            //                 style:
            //                 TextStyles(context).getRegularStyle().copyWith(
            //                   fontWeight: FontWeight.w600,
            //                   fontSize: 14,
            //                   color: Theme.of(context).primaryColor,
            //                 ),
            //               ),
            //               SizedBox(
            //                 height: 38,
            //                 width: 26,
            //                 child: Icon(
            //                   Icons.arrow_forward,
            //                   size: 14,
            //                   color: Theme.of(context).primaryColor,
            //                 ),
            //               ),
            //             ],
            //           ),
            //         ),
            //       ),
            //     ),
            //   ],
            // ),
            Divider(
              height: 1,
            )
          ],
        ),
      ),
    );
  }
}