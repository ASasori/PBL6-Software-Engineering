import 'package:booking_hotel_app/language/appLocalizations.dart';
import 'package:booking_hotel_app/providers/theme_provider.dart';
import 'package:booking_hotel_app/routes/route_names.dart';
import 'package:booking_hotel_app/utils/localfiles.dart';
import 'package:booking_hotel_app/utils/text_styles.dart';
import 'package:booking_hotel_app/utils/themes.dart';
import 'package:booking_hotel_app/widgets/common_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget{
  SplashScreen({super.key});

  @override
  State<StatefulWidget> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isLoadText = false;

  @override
  void initState(){
    WidgetsBinding.instance!.addPostFrameCallback((_) => _loadApplicationLocalization());
    super.initState();
  }


  Future<void> _loadApplicationLocalization() async {
    try{
      //load all text json file to all the languageTextData(n common file)
      setState(() {
        isLoadText = true;
      });
    } catch(_) {}
  }

  @override
  Widget build(BuildContext context) {
    final appTheme = Provider.of<ThemeProvider>(context);
    return Container(
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            Container(
              foregroundDecoration: !appTheme.isLightMode ? BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.4))
              : null,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Image.asset(
                  Localfiles.introduction01,
                  fit: BoxFit.cover,
              ),
            ),
            Column(
              children: [
                const Expanded(
                    flex: 1,
                    child: SizedBox(),
                ),
                Center(
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).dividerColor,
                          offset: const Offset(1.1, 1.1),
                          blurRadius: 10.0
                        )
                      ]
                    ),
                    child: Image.asset(Localfiles.appIcon1),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                Text(
                  "Hotel",
                  textAlign: TextAlign.left,
                  style: TextStyles(context).getBoldStyle().copyWith(fontSize: 24),
                ),
                const SizedBox(
                  height: 8,
                ),
                AnimatedOpacity(
                  opacity: isLoadText ? 1.0 : 0.0,
                  duration: const Duration(microseconds: 420),
                  child: Text(
                    AppLocalizations(context).of("best_hotel_deals"),
                    textAlign: TextAlign.left,
                    style: TextStyles(context).getBoldStyle().copyWith(),
                  ),
                ),
                const Expanded(
                  flex: 4,
                  child: SizedBox(),
                ),
                AnimatedOpacity(
                  opacity: isLoadText ? 1.0 : 0.0,
                  duration: const Duration(microseconds: 680),
                  child: CommonButton(
                    padding: const EdgeInsets.only(
                      left: 48, right: 48, bottom: 8, top: 8
                    ),
                    buttonText: AppLocalizations(context).of("get_started"),
                    onTap: () {
                      NavigationServices(context).goToIntroductionScreen();

                    },
                  )
                ),
                AnimatedOpacity(
                    opacity: isLoadText ? 1.0 : 0.0,
                    duration: const Duration(microseconds: 680 ),
                    child: Padding(
                        padding: EdgeInsets.only(
                          bottom: 24.0 + MediaQuery.of(context).padding.bottom,
                          top: 16
                        ),
                        child: Text(
                          AppLocalizations(context).of("already_have_account"),
                          textAlign: TextAlign.left,
                          style: TextStyles(context).getBoldStyle().copyWith(
                            color: AppTheme.whiteColor
                          ),
                        ),
                    )
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

}