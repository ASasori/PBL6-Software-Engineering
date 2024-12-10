import 'dart:io';
import 'package:booking_hotel_app/common/common.dart';
import 'package:booking_hotel_app/language/appLocalizations.dart';
import 'package:booking_hotel_app/screens/splash/introductionScreen.dart';
import 'package:booking_hotel_app/screens/splash/splashScreen.dart';
import 'package:booking_hotel_app/providers/theme_provider.dart';
import 'package:booking_hotel_app/routes/routes.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

BuildContext? applicationcontext;

class MotelApp extends StatefulWidget {
  const MotelApp({super.key});

  @override
  State<StatefulWidget> createState() => _MotelAppState();
}

class _MotelAppState extends State<MotelApp> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
        builder: (_, provider, child){
          applicationcontext = context;
          final ThemeData _theme =  provider.themeData;
          return MaterialApp(
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate
            ],
            supportedLocales: const [
              const Locale("en"),
              const Locale("vn")

            ],
            navigatorKey: navigatorKey,
            title: "Hotel",
            debugShowCheckedModeBanner: false,
            theme: _theme,
            routes: _buildRoutes(),
            builder: (BuildContext context, Widget? child){
              _setFirstTimeSomeData(context, _theme);
              return Directionality(
                  textDirection: TextDirection.ltr,
                  child: Builder(
                    builder: (BuildContext context){
                      return MediaQuery(
                          data: MediaQuery.of(context).copyWith(
                            textScaleFactor: MediaQuery.of(context).size.width > 360 ? 1.0  :  (MediaQuery.of(context).size.width >= 340 ? 0.9 : 0.8)
                          ),
                          child: child ?? SizedBox()
                      );
                    }
                  ),
              );
            },
          );
        }
    );
  }

  Map<String, WidgetBuilder> _buildRoutes() {
    return {
      RoutesName.Slash: (BuildContext context) => SplashScreen(),
      RoutesName.IntroductionScreen: (BuildContext context) => IntroductionScreen(),
    };
  }

  void _setFirstTimeSomeData(BuildContext context,ThemeData _theme){
    applicationcontext = context;
    _setStatusBarNavigationBarTheme(_theme);
    // we call some them basis data set in the app like color, font, theme mode,..
    context.read<ThemeProvider>().checkAndSetThemeMode(MediaQuery.of(context).platformBrightness);
    context.read<ThemeProvider>().checkAndSetColorType();
    context.read<ThemeProvider>().checkAndSetFonType();
    context.read<ThemeProvider>().checkAndSetLanguage();
  }

  void _setStatusBarNavigationBarTheme(ThemeData themeData) {
    final brightness = !kIsWeb && Platform.isAndroid ? (themeData.brightness == Brightness.light ? Brightness.dark : Brightness.light) : themeData.brightness;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: brightness,
      statusBarIconBrightness: brightness,
      systemNavigationBarColor: themeData.scaffoldBackgroundColor,
      systemNavigationBarDividerColor: Colors.transparent,
      systemNavigationBarIconBrightness: brightness
    ));
  }
}
