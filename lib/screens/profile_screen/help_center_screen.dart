import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../language/appLocalizations.dart';
import '../../models/setting_list_data.dart';
import '../../utils/text_styles.dart';
import '../../utils/themes.dart';
import '../../widgets/common_appbar_view.dart';
import '../../widgets/common_card.dart';
import '../../widgets/common_search_bar.dart';
import '../../widgets/remove_focuse.dart';

class HelpCenterScreen extends StatefulWidget {
  @override
  _HelpCenterScreenState createState() => _HelpCenterScreenState();
}

class _HelpCenterScreenState extends State<HelpCenterScreen> {
  @override
  Widget build(BuildContext context) {
    List<SettingsListData> helpSearchList = SettingsListData.helpSearchList;
    return Scaffold(
      body: RemoveFocuse(
        onclick: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              color: Theme.of(context).primaryColor,
              child: Padding(
                padding: EdgeInsets.only(bottom: 24),
                child: appBar(),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).padding.bottom),
                itemCount: helpSearchList.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: helpSearchList[index].subTxt != ""
                        ? () {
                            // NavigationServices(context).gotoHowDoScreen();
                          }
                        : null,
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
                                    helpSearchList[index].titleTxt != ""
                                        ? AppLocalizations(context)
                                            .of(helpSearchList[index].titleTxt)
                                        : AppLocalizations(context)
                                            .of(helpSearchList[index].subTxt),
                                    style: TextStyles(context)
                                        .getRegularStyle()
                                        .copyWith(
                                            fontWeight: helpSearchList[index]
                                                        .titleTxt !=
                                                    ""
                                                ? FontWeight.bold
                                                : FontWeight.normal,
                                            fontSize: helpSearchList[index]
                                                        .titleTxt !=
                                                    ""
                                                ? 18
                                                : 14),
                                  ),
                                ),
                              ),
                              helpSearchList[index].subTxt != ""
                                  ? Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: Icon(Icons.keyboard_arrow_right,
                                          color: Theme.of(context)
                                              .disabledColor
                                              .withOpacity(0.3)),
                                    )
                                  : SizedBox()
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
      ),
    );
  }

  Widget appBar() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        CommonAppbarView(
          onBackClick: () {
            Navigator.pop(context);
          },
          iconData: Icons.arrow_back,
          titleText: AppLocalizations(context).of("how_can_help_you"),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 24, right: 24, top: 16),
          child: CommonCard(
            color: AppTheme.backgroundColor,
            radius: 36,
            child: CommonSearchBar(
              iconData: FontAwesomeIcons.search,
              text: AppLocalizations(context).of("search_help_artical"),
            ),
          ),
        ),
      ],
    );
  }
}
