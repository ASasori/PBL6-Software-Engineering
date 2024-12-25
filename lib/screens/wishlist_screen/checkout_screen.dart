import 'package:booking_hotel_app/models/wishlist_item.dart';
import 'package:booking_hotel_app/providers/auth_provider.dart';
import 'package:booking_hotel_app/providers/booking_provider.dart';
import 'package:booking_hotel_app/providers/wish_list_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../language/appLocalizations.dart';
import '../../utils/enum.dart';
import '../../utils/text_styles.dart';
import '../../widgets/common_button.dart';
import '../../widgets/common_snack_bar.dart';
import '../../widgets/common_textfield_view.dart';
import '../../widgets/remove_focuse.dart';
import '../bottom_tab/bottom_tab_screen.dart';

class CheckoutScreen extends StatefulWidget {
  final WishlistItem cartItem;

  const CheckoutScreen({super.key, required this.cartItem});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen>
    with TickerProviderStateMixin {
  TextEditingController _couponCodeController = TextEditingController();
  TextEditingController _fullNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  bool isPayButtonEnabled = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<BookingProvider>(context, listen: false).resetBookingData();
      Provider.of<AuthProvider>(context, listen: false).resetError();
      Provider.of<AuthProvider>(context, listen: false).resetController();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          RemoveFocuse(
            onclick: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: Column(
              children: [
                _getAppBarUI(),
                Expanded(
                  child: Consumer<BookingProvider>(
                    builder: (context, bookingProvider, child) {
                      return SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _billingInformationCard(),
                              const SizedBox(height: 20),
                              _bookingSummaryCard(),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Total Amount",
                                        style: TextStyles(context)
                                            .getBoldStyle()
                                            .copyWith(fontSize: 22),
                                      ),
                                      Text(
                                        "\$${bookingProvider.bookingData.totalAmount ?? widget.cartItem.totalAmount}",
                                        style: TextStyles(context)
                                            .getBoldStyle()
                                            .copyWith(
                                                fontSize: 20,
                                                color: Colors.green),
                                      ),
                                    ],
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 30, vertical: 15),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(40),
                                        ),
                                        backgroundColor:
                                            Theme.of(context).primaryColor),
                                    onPressed: isPayButtonEnabled
                                        ? () async {
                                            CommonSnackBar.show(
                                              context: context,
                                              message:
                                                  'Proceeding to checkout...',
                                              backgroundColor: Colors.black87,
                                            );
                                            bool statusPayment =
                                                await bookingProvider
                                                    .initialCheckout(
                                                        (bookingProvider
                                                                    .bookingData
                                                                    .totalAmount ??
                                                                widget.cartItem
                                                                    .totalAmount)
                                                            .toInt(),
                                                        "USD",
                                                        bookingProvider
                                                            .bookingData
                                                            .bookingID,
                                                        widget.cartItem
                                                            .itemCartId);
                                            CommonSnackBar.show(
                                              context: context,
                                              iconData: statusPayment
                                                  ? Icons.check_circle
                                                  : Icons.error_outline,
                                              iconColor: statusPayment
                                                  ? Colors.white
                                                  : Colors.red,
                                              message: statusPayment
                                                  ? 'Payment success!'
                                                  : 'Payment failed!',
                                              backgroundColor: statusPayment
                                                  ? Theme.of(context).primaryColor
                                                  : Colors.black87,
                                            );
                                            if (statusPayment) {
                                              await Provider.of<
                                                          WishlistProvider>(
                                                      context,
                                                      listen: false)
                                                  .deleteCartItem(widget
                                                      .cartItem.itemCartId);
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const BottomTabScreen(
                                                              initialBottomBarType:
                                                                  BottomBarType
                                                                      .Trips)));
                                            }
                                          }
                                        : () {
                                            CommonSnackBar.show(
                                              context: context,
                                              iconData: Icons.error_outline,
                                              iconColor: Colors.red,
                                              message: AppLocalizations(context)
                                                  .of("fill_info_booking"),
                                              backgroundColor: Colors.black87,
                                            );
                                          },
                                    child: Text(
                                      "Pay with Stripe",
                                      style: TextStyles(context)
                                          .getRegularStyle()
                                          .copyWith(fontSize: 16),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _getAppBarUI() {
    return Padding(
      padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top, left: 8, right: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            width: AppBar().preferredSize.height,
            height: AppBar().preferredSize.height,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.all(Radius.circular(32.0)),
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(Icons.arrow_back),
                ),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                "Checkout",
                style: TextStyles(context).getTitleStyle(),
              ),
            ),
          ),
          Container(
            width: AppBar().preferredSize.height + 40,
            height: AppBar().preferredSize.height,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(32.0),
                    ),
                    onTap: () {},
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(Icons.payment),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _billingInformationCard() {
    final authProvider = Provider.of<AuthProvider>(context);
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Billing Information",
              style: TextStyles(context).getTitleStyle().copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            Divider(color: Colors.grey[300]),
            CommonTextFieldView(
              controller: authProvider.controllers['email'],
              errorText: authProvider.errors['email'],
              titleText: AppLocalizations(context).of("your_mail"),
              padding: const EdgeInsets.only(bottom: 10),
              hintText: AppLocalizations(context).of("enter_your_email"),
              keyboardType: TextInputType.emailAddress,
              onChanged: (String txt) {authProvider.validateField('email');},
            ),
            CommonTextFieldView(
              controller: authProvider.controllers['fullName'],
              errorText: authProvider.errors['fullName'],
              titleText: AppLocalizations(context).of("your_full_name"),
              padding: const EdgeInsets.only(bottom: 10),
              hintText: AppLocalizations(context).of("enter_your_full_name"),
              keyboardType: TextInputType.text,
              onChanged: (String txt) {authProvider.validateField('fullName');},
            ),
            CommonTextFieldView(
              controller: authProvider.controllers['phone'],
              errorText: authProvider.errors['phone'],
              titleText: AppLocalizations(context).of("your_phone_number"),
              padding: const EdgeInsets.only(bottom: 10),
              hintText: AppLocalizations(context).of("enter_your_phone"),
              keyboardType: TextInputType.phone,
              onChanged: (String txt) {authProvider.validateField('phone');},
            ),
            const SizedBox(height: 10),
            CommonButton(
              buttonText: "Continue Checkout",
              onTap: () {
                if (authProvider.validateBillingInfo()) {
                  _showConfirmationDialog(authProvider);
                } else {
                  CommonSnackBar.show(
                    context: context,
                    iconData: Icons.error_outline,
                    iconColor: Colors.red,
                    message: AppLocalizations(context).of("fill_info_booking"),
                    backgroundColor: Colors.black87,
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _bookingSummaryCard() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10), // Rounded corners
      ),
      child: Consumer<BookingProvider>(
        builder: (context, bookingProvider, child) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Booking Summary",
                  style: TextStyles(context).getTitleStyle().copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 10),
                _summaryItem("Check-in",
                    DateFormat('yyyy-MM-dd').format(widget.cartItem.startDate)),
                _summaryItem("Check-out",
                    DateFormat('yyyy-MM-dd').format(widget.cartItem.endDate)),
                _summaryItem("Total Days",
                    "${widget.cartItem.endDate.difference(widget.cartItem.startDate).inDays}"),
                _summaryItem("Adults", "${widget.cartItem.adult}"),
                _summaryItem("Children", "${widget.cartItem.children}"),
                _summaryItem(
                    "Original Price", "\$${widget.cartItem.totalAmount}"),
                _summaryItem("Discount", "\$${bookingProvider.discount}"),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _couponCodeController,
                        decoration: InputDecoration(
                          hintText: "Enter Coupon Code",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10), // Add spacing
                    ElevatedButton(
                      onPressed: isPayButtonEnabled
                          ? () async {
                              if (_couponCodeController.text
                                  .trim()
                                  .isNotEmpty) {
                                final errorMessage =
                                    await bookingProvider.getDiscount(
                                        bookingProvider.bookingData.bookingID,
                                        _couponCodeController.text.trim());
                                CommonSnackBar.show(
                                  context: context,
                                  iconData: errorMessage == null
                                      ? Icons.check_circle
                                      : Icons.error_outline,
                                  iconColor: errorMessage == null
                                      ? Colors.white
                                      : Colors.red,
                                  message: errorMessage ??
                                      'Coupon applied successfully!',
                                  backgroundColor: errorMessage == null
                                      ? Theme.of(context).primaryColor
                                      : Colors.black87,
                                );
                              }
                            }
                          : () {
                              CommonSnackBar.show(
                                context: context,
                                iconData: Icons.error_outline,
                                iconColor: Colors.red,
                                message: AppLocalizations(context)
                                    .of("fill_info_booking"),
                                backgroundColor: Colors.black87,
                              );
                            },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 13),
                        backgroundColor:
                            Theme.of(context).primaryColor, // Use primary color
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(40), // Rounded button
                        ),
                      ),
                      child: Text(
                        "Apply",
                        style: TextStyles(context).getRegularStyle(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _summaryItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyles(context).getDescriptionStyle()),
          Text(value, style: TextStyles(context).getRegularStyle()),
        ],
      ),
    );
  }

  void _showConfirmationDialog(AuthProvider authProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        elevation: 3,
        shadowColor: Colors.grey.withOpacity(0.9),
        title: const Icon(
          Icons.question_mark_outlined,
          color: Colors.red,
          size: 40,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Divider(height: 1, color: Colors.grey.withOpacity(0.5)),
            const SizedBox(height: 15),
            Text(
              AppLocalizations(context).of("confirm_book_room"),
              style: TextStyles(context)
                  .getTitleStyle()
                  .copyWith(color: Colors.black87),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 5),
            Text(
              AppLocalizations(context).of("check_info"),
              style: TextStyles(context)
                  .getRegularStyle()
                  .copyWith(color: Colors.black87),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 15),
            Divider(height: 1, color: Colors.grey.withOpacity(0.5)),
          ],
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 48,
                width: 110,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade300,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 3,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("Cancel",
                      style: TextStyles(context).getRegularStyle()),
                ),
              ),
              const SizedBox(width: 10),
              SizedBox(
                height: 48,
                width: 110,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 3,
                  ),
                  onPressed: () async {
                    final result = await Provider.of<BookingProvider>(context,
                            listen: false)
                        .continueCheckout(
                            widget.cartItem.hotelId,
                            widget.cartItem.roomId,
                            widget.cartItem.startDate,
                            widget.cartItem.endDate,
                            widget.cartItem.adult!,
                            widget.cartItem.children!,
                            widget.cartItem.rt_slug,
                            widget.cartItem.totalAmount,
                            authProvider.controllers['fullName']!.text.trim(),
                            authProvider.controllers['email']!.text.trim(),
                            authProvider.controllers['phone']!.text.trim());
                    Navigator.of(context).pop();
                    if (result) {
                      setState(() {
                        isPayButtonEnabled = true; // Bật nút Pay
                      });
                      CommonSnackBar.show(
                        context: context,
                        iconData: Icons.check_circle,
                        iconColor: Colors.white,
                        message: "Create booking successfully!",
                        backgroundColor: Theme.of(context).primaryColor,
                      );
                    } else {
                      CommonSnackBar.show(
                        context: context,
                        iconData: Icons.error_outline,
                        iconColor: Colors.red,
                        message: "Failed to create booking!",
                        backgroundColor: Colors.black87,
                      );
                    }
                  },
                  child:
                      Text("OK", style: TextStyles(context).getRegularStyle()),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
