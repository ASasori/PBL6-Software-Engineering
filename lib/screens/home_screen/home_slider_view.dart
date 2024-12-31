import 'dart:async';
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
  var currentShowIndex = 0;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<HotelProvider>(context, listen: false)
          .fetchTopHotels()
          .then((_) {
        setState(() {
          _startSliderTimer();
        });
      });
    });
  }

  void _startSliderTimer() {
    sliderTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (mounted && pageController.hasClients) {
        int nextPage = ((pageController.page!.toInt()) + 1) %
            Provider.of<HotelProvider>(context, listen: false).topHotels.length;
        pageController.animateToPage(
          nextPage,
          duration: const Duration(seconds: 1),
          curve: Curves.fastOutSlowIn,
        );
      }
    });
  }

  @override
  void dispose() {
    sliderTimer.cancel();
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Consumer<HotelProvider>(
        builder: (context, hotelProvider, child) {
          return Stack(
            children: [
              hotelProvider.isLoading
                  ? const Center(child: CircularProgressIndicator())
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
                          hotelData: hotelProvider.topHotels[index],
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
        },
      ),
    );
  }
}

class PagePopup extends StatelessWidget {
  final Hotel hotelData;
  final double opValue;

  const PagePopup({super.key, required this.hotelData, required this.opValue});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.width * 1.3,
          width: MediaQuery.of(context).size.width,
          child: (hotelData.galleryImages.isNotEmpty)
              ? CachedNetworkImage(
            imageUrl:
            hotelData.galleryImages[0].imageUrl,
            placeholder: (context, url) =>
            const Center(child: CircularProgressIndicator()),
            errorWidget: (context, url, error) =>
            const Icon(Icons.error),
            fit: BoxFit.cover,
          )
              : Container(
            color: Colors.grey.shade200,
            child: const Icon(Icons.image_not_supported,
                color: Colors.grey, size: 40),
          ),
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
                SizedBox(
                  child: Text(
                    hotelData.name,
                    textAlign: TextAlign.left,
                    style: TextStyles(context).getTitleStyle().copyWith(
                          color: AppTheme.whiteColor,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  child: Text(
                    hotelData.address,
                    textAlign: TextAlign.left,
                    style: TextStyles(context).getTitleStyle().copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.whiteColor,
                        ),
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
