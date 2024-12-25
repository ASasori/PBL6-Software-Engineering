import 'package:booking_hotel_app/models/location.dart';
import 'package:booking_hotel_app/utils/text_styles.dart';
import 'package:booking_hotel_app/utils/themes.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CategoryView extends StatefulWidget {
  final VoidCallback callback;
  final Location popularLocation;
  final AnimationController animationController;
  final Animation<double> animation;

  const CategoryView(
      {super.key,
      required this.callback,
      required this.popularLocation,
      required this.animationController,
      required this.animation});

  @override
  _CategoryViewState createState() => _CategoryViewState();
}

class _CategoryViewState extends State<CategoryView> {
  int _currentPage = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    _startAutoPlay();
  }

  void _startAutoPlay() {
    Future.delayed(Duration(seconds: 4)).then((_) {
      if (_pageController.hasClients) {
        setState(() {
          _currentPage = (_currentPage + 1) %
              widget.popularLocation.imageLocationList.length;
        });
        _pageController.animateToPage(
          _currentPage,
          duration: Duration(microseconds: 500),
          curve: Curves.easeInOut,
        );
      }
      _startAutoPlay();
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.animationController,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: widget.animation,
          child: Transform(
            transform: Matrix4.translationValues(
                100 * (1.0 - widget.animation.value), 0, 0),
            child: child,
          ),
        );
      },
      child: InkWell(
        onTap: () {
          widget.callback();
        },
        child: Padding(
          padding: const EdgeInsets.only(left: 16, bottom: 24, top: 16, right: 16),
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0)),
            child: Stack(
              children: [
                AspectRatio(
                  aspectRatio: 2,
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: widget.popularLocation.imageLocationList.length,
                    itemBuilder: (context, index) {
                      String imagePath = widget
                          .popularLocation.imageLocationList[index].imagePath;
                      return (imagePath.isNotEmpty)
                          ? CachedNetworkImage(
                              imageUrl: imagePath,
                              placeholder: (context, url) => const Center(
                                  child: CircularProgressIndicator()),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                              fit: BoxFit.cover,
                            )
                          : Container(
                              color: Colors.grey.shade200,
                              child: const Icon(Icons.image_not_supported,
                                  color: Colors.grey, size: 40),
                            );
                    },
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                          child: Container(
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                          colors: [
                            AppTheme.secondaryTextColor.withOpacity(0.4),
                            AppTheme.secondaryTextColor.withOpacity(0.0)
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        )),
                        child: Padding(
                          padding: EdgeInsets.only(
                              left: 8, bottom: 32, top: 8, right: 8),
                          child: Text(
                            widget.popularLocation.location,
                            style: TextStyles(context).getBoldStyle().copyWith(
                                fontSize: 21, color: AppTheme.whiteColor),
                          ),
                        ),
                      ))
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
