import 'package:booking_hotel_app/models/location.dart';
import 'package:booking_hotel_app/utils/text_styles.dart';
import 'package:booking_hotel_app/utils/themes.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CategoryView extends StatefulWidget {
  final VoidCallback callback;
  final Location porpularLocation;
  final AnimationController animationController;
  final Animation<double> animation;

  const CategoryView({
    super.key,
    required this.callback,
    required this.porpularLocation,
    required this.animationController,
    required this.animation
  });

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

  void _startAutoPlay (){
    Future.delayed(Duration(seconds: 4)).then((_){
      if(_pageController.hasClients){
        setState((){
          _currentPage = (_currentPage + 1) % widget.porpularLocation.imageLocationList.length;
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
        builder: (BuildContext context, Widget? child){
          return FadeTransition(
            opacity: widget.animation,
            child: Transform(
              transform: Matrix4.translationValues(100 * (1.0 - widget.animation.value), 0, 0),
              child: child,
            ),
          );
        },
        child: InkWell(
          onTap: (){
            widget.callback();
          },
          child: Padding(
            padding: EdgeInsets.only(left: 16, bottom: 24, top: 16, right: 16),
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
              child: Stack(
                children: [
                  AspectRatio(
                    aspectRatio: 2,
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: widget.porpularLocation.imageLocationList.length,
                      itemBuilder: (context, index){
                        String imagePath =  widget.porpularLocation.imageLocationList[index].imagePath;
                        return CachedNetworkImage(
                          imageUrl: imagePath,
                          placeholder: (context, url) => Center(child: CircularProgressIndicator()), // Hiển thị khi ảnh đang load
                          errorWidget: (context, url, error) => Icon(Icons.error),     // Hiển thị khi có lỗi tải ảnh
                          fit: BoxFit.cover, // Tùy chỉnh cách hiển thị ảnh
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
                              )
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(left: 8, bottom: 32, top: 8, right: 8),
                              child: Text(
                                widget.porpularLocation.location,
                                style: TextStyles(context).getBoldStyle().copyWith(
                                  fontSize: 21,
                                  color: AppTheme.whiteColor
                                ),
                              ),
                            ),
                          )
                        )
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
