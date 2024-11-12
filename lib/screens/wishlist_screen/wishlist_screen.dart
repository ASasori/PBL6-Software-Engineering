import 'package:booking_hotel_app/providers/wish_list_provider.dart';
import 'package:booking_hotel_app/widgets/common_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

class _WishlistScreenState extends State<WishlistScreen> with TickerProviderStateMixin{
  late AnimationController _animationController;

  @override
  void initState() {
    context.read<WishlistProvider>().getData();
    _animationController = AnimationController(
        duration: Duration(milliseconds: 2000), vsync: this);
    widget.animationController.forward();
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final wishlist = Provider.of<WishlistProvider>(context);
    return Scaffold(
      body: Column(
        children: [
          getAppBarUI(),
          Expanded(
              child: Consumer<WishlistProvider>(
                  builder: (BuildContext context, provider, widget) {
                    if (provider.wishilist.isEmpty) {
                      return const Center(
                          child: Text(
                            'Your Cart is Empty',
                            style:
                            TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                          ));
                    } else {
                      return ListView.builder(
                          shrinkWrap: true,
                          itemCount: provider.wishilist.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.only(left: 24, right: 24, top: 8, bottom: 16),
                              child: Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white, // Background color for the item
                                      borderRadius: BorderRadius.circular(16), // Rounded corners
                                      border: Border.all(
                                        color: Colors.grey.withOpacity(0.5), // Light grey border
                                        width: 1.5, // Border thickness
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black12.withOpacity(0.1), // Soft shadow
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
                                            height: 150,
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.all(Radius.circular(16.0)),
                                              child: AspectRatio(
                                                aspectRatio: 1.0,
                                                child: Image.asset(
                                                  provider.wishilist[index].imagePath,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      Expanded(
                                        child: Container(
                                          height: 150,
                                          padding: EdgeInsets.only(
                                              left:  16,
                                              top: 8,
                                              bottom: 8,
                                              right:  8),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                provider.wishilist[index].hotelName,
                                                maxLines: 2,
                                                textAlign: TextAlign.left,
                                                style: TextStyles(context).getBoldStyle().copyWith(
                                                  fontSize: 16,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              Text(
                                                provider.wishilist[index].address,
                                                style: TextStyles(context).getDescriptionStyle().copyWith(
                                                  fontSize: 14,
                                                ),
                                              ),
                                              Text(
                                                Helper.getDateTextFromCheckinDateAndCheckoutDate(provider.wishilist[index].startDate, provider.wishilist[index].endDate),
                                                maxLines: 2,
                                                textAlign: TextAlign.left,
                                                style: TextStyles(context).getRegularStyle().copyWith(
                                                  fontSize: 12,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              Text(
                                                provider.wishilist[index].typeRoom,
                                                maxLines: 2,
                                                textAlign: TextAlign.left,
                                                style: TextStyles(context).getRegularStyle().copyWith(
                                                  fontSize: 12,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              FittedBox(
                                                child: SizedBox(
                                                  width: 150,
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:MainAxisAlignment.start,
                                                        children: <Widget>[
                                                          Text(
                                                            "\$${provider.wishilist[index].pricePernight}",
                                                            textAlign: TextAlign.left,
                                                            style:
                                                            TextStyles(context).getRegularStyle().copyWith(
                                                              fontWeight: FontWeight.w600,
                                                              fontSize: 16,
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding: EdgeInsets.only(
                                                                top:2.0),
                                                            child: Text(
                                                              AppLocalizations(context).of("per_night"),
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
                                                        mainAxisAlignment:MainAxisAlignment.spaceBetween,
                                                        children: <Widget>[
                                                          Text(
                                                            "Total: ",
                                                            style:
                                                            TextStyles(context).getRegularStyle().copyWith(
                                                              fontWeight: FontWeight.w600,
                                                              fontSize: 22,
                                                            ),
                                                          ),
                                                          Text(
                                                            "\$${provider.wishilist[index].totalAmount}",
                                                            style:
                                                            TextStyles(context).getRegularStyle().copyWith(
                                                              fontWeight: FontWeight.w600,
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
                                        buttonTextWidget:  Padding(
                                                padding: EdgeInsets.only(
                                                  left: 24,
                                                  right: 24,
                                                  top: 8,
                                                  bottom: 8,
                                                ),
                                          child: Text(
                                            "Booking again",
                                            style: TextStyles(context).getTitleStyle().copyWith(
                                                color: AppTheme.whiteColor,
                                                fontSize: 18
                                            ),
                                          ),
                                        ),
                                        backgroundColor: Colors.green,
                                        onTap: (){

                                        },
                                      ),
                                      CommonButton(
                                        buttonTextWidget:  Padding(
                                          padding: EdgeInsets.only(
                                            left: 24,
                                            right: 24,
                                            top: 8,
                                            bottom: 8,
                                          ),
                                          child: Text(
                                            "Remove",
                                            style: TextStyles(context).getTitleStyle().copyWith(
                                                color: AppTheme.whiteColor,
                                                fontSize: 18
                                            ),
                                          ),
                                        ),
                                        backgroundColor: Colors.red.withOpacity(0.8),
                                        onTap: (){
                                          print(provider.wishilist[index].endDate!.difference(provider.wishilist[index].startDate!).inDays * provider.wishilist[index].pricePernight.toDouble());
                                          provider.removeTotalPrice(provider.wishilist[index].endDate!.difference(provider.wishilist[index].startDate!).inDays * provider.wishilist[index].pricePernight.toDouble());
                                          provider.removeCounter();
                                          provider.removeItem(provider.wishilist[index].bookingID!);
                                        },
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 16,
                                  ),
                                  Divider(
                                    thickness: 1.5, // Thickness of the divider
                                    color: Colors.grey.withOpacity(0.3), // Light grey color for the divider
                                    indent: 24, // Align with padding
                                    endIndent: 24, // Align with padding
                                  ),
                                ],
                              ),

                            );

                          }
                      );
                    }
                  }
              )
          ),
        ]
      ),
      bottomNavigationBar: getCheckoutBar(context, wishlist),
    );
  }

  Widget getAppBarUI() {
    return Padding(
      padding: EdgeInsets.only(
          top: MediaQuery
              .of(context)
              .padding
              .top + 16 + 28,
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

          //   )
        ],
      ),
    );
  }

  Widget getCheckoutBar(BuildContext context, WishlistProvider wishlist) {
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
                style: TextStyles(context)
                    .getBoldStyle()
                    .copyWith(fontSize: 18),
              ),
              Text(
                "\$${wishlist.getTotalPrice()}",
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
              backgroundColor: Theme.of(context).primaryColor
            ),
            onPressed: () {
              // Implement checkout functionality
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Proceeding to checkout...'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            child: Text(
              "Checkout",
              style: TextStyles(context)
                  .getBoldStyle()
                  .copyWith(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
