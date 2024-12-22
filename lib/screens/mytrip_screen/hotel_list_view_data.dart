import 'package:booking_hotel_app/models/booking.dart';
import 'package:booking_hotel_app/utils/helper.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../models/profile.dart';
import '../../utils/text_styles.dart';
import '../../utils/themes.dart';
import '../../widgets/common_card.dart';
import '../../widgets/list_cell_animation_view.dart';

class HotelListViewData extends StatelessWidget {
  final bool isShowDate;
  final VoidCallback callback;
  final Profile myProfile;

  // final HotelListData hotelData;
  final BookingData myBooking;
  final AnimationController animationController;
  final Animation<double> animation;

  const HotelListViewData(
      {Key? key,
      // required this.hotelData,
      required this.myBooking,
      required this.myProfile,
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: GestureDetector(
          // borderRadius: const BorderRadius.all(Radius.circular(16.0)),
          onTap: () {
            callback();
          },
          child: Column(
            children: [
              Row(
                children: <Widget>[
                  isShowDate
                      ? Expanded(
                          child: Row(
                            children: [
                              Expanded(
                                child: getUI(context),
                              ),
                              const SizedBox(width: 10),
                            ],
                          ),
                        )
                      : SizedBox(),
                  SizedBox(
                    height: 100,
                    child: ClipOval(
                      child: AspectRatio(
                        aspectRatio: 1.0,
                        child: CachedNetworkImage(
                          placeholder: (context, url) =>
                              const Center(child: CircularProgressIndicator()),
                          imageUrl: myProfile.image ?? " ",
                          errorWidget: (context, url, error) => const Icon(
                            Icons.person,
                            color: Colors.grey,
                            size: 100,
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  !isShowDate
                      ? Expanded(
                          child: Row(
                            children: [
                              const SizedBox(width: 10),
                              Expanded(
                                child: getUI(context),
                              ),
                            ],
                          ),
                        )
                      : SizedBox(),
                ],
              ),
              const Padding(
                padding: EdgeInsets.only(left: 30, right: 30, top: 16),
                child: Divider(
                  height: 1,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget getUI(BuildContext context) {
    return CommonCard(
      color: AppTheme.backgroundColor,
      radius: 16,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment:
              isShowDate ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: <Widget>[
            _textMyBooking(
                context, "Hotel name: ", myBooking.hotelName, isShowDate, 16),
            _textMyBooking(
                context, "Room type: ", myBooking.roomType, isShowDate, 12),
            _textMyBooking(
                context,
                "Date time: ",
                Helper.getDateTextFromCheckinDateAndCheckoutDate(
                    myBooking.startDate, myBooking.endDate),
                isShowDate,
                12),
            _textMyBooking(
                context,
                "People: ",
                Helper.getAdultsAndChildren(
                    myBooking.numberOfAdults, myBooking.numberOfChildren),
                isShowDate,
                12),
            // _textMyBooking(context, "Email: ", myBooking.email, isShowDate, 12),
            // _textMyBooking(context, "Full name: ", myBooking.fullName, isShowDate, 12),
            // _textMyBooking(context, "Phone: ", myBooking.phone, isShowDate, 12),
            _textMyBooking(context, "Price: ", '\$${myBooking.totalAmount}',
                isShowDate, 12),
            Align(
              alignment: Alignment.bottomRight,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                ),
                child: Text (
                  "View invoice",
                  style: TextStyles(context).getRegularStyle().copyWith(
                    fontSize: 14,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _textMyBooking(BuildContext context, String title, String text,
      bool isShowDate, double fontSize) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 1,
          child: Text(
            title,
            style: TextStyles(context).getBoldStyle().copyWith(
                  fontSize: fontSize,
                ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Text(
            text,
            maxLines: 2,
            style: TextStyles(context).getRegularStyle().copyWith(
                  fontSize: fontSize,
                ),
            overflow: TextOverflow.ellipsis,
          ),
        )
      ],
    );
  }
}
