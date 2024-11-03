import 'package:booking_hotel_app/language/appLocalizations.dart';
import 'package:booking_hotel_app/models/hotel_list_data.dart';
import 'package:booking_hotel_app/providers/theme_provider.dart';
import 'package:booking_hotel_app/utils/text_styles.dart';
import 'package:booking_hotel_app/utils/themes.dart';
import 'package:booking_hotel_app/widgets/common_card.dart';
import 'package:booking_hotel_app/widgets/list_cell_animation_view.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:booking_hotel_app/models/hotel.dart';
import '../../utils/helper.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HotelListView extends StatelessWidget {
  final bool isShowData;
  final VoidCallback callback;
  final Hotel hotelListData;
  final AnimationController animationController;
  final Animation<double> animation;
  const HotelListView({super.key, this.isShowData = false, required this.callback, required this.hotelListData, required this.animationController, required this.animation});

  @override
  Widget build(BuildContext context) {
    return ListCellAnimationView(
        animation: animation,
        animationController: animationController,
        child: Padding(
            padding: EdgeInsets.only(left: 24, right: 24, top: 8, bottom: 16),
            child: CommonCard(
              color: AppTheme.backgroundColor,
              radius: 10,
              child: ClipRect(
                child: AspectRatio(
                  aspectRatio: 2.7,
                  child: Stack(
                    children: [
                      Row(
                        children: [
                          AspectRatio(
                            aspectRatio: 0.9,
                            child: CachedNetworkImage(
                              imageUrl: hotelListData.imageUrl,
                              placeholder: (context, url) => Center(child: CircularProgressIndicator()), // Hiển thị khi ảnh đang load
                              errorWidget: (context, url, error) => Icon(Icons.error),     // Hiển thị khi có lỗi tải ảnh
                              fit: BoxFit.cover, // Tùy chỉnh cách hiển thị ảnh
                            ),
                          ),
                          Expanded(
                              child: Container(
                                padding: EdgeInsets.all(
                                  MediaQuery.of(context).size.width > 360 ? 12 : 8
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      hotelListData.name,
                                      maxLines: 2,
                                      textAlign: TextAlign.left,
                                      style: TextStyles(context).getBoldStyle().copyWith(
                                        fontSize: 16
                                      ),
                                    ),
                                    Text(
                                      hotelListData.address,
                                      maxLines: 2,
                                      textAlign: TextAlign.left,
                                      style: TextStyles(context).getDescriptionStyle().copyWith(
                                          fontSize: 14
                                      ),
                                    ),
                                    Expanded(
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Expanded(
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      Icon(FontAwesomeIcons.mapMarkedAlt, size: 12, color: Theme.of(context).primaryColor),
                                                      SizedBox(width: 5,),
                                                      Expanded(
                                                          child: Text(
                                                            // "${hotelListData.dist.toStringAsFixed(1)}",
                                                            hotelListData.description,
                                                            overflow: TextOverflow.ellipsis,
                                                            textAlign: TextAlign.left,
                                                            style: TextStyles(context).getDescriptionStyle().copyWith(
                                                                fontSize: 16
                                                            ),
                                                          ),
                                                      ),
                                                      // Expanded(
                                                      //   child: Text(
                                                      //     AppLocalizations(context).of("km_to_city"),
                                                      //     overflow: TextOverflow.ellipsis,
                                                      //     textAlign: TextAlign.left,
                                                      //     style: TextStyles(context).getDescriptionStyle().copyWith(
                                                      //         fontSize: 16
                                                      //     ),
                                                      //   ),
                                                      // ),
                                                      SizedBox(width: 10.0,)
                                                    ],
                                                  ),
                                                  Helper.ratingStar(),
                                                ],
                                              )
                                          ),
                                          FittedBox(
                                            child: Padding(
                                              padding: EdgeInsets.only(right: 8),
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    // "${hotelListData.perNight}",
                                                    hotelListData.status,
                                                    textAlign: TextAlign.left,
                                                    style: TextStyles(context).getBoldStyle().copyWith(
                                                        fontSize: 22
                                                    ),
                                                  ),
                                                  Text(
                                                    AppLocalizations(context).of("per_night"),
                                                    textAlign: TextAlign.left,
                                                    style: TextStyles(context).getDescriptionStyle().copyWith(
                                                        fontSize: 14
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          )

                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              )
                          )
                        ],
                      ),
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          highlightColor: Colors.transparent,
                          splashColor: Theme.of(context).primaryColor.withOpacity(0.1),
                          onTap: (){
                            try{
                              callback();
                            } catch (e){

                            }
                          },
                          
                        ),
                      )
                    ],
                  ),
                ),
              ),
          ),
        )
    );
  }
}
