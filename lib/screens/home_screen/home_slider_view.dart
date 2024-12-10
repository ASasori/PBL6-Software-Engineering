import 'dart:async';

// import 'package:booking_hotel_app/language/appLocalizations.dart';
// import 'package:booking_hotel_app/modules/splash/components/page_popview.dart';
// import 'package:booking_hotel_app/utils/localfiles.dart';

import 'package:booking_hotel_app/utils/text_styles.dart';
import 'package:booking_hotel_app/utils/themes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:booking_hotel_app/models/hotel.dart';
import '../../providers/hotel_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';


class HomeSliderView extends StatefulWidget {
  final double opValue;
  final VoidCallback click;
  const HomeSliderView({super.key, required this.opValue, required this.click});

  @override
  State<HomeSliderView> createState() => _HomeSliderViewState();
}

class _HomeSliderViewState extends State<HomeSliderView> {
  var pageController = PageController(initialPage: 0);
  late Timer sliderTimer;
  var currentShowIndex = 0 ;

  @override
  void initState() {
    // don't use fixed data. Convert to dynamic data from Json (API)
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<HotelProvider>(context, listen: false).fetchTopHotels().then((_) {
        setState(() {
          _startSliderTimer(); // Chỉ khởi động slider sau khi đã có dữ liệu
        });
      });
    });
  }
  void _startSliderTimer() {
    sliderTimer = Timer.periodic(Duration(seconds: 4), (timer) {
      if (mounted && pageController.hasClients) {
        int nextPage = ((pageController.page!.toInt()) + 1) % Provider.of<HotelProvider>(context, listen: false).topHotels.length;
        pageController.animateToPage(
          nextPage,
          duration: Duration(seconds: 1),
          curve: Curves.fastOutSlowIn,
        );
      }
    });
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
      child: Consumer <HotelProvider> (
        builder: (context, hotelProvider, child) {
          return Stack(
            children: [
              // Check if data is loading
              hotelProvider.isLoading
                  ? Center(child: CircularProgressIndicator())
                  : PageView.builder(
                controller: pageController,
                pageSnapping: true,
                onPageChanged: (index) {
                  setState(() {
                    currentShowIndex = index;
                  });
                },
                scrollDirection: Axis.horizontal,
                itemCount: hotelProvider.topHotels.length,
                itemBuilder: (BuildContext context, int index) {
                  return PagePopup(
                    imageData: hotelProvider.topHotels[index],
                    opValue: widget.opValue,
                  );
                },
              ),
              if (hotelProvider.topHotels.isNotEmpty)
                Positioned(
                  bottom: 32,
                  right: 32,
                  child: SmoothPageIndicator(
                    controller: pageController,
                    count: hotelProvider.topHotels.length,
                    effect: WormEffect(
                      activeDotColor: Theme.of(context).primaryColor,
                      dotColor: Colors.white,
                      dotHeight: 10,
                      dotWidth: 10,
                      spacing: 5.0,
                    ),
                  ),
                ),
            ],
          );
        }
      )
    );
  }
}

class PagePopup extends StatelessWidget {
  final Hotel imageData;
  final double opValue;
  const PagePopup({super.key, required this.imageData, required this.opValue});

  @override
  Widget build(BuildContext context) {
    return Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.width * 1.3,
            width: MediaQuery.of(context).size.width,
            child: imageData.galleryImages.isNotEmpty ? CachedNetworkImage(
              imageUrl: imageData.galleryImages[0].imageUrl,
              placeholder: (context, url) => Center(child: CircularProgressIndicator()), // Hiển thị khi ảnh đang load
              errorWidget: (context, url, error) => Icon(Icons.error),     // Hiển thị khi có lỗi tải ảnh
              fit: BoxFit.cover,
            ): Center(child: Icon(Icons.error)),
          ),
          Positioned(
              bottom: 80,
              left: 24,
              right: 24,
              child: Opacity(
                opacity: opValue,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Text(
                        imageData.name, // Sử dụng trực tiếp tên của khách sạn
                        textAlign: TextAlign.left,
                        style: TextStyles(context).getTitleStyle().copyWith(
                          color: AppTheme.whiteColor,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Container(
                      child: Text(
                        imageData.address, // Sử dụng trực tiếp địa chỉ của khách sạn
                        textAlign: TextAlign.left,
                        style: TextStyles(context).getTitleStyle().copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.whiteColor,
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

