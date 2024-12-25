import 'package:booking_hotel_app/models/available_room.dart';
import 'package:booking_hotel_app/providers/wish_list_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../language/appLocalizations.dart';
import '../../models/room_data.dart';
import '../../utils/text_styles.dart';
import '../../widgets/common_button.dart';
import '../../widgets/common_snack_bar.dart';

class RoomBookView extends StatefulWidget {
  final AvailableRoom roomData;
  final String hotelSlug;
  final AnimationController animationController;
  final Animation<double> animation;
  final DateTime startDate, endDate;
  final RoomData roomDataPeople;

  const RoomBookView({
    Key? key,
    required this.roomData,
    required this.hotelSlug,
    required this.animationController,
    required this.animation,
    required this.startDate,
    required this.endDate,
    required this.roomDataPeople,
  }) : super(key: key);

  @override
  _RoomBookViewState createState() => _RoomBookViewState();
}

class _RoomBookViewState extends State<RoomBookView> {
  var pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    var wishlist = Provider.of<WishlistProvider>(context);

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
                // Stack(
                //   alignment: Alignment.bottomCenter,
                //   children: <Widget>[
                //     AspectRatio(
                //       aspectRatio: 1.5,
                //       child: CachedNetworkImage(
                //         placeholder: (context, url) =>
                //             Center(child: CircularProgressIndicator()),
                //         imageUrl: widget.roomData.roomType.imageUrl,
                //         errorWidget: (context, url, error) => Icon(Icons.error),
                //         fit: BoxFit.cover,
                //       ),
                //       // child: PageView(
                //       //   controller: pageController,
                //       //   pageSnapping: true,
                //       //   scrollDirection: Axis.horizontal,
                //       //   children: <Widget>[
                //       //     for (var image in images!)
                //       //       CachedNetworkImage(
                //       //         imageUrl: image,
                //       //         placeholder: (context, url) => Center(child: CircularProgressIndicator()), // Hiển thị khi ảnh đang load
                //       //         errorWidget: (context, url, error) => Icon(Icons.error),     // Hiển thị khi có lỗi tải ảnh
                //       //         fit: BoxFit.cover,
                //       //       )
                //       //   ],
                //       // ),
                //     ),
                //     // Padding(
                //     //   padding: const EdgeInsets.all(8.0),
                //     //   child: SmoothPageIndicator(
                //     //     controller: pageController, // PageController
                //     //     count: 3,
                //     //     effect: WormEffect(
                //     //         activeDotColor: Theme.of(context).primaryColor,
                //     //         dotColor: Theme.of(context).scaffoldBackgroundColor,
                //     //         dotHeight: 10.0,
                //     //         dotWidth: 10.0,
                //     //         spacing: 5.0), // your preferred effect
                //     //     onDotClicked: (index) {},
                //     //   ),
                //     // ),
                //   ],
                // ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 16, right: 16, bottom: 16, top: 16),
                  child: Column(
                    children: <Widget>[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            widget.roomData.roomType ?? ' ',
                            maxLines: 2,
                            textAlign: TextAlign.left,
                            style: TextStyles(context)
                                .getBoldStyle()
                                .copyWith(fontSize: 24),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Expanded(child: SizedBox()),
                          Text(
                            '${AppLocalizations(context).of("room_data")} ${widget.roomData.roomNumber}',
                            style: TextStyles(context)
                                .getBoldStyle()
                                .copyWith(fontSize: 24),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "\$${widget.roomData.price}",
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
                            "${widget.roomData.capacity ?? ' '} people",
                            textAlign: TextAlign.left,
                            style: TextStyles(context).getDescriptionStyle(),
                          ),
                          SizedBox(
                            height: 38,
                            child: CommonButton(
                              buttonTextWidget: Padding(
                                padding: const EdgeInsets.only(
                                    left: 16.0, right: 16.0, top: 4, bottom: 4),
                                child: Text(
                                  "Add to wishlist",
                                  textAlign: TextAlign.center,
                                  style: TextStyles(context).getRegularStyle(),
                                ),
                              ),
                              onTap: () async {
                                _addToWishList(
                                    widget.roomData.roomId!,
                                    widget.roomData.checkInDate,
                                    widget.roomData.checkOutDate,
                                    widget.roomData.adults,
                                    widget.roomData.children);
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1, color: Colors.grey),
              ],
            ),
          ),
        );
      },
    );
  }

  // void _showSelectRoomDialog(BuildContext context, String TypeRoom) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return SelectRoomDialog(
  //         roomTypeData: widget.roomData.roomType,
  //         hotelSlug: widget.hotelSlug,
  //         startDate: widget.startDate,
  //         endDate: widget.endDate,
  //         roomData: widget.roomDataPeople,
  //       ); // Use the new StatefulWidget
  //     },
  //   );
  // }

  void _addToWishList(int roomId, DateTime checkInDate, DateTime checkOutDate,
      int adult, int children) async {
    final wishlist = Provider.of<WishlistProvider>(context, listen: false);
    print('Before: ${adult} + ${children}');
    final errorMessage = await wishlist.addCartItem(
        roomId, checkInDate, checkOutDate, adult, children);

    if (errorMessage == null) wishlist.addCounter();
    CommonSnackBar.show(
      context: context,
      iconData: errorMessage == null
          ? Icons.check_circle
          : Icons.error_outline,
      iconColor:  errorMessage == null ? Colors.white : Colors.red,
      message: errorMessage ?? 'Room successfully added to wishlist!',
      backgroundColor: errorMessage == null ? Theme.of(context).primaryColor : Colors.black87,
    );
  }
}
