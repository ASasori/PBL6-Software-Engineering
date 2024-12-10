import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../language/appLocalizations.dart';
import '../../models/hotel.dart';
import '../../models/hotel_list_data.dart';
import '../../providers/theme_provider.dart';
import '../../utils/enum.dart';
import '../../utils/helper.dart';
import '../../utils/text_styles.dart';
import '../../utils/themes.dart';
import '../../widgets/common_card.dart';
import '../../widgets/list_cell_animation_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
class HotelListView extends StatelessWidget {
  final bool isShowDate;
  final VoidCallback callback;
  final Hotel hotelByLocation;
  final AnimationController animationController;
  final Animation<double> animation;

  const HotelListView(
      {Key? key,
        required this.hotelByLocation,
        required this.animationController,
        required this.animation,
        required this.callback,
        this.isShowDate = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListCellAnimationView(
      animation: animation,
      animationController: animationController,
      child: Padding(
        padding: const EdgeInsets.only(left: 24, right: 24, top: 8, bottom: 16),
        child: Column(
          children: <Widget>[
            CommonCard(
              color: AppTheme.backgroundColor,
              radius: 16,
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(16.0)),
                child: Stack(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        AspectRatio(
                          aspectRatio: 2,
                          child: (hotelByLocation.galleryImages.isNotEmpty)
                              ? CachedNetworkImage(
                            imageUrl: hotelByLocation.galleryImages[1].imageUrl,
                            placeholder: (context, url) =>
                                Center(child: CircularProgressIndicator()),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                            fit: BoxFit.cover,
                          )
                              : Container(
                            color: Colors.grey.shade200,
                            child: Icon(Icons.image_not_supported,
                                color: Colors.grey, size: 40),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 16, top: 8, bottom: 8, right: 8),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        hotelByLocation.name,
                                        textAlign: TextAlign.left,
                                        style: TextStyles(context)
                                            .getBoldStyle()
                                            .copyWith(fontSize: 22),
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                        MainAxisAlignment.start,
                                        children: <Widget>[
                                          Icon(
                                            FontAwesomeIcons.mapMarkerAlt,
                                            size: 12,
                                            color:
                                            Theme.of(context).primaryColor,
                                          ),
                                          Text(
                                            // "${hotelData.dist.toStringAsFixed(1)}",
                                            "${hotelByLocation.address}",
                                            overflow: TextOverflow.ellipsis,
                                            softWrap: true,
                                            style: TextStyles(context).getDescriptionStyle(),
                                          ),
                                          const SizedBox(width: 4,),
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 4),
                                        child: Row(
                                          children: <Widget>[
                                            Helper.ratingStar(),
                                            Text(
                                              " ${hotelByLocation.views}",
                                              style: TextStyles(context)
                                                  .getDescriptionStyle(),
                                            ),
                                            Text(
                                              AppLocalizations(context).of("views"),
                                              style: TextStyles(context)
                                                  .getDescriptionStyle(),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      bottom: 0,
                      left: 0,
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          highlightColor: Colors.transparent,
                          splashColor:
                          Theme.of(context).primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.all(
                            Radius.circular(16.0),
                          ),
                          onTap: () {
                            try {
                              callback();
                            } catch (e) {}
                          },
                        ),
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        decoration: BoxDecoration(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            shape: BoxShape.circle),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.all(
                              Radius.circular(32.0),
                            ),
                            onTap: () {},
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.favorite_border,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}