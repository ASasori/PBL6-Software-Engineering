import 'package:booking_hotel_app/utils/text_styles.dart';
import 'package:booking_hotel_app/utils/themes.dart';
import 'package:booking_hotel_app/widgets/common_card.dart';
import 'package:booking_hotel_app/widgets/list_cell_animation_view.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:booking_hotel_app/models/hotel.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HotelListView extends StatelessWidget {
  final bool isShowData;
  final VoidCallback callback;
  final Hotel hotelListData;
  final AnimationController animationController;
  final Animation<double> animation;

  const HotelListView(
      {super.key,
      this.isShowData = false,
      required this.callback,
      required this.hotelListData,
      required this.animationController,
      required this.animation});

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
                        child: (hotelListData.galleryImages.isNotEmpty)
                            ? CachedNetworkImage(
                                imageUrl:
                                    hotelListData.galleryImages[0].imageUrl,
                                placeholder: (context, url) =>
                                    const Center(child: CircularProgressIndicator()),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                                fit: BoxFit.cover,
                              )
                            : Container(
                                color: Colors.grey.shade200,
                                child: const Icon(Icons.image_not_supported,
                                    color: Colors.grey, size: 40),
                              ),
                      ),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(
                              MediaQuery.of(context).size.width > 360 ? 12 : 8),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                hotelListData.name,
                                maxLines: 2,
                                textAlign: TextAlign.left,
                                style: TextStyles(context)
                                    .getBoldStyle()
                                    .copyWith(fontSize: 16),
                              ),
                              Row (
                                children: [
                                  Icon(Icons.phone,
                                      size: 12,
                                      color: Theme.of(context)
                                          .primaryColor),
                                  const SizedBox(width: 10),
                                  Text(
                                    hotelListData.mobile,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.left,
                                    style: TextStyles(context)
                                        .getDescriptionStyle()
                                        .copyWith(fontSize: 13),
                                  ),
                                ],
                              ),
                              Expanded(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Icon(
                                                  FontAwesomeIcons.mapMarkedAlt,
                                                  size: 12,
                                                  color: Theme.of(context)
                                                      .primaryColor),
                                              const SizedBox(width: 10),
                                              Expanded(
                                                child: Text(
                                                  hotelListData.address,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  textAlign: TextAlign.left,
                                                  style: TextStyles(context)
                                                      .getDescriptionStyle()
                                                      .copyWith(fontSize: 13),
                                                  maxLines: 2,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 5),
                                          Expanded(
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Icon(Icons.visibility,
                                                    size: 12,
                                                    color: Theme.of(context)
                                                        .primaryColor),
                                                const SizedBox(width: 10),
                                                Expanded(
                                                  child: Text(
                                                    "${hotelListData.views}",
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    textAlign: TextAlign.left,
                                                    style: TextStyles(context)
                                                        .getDescriptionStyle()
                                                        .copyWith(fontSize: 13),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    FittedBox(
                                      child: Padding(
                                        padding: EdgeInsets.only(right: 8),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              hotelListData.status,
                                              textAlign: TextAlign.left,
                                              style: TextStyles(context)
                                                  .getBoldStyle()
                                                  .copyWith(fontSize: 20, color: Theme.of(context).primaryColor),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      highlightColor: Colors.transparent,
                      splashColor:
                          Theme.of(context).primaryColor.withOpacity(0.1),
                      onTap: () {
                        try {
                          callback();
                        } catch (e) {}
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
