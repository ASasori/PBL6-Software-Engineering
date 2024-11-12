import 'package:booking_hotel_app/providers/auth_provider.dart';
import 'package:booking_hotel_app/providers/hotel_provider.dart';
import 'package:booking_hotel_app/providers/room_provider.dart';
import 'package:booking_hotel_app/providers/wish_list_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:booking_hotel_app/utils/themes.dart';
import 'package:booking_hotel_app/providers/theme_provider.dart';
import 'package:booking_hotel_app/motel_app.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
      .then((_) => runApp(_setAllProviders()));
}

Widget _setAllProviders() {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (_) => ThemeProvider(
          state: AppTheme.getThemeData,
        ),
      ),
      ChangeNotifierProvider( // Thêm HotelProvider vào đây
        create: (_) => HotelProvider(),
      ),  
      ChangeNotifierProvider(
        create: (_) => AuthProvider(),
      ),
      ChangeNotifierProvider(
        create: (_) => RoomProvider(),
      ),
      ChangeNotifierProvider(
          create: (_) => WishlistProvider()
      )
    ],
    child: MotelApp(),
  );
}
