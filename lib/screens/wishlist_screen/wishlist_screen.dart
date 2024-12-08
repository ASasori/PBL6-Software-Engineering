import 'dart:convert';

import 'package:booking_hotel_app/models/wishlist_item.dart';
import 'package:booking_hotel_app/providers/wish_list_provider.dart';
import 'package:booking_hotel_app/utils/localfiles.dart';
import 'package:booking_hotel_app/widgets/common_button.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../../language/appLocalizations.dart';
import '../../utils/helper.dart';
import '../../utils/text_styles.dart';
import '../../utils/themes.dart';
import '../../widgets/common_card.dart';

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
    // context.read<WishlistProvider>().fetchWishlist();
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
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    return Scaffold(
      body: Column(children: [
        getAppBarUI(),
        Expanded(child: Consumer<WishlistProvider>(
            builder: (BuildContext context, provider, widget) {
          if (provider.wishlist == null || provider.wishlist.isEmpty) {
            return const Center(
              child: Text(
                'Your Wishlist is Empty',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
              ),
            );
          } else {
            return ListView.builder(
                shrinkWrap: true,
                itemCount: provider.wishlist.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(
                        left: 24, right: 24, top: 8, bottom: 16),
                    child: Column(
                      children: [
                        Container(
                          height: 170,
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
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(16.0)),
                                    child: AspectRatio(
                                      aspectRatio: 1.0,
                                      child: provider.wishlist[index].imageUrl
                                              .isNotEmpty
                                          ? CachedNetworkImage(
                                              imageUrl: provider
                                                  .wishlist[index].imageUrl,
                                              placeholder: (context, url) => Center(
                                                  child:
                                                      CircularProgressIndicator()),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      Icon(Icons.error),
                                              fit: BoxFit.cover,
                                            )
                                          : Center(child: Icon(Icons.error)),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  height: 170,
                                  padding: EdgeInsets.only(
                                      left: 16, top: 8, bottom: 8, right: 8),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        provider.wishlist[index].hotelName,
                                        maxLines: 2,
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
                                            .getDescriptionStyle()
                                            .copyWith(
                                              fontSize: 14,
                                            ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        Helper
                                            .getDateTextFromCheckinDateAndCheckoutDate(
                                                provider
                                                    .wishlist[index].startDate,
                                                provider
                                                    .wishlist[index].endDate),
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
                                        provider.wishlist[index].typeRoom,
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
                                                    textAlign: TextAlign.left,
                                                    style: TextStyles(context)
                                                        .getRegularStyle()
                                                        .copyWith(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: 12,
                                                        ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 2.0),
                                                    child: Text(
                                                      AppLocalizations(context)
                                                          .of("per_night"),
                                                      style: TextStyles(context)
                                                          .getDescriptionStyle()
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
                                                        fontSize: 22,
                                                      ),
                                                ),
                                                Text(
                                                  "\$${provider.wishlist[index].totalAmount}",
                                                  style: TextStyles(context)
                                                      .getRegularStyle()
                                                      .copyWith(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 22,
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
                        SizedBox(
                          height: 16,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CommonButton(
                              buttonTextWidget: Padding(
                                padding: EdgeInsets.only(
                                  left: 24,
                                  right: 24,
                                  top: 8,
                                  bottom: 8,
                                ),
                                child: Text(
                                  "Booking again",
                                  style: TextStyles(context)
                                      .getTitleStyle()
                                      .copyWith(
                                          color: AppTheme.whiteColor,
                                          fontSize: 18),
                                ),
                              ),
                              backgroundColor: Colors.green,
                              onTap: () {},
                            ),
                            CommonButton(
                              buttonTextWidget: Padding(
                                padding: EdgeInsets.only(
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
                                        .difference(
                                            provider.wishlist[index].startDate)
                                        .inDays *
                                    provider.wishlist[index].pricePernight
                                        .toDouble());
                                final errorMessage =
                                    await provider.deleteCartItem(
                                        provider.wishlist[index].itemCartId);

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Row(
                                      children: [
                                        errorMessage == null
                                            ? Icon(Icons.check_circle,
                                                color: Colors.green)
                                            : Icon(
                                                Icons.error_outline,
                                                color: Colors.red,
                                              ),
                                        // Add an icon
                                        SizedBox(width: 10),
                                        // Space between icon and text
                                        Expanded(
                                          child: Text(
                                            errorMessage ??
                                                'Delete cart item successful!',
                                            style: TextStyle(fontSize: 16),
                                          ),
                                        ),
                                        // Message text
                                      ],
                                    ),
                                    backgroundColor: Colors.black87,
                                    duration: Duration(seconds: 3),
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                    margin: EdgeInsets.all(16),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Divider(
                          thickness: 1.5,
                          color: Colors.grey.withOpacity(0.3),
                          indent: 24,
                          endIndent: 24, // Align with padding
                        ),
                      ],
                    ),
                  );
                });
          }
        })),
      ]),
      bottomNavigationBar: getCheckoutBar(context, wishlistProvider),
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

  Widget getCheckoutBar(
      BuildContext context, WishlistProvider wishlistProvider) {
    Stripe.publishableKey = Publishablekey;
    Stripe.instance.applySettings();

    Map<String, dynamic>? intentPaymentData;

    showPaymentSheet() async {
      try {
        await Stripe.instance.presentPaymentSheet().then((val) {
          intentPaymentData = null;
        }).onError((errorMsg, sTrace) {
          if (kDebugMode) {
            print(errorMsg.toString() + sTrace.toString());
          }
        });
      } on StripeException catch (error) {
        if (kDebugMode) {
          print(error);
        }
        showDialog(
            context: context,
            builder: (c) => const AlertDialog(
                  content: Text("Canceled"),
                ));
      } catch (errorMessage) {
        if (kDebugMode) {
          print(errorMessage);
        }
        print(errorMessage);
      }
    }

    makeIntentForPayment(amountToBeCharge, currency) async {
      try {
        Map<String, dynamic>? paymentInfo = {
          "amount": (int.parse(amountToBeCharge) * 100).toString(),
          "currency": currency,
          "payment_method_types[]": "card",
        };
        var responseFromStripeAPI = await http.post(
            Uri.parse("https://api.stripe.com/v1/payment_intents"),
            body: paymentInfo,
            headers: {
              "Authorization": "Bearer $Secretkey",
              "Content-Type": "application/x-www-form-urlencoded"
            });

        print("response from API = " + responseFromStripeAPI.body);

        return jsonDecode(responseFromStripeAPI.body);
      } catch (errorMessage, s) {
        if (kDebugMode) {
          print(s);
        }
        print(errorMessage);
      }
    }

    paymentSheetInitialization(amountToBeCharge, currency) async {
      try {
        intentPaymentData =
            await makeIntentForPayment(amountToBeCharge, currency);

        await Stripe.instance
            .initPaymentSheet(
                paymentSheetParameters: SetupPaymentSheetParameters(
          allowsDelayedPaymentMethods: true,
          // Main params
          merchantDisplayName: 'Flutter Stripe Store Demo',
          paymentIntentClientSecret: intentPaymentData!['client_secret'],
          style: ThemeMode.dark,
        ))
            .then((val) {
          print(val);
        });
        showPaymentSheet();
      } catch (errorMessage, s) {
        if (kDebugMode) {
          print(s);
        }
        print(errorMessage);
      }
    }

    return Container(
      height: 100,
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      decoration: BoxDecoration(
        color: AppTheme.backgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.5),
            blurRadius: 10,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Total Amount",
                style:
                    TextStyles(context).getBoldStyle().copyWith(fontSize: 18),
              ),
              Text(
                "\$${wishlistProvider.totalPrice}",
                style: TextStyles(context)
                    .getBoldStyle()
                    .copyWith(fontSize: 20, color: Colors.green),
              ),
            ],
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                backgroundColor: Theme.of(context).primaryColor),
            onPressed: () {
              if (wishlistProvider.totalPrice == 0.0) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        'Your wishlist is empty. Checkout is Notavailable!'),
                    duration: Duration(seconds: 2),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Proceeding to checkout...'),
                    duration: Duration(seconds: 2),
                  ),
                );
                paymentSheetInitialization(
                    wishlistProvider.totalPrice.round().toString(), "USD");
              }
            },
            child: Text(
              "Checkout",
              style: TextStyles(context).getBoldStyle().copyWith(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
