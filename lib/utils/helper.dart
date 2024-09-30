import 'package:booking_hotel_app/language/appLocalizations.dart';
import 'package:booking_hotel_app/models/room_data.dart';
import 'package:booking_hotel_app/motel_app.dart';
import 'package:booking_hotel_app/providers/theme_provider.dart';
import 'package:booking_hotel_app/utils/enum.dart';
import 'package:booking_hotel_app/utils/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class Helper {
  static Widget ratingStar({double rating = 4.5}){
    return RatingBarIndicator(
      rating: rating,
      itemBuilder: (context, index) => Icon(
        Icons.star,
        color: AppTheme.primaryColor
      ),
      itemCount: 5,
      unratedColor: AppTheme.secondaryTextColor,
      itemSize: 18.0,
      direction: Axis.horizontal,
    );
  }

  static String getRoomText(RoomData roomData){
    return "${roomData.numberRoom} ${AppLocalizations(applicationcontext!).of("room_data")} ${roomData.people} ${AppLocalizations(applicationcontext!).of("people_data")}";
  }

  static String getListSearchedDate(DateText dateText){
    LanguageType _languageType = applicationcontext == null ? LanguageType.en : applicationcontext!.read<ThemeProvider>().languageType;
    return "${dateText.startDate} - ${dateText.endDate} ${DateFormat('MMM', _languageType.toString().split('.')[1]).format(DateTime.now().add(Duration(days: 2)))}";
  }
}