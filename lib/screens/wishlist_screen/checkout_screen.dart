import 'package:booking_hotel_app/models/wishlist_item.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../utils/text_styles.dart';
import '../../widgets/common_button.dart';
import '../../widgets/remove_focuse.dart';

class CheckoutScreen extends StatefulWidget {
  final WishlistItem cartItem;
  const CheckoutScreen({super.key, required this.cartItem});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();}

class _CheckoutScreenState extends State<CheckoutScreen> {
  TextEditingController _couponCodeController = TextEditingController();
  TextEditingController _fullNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
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
                  child: SingleChildScrollView( // Wrap with SingleChildScrollView
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _bookingSummaryCard(),
                          const SizedBox(height: 20),
                          _billingInformationCard(),
                          const SizedBox(height: 20,),
                          CommonButton(
                            padding: EdgeInsets.only(
                                left: 24, right: 24, bottom: 16
                            ),
                            buttonText: "Pay",
                            onTap: () async {
                            },
                          )
                        ],
                      ),
                    ),
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
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top, left: 8, right: 8),
      child:Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            width: AppBar().preferredSize.height ,
            height: AppBar().preferredSize.height,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.all(Radius.circular(32.0)),
                onTap: () {
                  Navigator.pop(context);
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
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
                    borderRadius: BorderRadius.all(
                      Radius.circular(32.0),
                    ),
                    onTap: () {},
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
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

  Widget _bookingSummaryCard() {
    return Card(
      elevation: 3, // Add elevation for a shadow effect
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10), // Rounded corners
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Booking Summary",
              style: TextStyles(context).getTitleStyle().copyWith(
                fontSize: 18, // Increase font size
                fontWeight: FontWeight.bold, // Make it bold
              ),
            ),
            SizedBox(height: 10), // Add spacingDivider(color: Colors.grey[300]), // Subtle divider
            _summaryItem("Check-in", DateFormat('yyyy-MM-dd').format(widget.cartItem.startDate)),
            _summaryItem("Check-out", DateFormat('yyyy-MM-dd').format(widget.cartItem.endDate)),
            _summaryItem("Total Days", "${widget.cartItem.endDate.difference(widget.cartItem.startDate).inDays}"),
            _summaryItem("Adults", "${widget.cartItem.adult}"),
            _summaryItem("Children", "${widget.cartItem.children}"),
            _summaryItem("Original Price", "\$${widget.cartItem.totalAmount}"),
            _summaryItem("Discount", "\$0"),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _couponCodeController,
                    decoration: InputDecoration(
                      hintText: "Enter Coupon Code",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8), // Rounded input field
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10), // Add spacing
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor, // Use primary color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8), // Rounded button
                    ),
                  ),
                  child: Text("Apply", style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _billingInformationCard() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.0),
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
            const SizedBox(height: 10),
            Divider(color: Colors.grey[300]),
            // Improved input fields with labels
            TextFormField(
              controller: _fullNameController,
              decoration: InputDecoration(
                labelText: "Full Name",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            SizedBox(height: 10), // Add spacing between fields
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _phoneNumberController,
              decoration: InputDecoration(
                labelText: "Phone",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
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
}