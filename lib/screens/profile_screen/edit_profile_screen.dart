import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../language/appLocalizations.dart';
import '../../models/profile.dart';
import '../../models/setting_list_data.dart';
import '../../models/user.dart';
import '../../utils/localfiles.dart';
import '../../utils/text_styles.dart';
import '../../utils/themes.dart';
import '../../widgets/common_appbar_view.dart';
import '../../widgets/common_card.dart';
import '../../widgets/remove_focuse.dart';

class EditProfileScreen extends StatefulWidget {
  final User user;
  final Profile profile;
  const EditProfileScreen ({super.key, required this.user, required this.profile});
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  List<SettingsListData> userInfoList = SettingsListData.userInfoList;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        backgroundColor: AppTheme.scaffoldBackgroundColor,
        body: RemoveFocuse(
          onclick: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              CommonAppbarView(
                iconData: Icons.arrow_back,
                titleText: AppLocalizations(context).of("edit_profile"),
                onBackClick: () {
                  Navigator.pop(context);
                },
              ),
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.only(
                      bottom: 16 + MediaQuery.of(context).padding.bottom),
                  itemCount: userInfoList.length,
                  itemBuilder: (context, index) {
                    return index == 0
                        ? getProfileUI()
                        : InkWell(
                      onTap: () {
                        _showEditDialog(context, index);
                      },
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding:
                            const EdgeInsets.only(left: 8, right: 16),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 16.0, bottom: 16, top: 16),
                                    child: Text(
                                      AppLocalizations(context).of(
                                          userInfoList[index].titleTxt),
                                      style: TextStyles(context)
                                          .getDescriptionStyle()
                                          .copyWith(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      right: 16.0, bottom: 16, top: 16),
                                  child: Container(
                                    child: Text(
                                      userInfoList[index].subTxt,
                                      style: TextStyles(context)
                                          .getRegularStyle()
                                          .copyWith(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                                Icon(Icons.edit, color: Colors.grey),
                              ],
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
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
      ),
    );
  }

  void _showEditDialog(BuildContext context, int index) {
    String? newValue; // To store the edited value

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit ${AppLocalizations(context).of(
              userInfoList[index].titleTxt)}'),
          content: TextField(
            onChanged: (value) {
              newValue = value;
            },
            controller: TextEditingController(text: userInfoList[index].subTxt), // Pre-fill with current value
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Save'),
              onPressed: () {
                if (newValue != null) {
                  setState(() {
                    userInfoList[index].subTxt = newValue!; // Update the value in the list
                  });
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }
  Widget getProfileUI() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 130,
            height: 130,
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor,
                    shape: BoxShape.circle,
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: Theme.of(context).dividerColor,
                        blurRadius: 8,
                        offset: Offset(4, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(60.0)),
                    child: widget.profile.image!.isNotEmpty
                        ? CachedNetworkImage(
                      placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                      imageUrl:  widget.profile.image!,
                      errorWidget: (context, url, error) => Icon(Icons.error),
                      fit: BoxFit.cover,
                    ) : const Icon (
                      Icons.person,
                      color: Colors.grey,
                      size: 50,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 6,
                  right: 6,
                  child: CommonCard(
                    color: AppTheme.primaryColor,
                    radius: 36,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.all(Radius.circular(24.0)),
                        onTap: () {},
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.camera_alt,
                            color: Theme.of(context).scaffoldBackgroundColor,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}