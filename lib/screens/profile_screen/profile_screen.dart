import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../language/appLocalizations.dart';
import '../../models/setting_list_data.dart';
import '../../providers/theme_provider.dart';
import '../../routes/route_names.dart';
import '../../utils/localfiles.dart';
import '../../utils/text_styles.dart';
import '../../utils/themes.dart';
import '../../widgets/bottom_top_move_animation_view.dart';

class ProfileScreen extends StatefulWidget {
  final AnimationController animationController;

  const ProfileScreen({Key? key, required this.animationController})
      : super(key: key);
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  List<SettingsListData> userSettingsList = SettingsListData.userSettingsList;

  @override
  void initState() {
    widget.animationController.forward();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BottomTopMoveAnimationView(
        animationController: widget.animationController,
        child: Consumer<ThemeProvider>(
          builder: (context, provider, child) => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding:
                EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                child: Container(child: appBar()),
              ),
              Expanded(
                child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                  padding: EdgeInsets.all(0.0),
                  itemCount: userSettingsList.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () async {
                        //setting screen view
                        if (index == 4) {
                          NavigationServices(context).gotoSettingsScreen();

                          //   setState(() {});
                        }
                        //help center screen view

                        if (index == 2) {
                          NavigationServices(context).gotoHelpCenterScreen();
                        }
                        //Chage password  screen view

                        if (index == 0) {
                          NavigationServices(context)
                              .gotoChangePasswordScreen();
                        }
                        //Invite friend  screen view

                        // if (index == 1) {
                        //   NavigationServices(context).gotoInviteFriend();
                        // }
                      },
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(left: 8, right: 16),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Text(
                                      AppLocalizations(context).of(
                                        userSettingsList[index].titleTxt,
                                      ),
                                      style: TextStyles(context)
                                          .getRegularStyle()
                                          .copyWith(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Container(
                                    child: Icon(
                                        userSettingsList[index].iconData,
                                        color: AppTheme.secondaryTextColor
                                            .withOpacity(0.7)),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 16, right: 16),
                            child: Divider(
                              height: 1,
                            ),
                          )
                        ],
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ));
  }

  Widget appBar() {
    return InkWell(
      onTap: () {
        NavigationServices(context).gotoEditProfileScreen();
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding:
            const EdgeInsets.only(right: 0, top: 16, bottom: 16, left: 24),
            child: Container(
              width: 70,
              height: 70,
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(40.0)),
                child: Image.asset(Localfiles.userImage),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 24, right: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Bui Nhan",
                    style: new TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    AppLocalizations(context).of("view_edit"),
                    style: new TextStyle(
                      fontSize: 18,
                      color: Theme.of(context).disabledColor,
                    ),
                  ),
                ],
              ),
            ),
          ),

        ],
      ),
    );
  }
}