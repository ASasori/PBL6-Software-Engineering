import 'package:booking_hotel_app/models/profile.dart';
import 'package:booking_hotel_app/utils/themes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../language/appLocalizations.dart';
import '../../providers/auth_provider.dart';
import '../../utils/text_styles.dart';
import '../../widgets/common_appbar_view.dart';
import '../../widgets/common_snack_bar.dart';
import '../../widgets/common_textfield_view.dart';

class UpdateProfileScreen extends StatefulWidget {
  final Profile profile;
  const UpdateProfileScreen({super.key, required this.profile});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async{
      Provider.of<AuthProvider>(context, listen: false).resetError();
      Provider.of<AuthProvider>(context, listen: false).initialValue(widget.profile);
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      backgroundColor: AppTheme.scaffoldBackgroundColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            color: Theme.of(context).primaryColor,
            child: Padding(
              padding: EdgeInsets.only(bottom: 12),
              child: appBar(),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: authProvider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CommonTextFieldView(
                            controller: authProvider.controllers['fullName'],
                            errorText: authProvider.errors['fullName'],
                            titleText: AppLocalizations(context).of("your_full_name"),
                            padding: const EdgeInsets.only(bottom: 10),
                            hintText: AppLocalizations(context).of("enter_your_full_name"),
                            keyboardType: TextInputType.text,
                            onChanged: (String txt) {authProvider.validateField('fullName');},
                          ),
                          CommonTextFieldView(
                            controller: authProvider.controllers['phone'],
                            errorText: authProvider.errors['phone'],
                            titleText: AppLocalizations(context).of("your_phone_number"),
                            padding: const EdgeInsets.only(bottom: 10),
                            hintText: AppLocalizations(context).of("enter_your_phone"),
                            keyboardType: TextInputType.phone,
                            onChanged: (String txt) {authProvider.validateField('phone');},
                          ),
                          CommonTextFieldView(
                            titleText: "Gender",
                            controller: authProvider.controllers['gender'],
                            errorText: authProvider.errors['gender'],
                            hintText: "Enter your gender",
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            keyboardType: TextInputType.text,
                            onChanged: (String txt) {authProvider.validateField('gender');},
                          ),
                          CommonTextFieldView(
                            titleText: "Country",
                            controller: authProvider.controllers['country'],
                            hintText: "Enter your country",
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            keyboardType: TextInputType.text,
                          ),
                          CommonTextFieldView(
                            titleText: "City",
                            controller: authProvider.controllers['city'],
                            hintText: "Enter your city",
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            keyboardType: TextInputType.text,
                          ),
                          CommonTextFieldView(
                            titleText: "State",
                            controller: authProvider.controllers['state'],
                            hintText: "Enter your state",
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            keyboardType: TextInputType.text,
                          ),
                          CommonTextFieldView(
                            titleText: "Address",
                            controller: authProvider.controllers['address'],
                            hintText: "Enter your address",
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            keyboardType: TextInputType.text,
                          ),
                          const SizedBox(height: 24),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    elevation: 3,
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text(
                                    "Cancel",
                                    style: TextStyles(context)
                                        .getRegularStyle()
                                        .copyWith(
                                            color:
                                                Theme.of(context).primaryColor),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Theme.of(context).primaryColor,
                                    elevation: 6,
                                  ),
                                  onPressed: () async {
                                    bool result =
                                        await authProvider.updateProfile(
                                            authProvider.controllers['fullName']!.text.trim(),
                                            authProvider.controllers['phone']!.text.trim(),
                                            authProvider.controllers['gender']!.text.trim(),
                                            authProvider.controllers['country']!.text.trim(),
                                            authProvider.controllers['city']!.text.trim(),
                                            authProvider.controllers['state']!.text.trim(),
                                            authProvider.controllers['address']!.text.trim(),
                                            null,
                                            null);
                                    if (result) {
                                      CommonSnackBar.show(
                                          context: context,
                                          iconData: Icons.check_circle,
                                          iconColor: Colors.white,
                                          message:
                                              "Update profile successfully",
                                          backgroundColor:
                                              Theme.of(context).primaryColor);
                                      Navigator.of(context).pop;
                                    } else {
                                      CommonSnackBar.show(
                                          context: context,
                                          iconData: Icons.error_outline,
                                          iconColor: Colors.red,
                                          message: "Failed to update profile",
                                          backgroundColor: Colors.black87);
                                    }
                                  },
                                  child: Text(
                                    "Save",
                                    style: TextStyles(context)
                                        .getRegularStyle()
                                        .copyWith(color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget appBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        CommonAppbarView(
          onBackClick: () {
            Navigator.pop(context);
          },
          iconData: Icons.arrow_back,
          titleText: AppLocalizations(context).of("edit_profile"),
        ),
        Expanded(child: SizedBox()),
      ],
    );
  }
}
