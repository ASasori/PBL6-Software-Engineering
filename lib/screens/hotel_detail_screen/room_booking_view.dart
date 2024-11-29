import 'package:booking_hotel_app/models/booking.dart';
import 'package:booking_hotel_app/providers/wish_list_provider.dart';
import 'package:booking_hotel_app/screens/hotel_detail_screen/select_room_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../language/appLocalizations.dart';
import '../../models/hotel_list_data.dart';
import '../../models/room.dart';
import '../../models/room_data.dart';
import '../../utils/helper.dart';
import '../../utils/localfiles.dart';
import '../../utils/text_styles.dart';
import '../../widgets/common_button.dart';

class RoomBookView extends StatefulWidget {
  final RoomType roomTypeData;
  final String hotelSlug;
  final AnimationController animationController;
  final Animation<double> animation;
  final DateTime startDate,endDate;
  final RoomData roomData;

  const RoomBookView(
      {Key? key,
        required this.roomTypeData,
        required this.hotelSlug,
        required this.animationController,
        required this.animation,
        required this.startDate,
        required this.endDate,
        required this.roomData,
      })
      : super(key: key);

  @override
  _RoomBookViewState createState() => _RoomBookViewState();
}

class _RoomBookViewState extends State<RoomBookView> {
  var pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    var wishlist = Provider.of<WishlistProvider>(context);

    // List<String>? images = widget.roomData.imageUrl?.split(" ");
    return AnimatedBuilder(
      animation: widget.animationController,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: widget.animation,
          child: new Transform(
            transform: new Matrix4.translationValues(
                0.0, 40 * (1.0 - widget.animation.value), 0.0),
            child: Column(
              children: <Widget>[
                Stack(
                  alignment: Alignment.bottomCenter,
                  children: <Widget>[
                    AspectRatio(
                      aspectRatio: 1.5,
                      child: CachedNetworkImage(
                        placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                        imageUrl: widget.roomTypeData.imageUrl, // Hiển thị khi ảnh đang load
                        errorWidget: (context, url, error) => Icon(Icons.error),     // Hiển thị khi có lỗi tải ảnh
                        fit: BoxFit.cover,
                      ),
                      // child: PageView(
                      //   controller: pageController,
                      //   pageSnapping: true,
                      //   scrollDirection: Axis.horizontal,
                      //   children: <Widget>[
                      //     for (var image in images!)
                      //       CachedNetworkImage(
                      //         imageUrl: image,
                      //         placeholder: (context, url) => Center(child: CircularProgressIndicator()), // Hiển thị khi ảnh đang load
                      //         errorWidget: (context, url, error) => Icon(Icons.error),     // Hiển thị khi có lỗi tải ảnh
                      //         fit: BoxFit.cover,
                      //       )
                      //   ],
                      // ),
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.all(8.0),
                    //   child: SmoothPageIndicator(
                    //     controller: pageController, // PageController
                    //     count: 3,
                    //     effect: WormEffect(
                    //         activeDotColor: Theme.of(context).primaryColor,
                    //         dotColor: Theme.of(context).scaffoldBackgroundColor,
                    //         dotHeight: 10.0,
                    //         dotWidth: 10.0,
                    //         spacing: 5.0), // your preferred effect
                    //     onDotClicked: (index) {},
                    //   ),
                    // ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 16, right: 16, bottom: 16, top: 16),
                  child: Column(
                    children: <Widget>[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            widget.roomTypeData.type,
                            maxLines: 2,
                            textAlign: TextAlign.left,
                            style: TextStyles(context)
                                .getBoldStyle()
                                .copyWith(fontSize: 24),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Expanded(child: SizedBox()),
                          SizedBox(
                            height: 38,
                            child: CommonButton(
                              buttonTextWidget: Padding(
                                padding: const EdgeInsets.only(
                                    left: 16.0, right: 16.0, top: 4, bottom: 4),
                                child: Text(
                                  "Select room",
                                  textAlign: TextAlign.center,
                                  style: TextStyles(context).getRegularStyle(),
                                ),
                              ),
                              onTap: () {
                                _showSelectRoomDialog(context,  widget.roomTypeData.type);
                              },
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "\$${widget.roomTypeData.price}",
                            textAlign: TextAlign.left,
                            style: TextStyles(context)
                                .getBoldStyle()
                                .copyWith(fontSize: 22),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 0),
                            child: Text(
                              AppLocalizations(context).of("per_night"),
                              style: TextStyles(context)
                                  .getRegularStyle()
                                  .copyWith(fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            // 'Room data is fixing',
                            // Helper.getPeopleandChildren(
                            //     widget.roomData),
                            // "${widget.roomData}",
                            "${widget.roomTypeData.roomCapacity} people",
                            textAlign: TextAlign.left,
                            style: TextStyles(context).getDescriptionStyle(),
                          ),
                          InkWell(
                            borderRadius:
                            BorderRadius.all(Radius.circular(4.0)),
                            onTap: () {},
                            child: Padding(
                              padding: const EdgeInsets.only(left: 0, right: 4),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    AppLocalizations(context)
                                        .of("more_details"),
                                    style: TextStyles(context).getBoldStyle(),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 2),
                                    child: Icon(
                                      Icons.keyboard_arrow_down,
                                      // color: Theme.of(context).backgroundColor,
                                      size: 24,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),

                        ],
                      ),
                    ],
                  ),
                ),
                Divider(
                  height: 1,
                )
              ],
            ),
          ),
        );
      },
    );
  }

  void _showSelectRoomDialog(BuildContext context, String TypeRoom) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SelectRoomDialog(
            roomTypeData: widget.roomTypeData,
            hotelSlug: widget.hotelSlug,
            startDate: widget.startDate,
            endDate: widget.endDate,
            roomData: widget.roomData,
        ) ;// Use the new StatefulWidget
      },
    );
  }

}