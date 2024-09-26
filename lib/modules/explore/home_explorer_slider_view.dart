import 'dart:async';

import 'package:booking_hotel_app/language/appLocalizations.dart';
import 'package:booking_hotel_app/modules/splash/components/page_popview.dart';
import 'package:booking_hotel_app/utils/localfiles.dart';
import 'package:booking_hotel_app/utils/text_styles.dart';
import 'package:booking_hotel_app/utils/themes.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomeExplorerSliderView extends StatefulWidget {
  final double opValue;
  final VoidCallback click;
  const HomeExplorerSliderView({super.key, required this.opValue, required this.click});

  @override
  State<HomeExplorerSliderView> createState() => _HomeExplorerSliderViewState();
}

class _HomeExplorerSliderViewState extends State<HomeExplorerSliderView> {
  var pageController = PageController(initialPage: 0);
  List<PageViewData> pageViewData = [];
  late Timer sliderTimer;
  var currentShowIndex = 0 ;

  @override
  void initState() {
    pageViewData.add(PageViewData(
        titleText: "cape Town",
        subText: "five_star",
        assetImage: Localfiles.explore_2
    ));
    pageViewData.add(PageViewData(
        titleText: "turkey",
        subText: "five_star",
        assetImage: Localfiles.explore_1
    ));
    pageViewData.add(PageViewData(
        titleText: "egypt",
        subText: "five_star",
        assetImage: Localfiles.explore_3
    ));
    sliderTimer = Timer.periodic(Duration(seconds: 4), (timer){
      if(mounted) {
        if (currentShowIndex==0){
          pageController.animateTo(
            MediaQuery.of(context).size.width,
            duration: Duration(seconds: 1),
            curve: Curves.fastOutSlowIn
          );
        } else if (currentShowIndex==1){
          pageController.animateTo(
              MediaQuery.of(context).size.width * 2,
              duration: Duration(seconds: 1),
              curve: Curves.fastOutSlowIn
          );
        } else if (currentShowIndex==2){
          pageController.animateTo(
              0,
              duration: Duration(seconds: 1),
              curve: Curves.fastOutSlowIn
          );
        }
      }
    });
    super.initState();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    sliderTimer.cancel();
    pageController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Stack(
        children: [
          PageView.builder(
            controller: pageController,
            pageSnapping: true,
            onPageChanged: (index){
              currentShowIndex = index;
            },
            scrollDirection: Axis.horizontal,
            itemCount: pageViewData.length,
            itemBuilder: (BuildContext context, int index) {
              return PagePopup(
                imageData: pageViewData[index],
                opValue: widget.opValue,
              );
            },
          ),
          Positioned(
            bottom: 32,
            right: 32,
            child: SmoothPageIndicator(
              controller: pageController,
              count: pageViewData.length,
              effect: WormEffect(
                activeDotColor: Theme.of(context).primaryColor,
                dotColor: Colors.white,
                dotHeight: 10,
                dotWidth: 10,
                spacing: 5.0,
              ),
              onDotClicked: (index){

              },
            )
          ),
        ],
      ),
    );
  }
}


class PagePopup extends StatelessWidget {
  final PageViewData imageData;
  final double opValue;
  const PagePopup({super.key, required this.imageData, required this.opValue});
  @override
  Widget build(BuildContext context) {
    return Stack(
      children:[
        Container(
          height: MediaQuery.of(context).size.width * 1.3,
          width: MediaQuery.of(context).size.width,
          child: Image.asset(imageData.assetImage, fit: BoxFit.cover,),
        ),
        Positioned(
          bottom: 80,
          left: 24,
          right: 24,
          child: Opacity(
            opacity: opValue,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment:  CrossAxisAlignment.start,
              children: [
                Container(
                  child:  Text(
                    AppLocalizations(context).of(imageData.titleText),
                    textAlign: TextAlign.left,
                    style: TextStyles(context).getTitleStyle().copyWith(color: AppTheme.whiteColor),
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Container(
                  child: Text(
                    AppLocalizations(context).of(imageData.subText),
                    textAlign: TextAlign.left,
                    style: TextStyles(context).getTitleStyle().copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.whiteColor
                    ),
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
              ],
            ),
          )
        ),
      ]
    );
  }
}

