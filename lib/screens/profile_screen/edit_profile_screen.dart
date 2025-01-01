import 'package:booking_hotel_app/providers/auth_provider.dart';
import 'package:booking_hotel_app/routes/route_names.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../language/appLocalizations.dart';
import '../../models/setting_list_data.dart';
import '../../utils/text_styles.dart';
import '../../utils/themes.dart';
import '../../widgets/common_appbar_view.dart';
import '../../widgets/common_card.dart';
import '../../widgets/remove_focuse.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  List<SettingsListData> userInfoList = SettingsListData.userInfoList;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AuthProvider>(context, listen: false).fetchProfile();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return SizedBox(
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
              Container(
                color: Theme.of(context).primaryColor,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 12, right: 12),
                  child: appBar(),
                ),
              ),
              const SizedBox(height: 10),
              getProfileUI(),
              const SizedBox(height: 5),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildListTileProfile(
                          Icons.mail, "Email", authProvider.user.email),
                      _buildListTileProfile(Icons.person, "Full name",
                          authProvider.profile.fullName),
                      _buildListTileProfile(Icons.phone, "Phone number",
                          authProvider.profile.phone),
                      _buildListTileProfile(Icons.transgender, "Gender",
                          authProvider.profile.gender),
                      _buildListTileProfile(Icons.public, "Country",
                          authProvider.profile.country),
                      _buildListTileProfile(Icons.location_city, "City",
                          authProvider.profile.city),
                      _buildListTileProfile(Icons.location_on, "State",
                          authProvider.profile.state),
                      _buildListTileProfile(
                          Icons.map, "Address", authProvider.profile.address),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showImagePickerOption(BuildContext context, AuthProvider authProvider) {
    showModalBottomSheet(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          children: [
            ListTile(
              leading: Icon(
                Icons.photo_library,
                color: Theme.of(context).primaryColor,
                size: 24,
              ),
              title: Text(
                "Library",
                style: TextStyles(context)
                    .getRegularStyle()
                    .copyWith(color: Colors.black87),
              ),
              onTap: () async{
                Navigator.pop(context);
                await authProvider.pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: Icon(
                Icons.camera_alt,
                color: Theme.of(context).primaryColor,
                size: 24,
              ),
              title: Text(
                "Camera",
                style: TextStyles(context)
                    .getRegularStyle()
                    .copyWith(color: Colors.black87),
              ),
              onTap: () async{
                Navigator.pop(context);
                await authProvider.pickImage(ImageSource.camera);
              },
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildListTileProfile(
      IconData iconData, String title, String? trailingText) {
    return Column(
      children: [
        ListTile(
          leading: Icon(
            iconData,
            size: 26,
            color: Theme.of(context).primaryColor,
          ),
          title: Text(
            title,
            style: TextStyles(context)
                .getBoldStyle()
                .copyWith(color: Colors.black87, fontSize: 16),
          ),
          trailing: Text(
            trailingText ?? "",
            style: TextStyles(context)
                .getRegularStyle()
                .copyWith(color: Colors.black87, fontSize: 16),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(height: 5),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Divider(
            height: 1,
          ),
        ),
      ],
    );
  }
  Widget getProfileUI() {
    final authProvider = Provider.of<AuthProvider>(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
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
                    child: CachedNetworkImage(
                      placeholder: (context, url) =>
                          Center(child: CircularProgressIndicator()),
                      imageUrl: authProvider.profile.image ?? " ",
                      errorWidget: (context, url, error) => const Icon(
                        Icons.person,
                        color: Colors.grey,
                        size: 50,
                      ),
                      fit: BoxFit.cover,
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
                        onTap: () {
                          _showImagePickerOption(context, authProvider);
                        },
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
  Widget appBar() {
    final authProvider = Provider.of<AuthProvider>(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        CommonAppbarView(
          onBackClick: () {
            Navigator.pop(context);
          },
          iconData: Icons.arrow_back,
          titleText: AppLocalizations(context).of("view_profile"),
        ),
        Expanded(child: SizedBox()),
        IconButton(
          icon: const Icon(
            Icons.note_alt_outlined,
            size: 24,
            color: Colors.black87,
          ),
          onPressed: () {
            NavigationServices(context).gotoUpdateProfileScreen(authProvider.profile);
          },
        ),
      ],
    );
  }
}
