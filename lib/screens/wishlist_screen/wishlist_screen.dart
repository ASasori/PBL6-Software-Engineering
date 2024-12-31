import 'package:booking_hotel_app/models/wishlist_item.dart';
import 'package:booking_hotel_app/providers/wish_list_provider.dart';
import 'package:booking_hotel_app/widgets/common_button.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../language/appLocalizations.dart';
import '../../routes/route_names.dart';
import '../../utils/helper.dart';
import '../../utils/text_styles.dart';
import '../../utils/themes.dart';
import '../../widgets/common_card.dart';
import '../../widgets/common_snack_bar.dart';

class WishlistScreen extends StatefulWidget {
  final AnimationController animationController;

  const WishlistScreen({super.key, required this.animationController});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  String Publishablekey =
      "pk_test_51Q7TR2B1Dpb6dXWmD5g6dAuCHf5Co92kXqxZOI2yTOuC4lnZYSa6EGmYaZjAhfYVqMAXlPWft1HaIJT01qW29RVF0009iOraPk";
  String Secretkey =
      "sk_test_51Q7TR2B1Dpb6dXWmXNRStuPl01fVTeLAldCoudxmojsxj2ItvE5ebRctIHHOt0vznsI2KO8LTRuc9Ftcm112Hman00huhYGhWI";
  late List<WishlistItem> wishlist;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        duration: Duration(milliseconds: 2000), vsync: this);
    widget.animationController.forward();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<WishlistProvider>(context, listen: false).fetchWishlist();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          getAppBarUI(),
          Expanded(
            child: Consumer<WishlistProvider>(
              builder: (BuildContext context, provider, widget) {
                if (provider.wishlist.isEmpty) {
                  return const Center(
                    child: Text(
                      'Your Wishlist is Empty',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18.0),
                    ),
                  );
                } else {
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: provider.wishlist.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(
                            left: 24, right: 24, top: 8, bottom: 16),
                        child: Column(
                          children: [
                            Container(
                              height: 160,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: Colors.grey.withOpacity(0.5),
                                  width: 1.5,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12.withOpacity(0.1),
                                    blurRadius: 6,
                                    offset: Offset(0, 3), // Shadow offset
                                  ),
                                ],
                              ),
                              child: Row(
                                children: <Widget>[
                                  CommonCard(
                                    color: AppTheme.backgroundColor,
                                    radius: 16,
                                    child: SizedBox(
                                      height: 160,
                                      child: ClipRRect(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(16.0)),
                                        child: AspectRatio(
                                          aspectRatio: 1.0,
                                          child: provider.wishlist[index]
                                                  .imageUrl.isNotEmpty
                                              ? CachedNetworkImage(
                                                  imageUrl: provider
                                                      .wishlist[index].imageUrl,
                                                  placeholder: (context, url) =>
                                                      const Center(
                                                          child:
                                                              CircularProgressIndicator()),
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          Icon(Icons.error),
                                                  fit: BoxFit.cover,
                                                )
                                              : const Center(
                                                  child: Icon(Icons.error)),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      height: 170,
                                      padding: const EdgeInsets.only(
                                          left: 16,
                                          top: 8,
                                          bottom: 8,
                                          right: 8),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            provider.wishlist[index].hotelName,
                                            maxLines: 1,
                                            textAlign: TextAlign.left,
                                            style: TextStyles(context)
                                                .getBoldStyle()
                                                .copyWith(
                                                  fontSize: 16,
                                                ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Text(
                                            provider.wishlist[index].address,
                                            style: TextStyles(context)
                                                .getBoldStyle()
                                                .copyWith(
                                                  fontSize: 14,
                                                ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Text(
                                            Helper
                                                .getDateTextFromCheckinDateAndCheckoutDate(
                                                    provider.wishlist[index]
                                                        .startDate,
                                                    provider.wishlist[index]
                                                        .endDate),
                                            maxLines: 2,
                                            textAlign: TextAlign.left,
                                            style: TextStyles(context)
                                                .getRegularStyle()
                                                .copyWith(
                                                  fontSize: 12,
                                                ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Text(
                                            '${provider.wishlist[index].typeRoom} - ${provider.wishlist[index].roomNumber}',
                                            maxLines: 2,
                                            textAlign: TextAlign.left,
                                            style: TextStyles(context)
                                                .getRegularStyle()
                                                .copyWith(
                                                  fontSize: 12,
                                                ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          FittedBox(
                                            child: SizedBox(
                                              width: 150,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: <Widget>[
                                                      Text(
                                                        "\$${provider.wishlist[index].pricePernight}",
                                                        textAlign:
                                                            TextAlign.left,
                                                        style: TextStyles(
                                                                context)
                                                            .getRegularStyle()
                                                            .copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontSize: 12,
                                                            ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(top: 2.0),
                                                        child: Text(
                                                          AppLocalizations(
                                                                  context)
                                                              .of("per_night"),
                                                          style: TextStyles(
                                                                  context)
                                                              .getRegularStyle()
                                                              .copyWith(
                                                                fontSize: 14,
                                                              ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: FittedBox(
                                              child: SizedBox(
                                                width: 200,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: <Widget>[
                                                    Text(
                                                      "Total: ",
                                                      style: TextStyles(context)
                                                          .getRegularStyle()
                                                          .copyWith(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontSize: 20,
                                                          ),
                                                    ),
                                                    Text(
                                                      "\$${provider.wishlist[index].totalAmount}",
                                                      style: TextStyles(context)
                                                          .getRegularStyle()
                                                          .copyWith(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontSize: 20,
                                                          ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CommonButton(
                                  buttonTextWidget: Padding(
                                    padding: const EdgeInsets.only(
                                      left: 24,
                                      right: 24,
                                      top: 8,
                                      bottom: 8,
                                    ),
                                    child: Text(
                                      "Checkout",
                                      style: TextStyles(context)
                                          .getTitleStyle()
                                          .copyWith(
                                              color: AppTheme.whiteColor,
                                              fontSize: 18),
                                    ),
                                  ),
                                  backgroundColor: Theme.of(context).primaryColor,
                                  onTap: () {
                                    NavigationServices(context)
                                        .gotoCheckoutScreen(
                                            provider.wishlist[index]);
                                  },
                                ),
                                CommonButton(
                                  buttonTextWidget: Padding(
                                    padding: const EdgeInsets.only(
                                      left: 24,
                                      right: 24,
                                      top: 8,
                                      bottom: 8,
                                    ),
                                    child: Text(
                                      "Remove",
                                      style: TextStyles(context)
                                          .getTitleStyle()
                                          .copyWith(
                                              color: AppTheme.whiteColor,
                                              fontSize: 18),
                                    ),
                                  ),
                                  backgroundColor: Colors.red.withOpacity(0.8),
                                  onTap: () async {
                                    provider.removeTotalPrice(provider
                                            .wishlist[index].endDate
                                            .difference(provider
                                                .wishlist[index].startDate)
                                            .inDays *
                                        provider.wishlist[index].pricePernight
                                            .toDouble());
                                    final errorMessage =
                                        await provider.deleteCartItem(provider
                                            .wishlist[index].itemCartId);
                                    CommonSnackBar.show(
                                      context: context,
                                      iconData: errorMessage == null
                                          ? Icons.check_circle
                                          : Icons.error_outline,
                                      iconColor: errorMessage == null
                                          ? Colors.white
                                          : Colors.red,
                                      message: errorMessage ??
                                          'Delete cart item successful!',
                                      backgroundColor: errorMessage == null
                                          ? Theme.of(context).primaryColor
                                          : Colors.black87,
                                    );
                                    setState(() {});
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Divider(
                              thickness: 1.5,
                              color: Colors.grey.withOpacity(0.3),
                              indent: 24,
                              endIndent: 24, // Align with padding
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget getAppBarUI() {
    return Padding(
      padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + 16 + 28,
          left: 24,
          right: 16,
          bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Text(
              "My Wishlist",
              style: TextStyles(context).getTitleStyle(),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
