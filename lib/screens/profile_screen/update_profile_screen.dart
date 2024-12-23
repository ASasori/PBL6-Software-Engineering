import 'package:booking_hotel_app/utils/themes.dart';
import 'package:booking_hotel_app/widgets/common_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../language/appLocalizations.dart';
import '../../providers/auth_provider.dart';
import '../../utils/text_styles.dart';
import '../../widgets/common_appbar_view.dart';
import '../../widgets/common_textfield_view.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  bool isLoading = true;

  late TextEditingController emailController;
  late TextEditingController fullNameController;
  late TextEditingController phoneController;
  late TextEditingController genderController;
  late TextEditingController countryController;
  late TextEditingController cityController;
  late TextEditingController stateController;
  late TextEditingController addressController;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.fetchProfile();

    setState(() {
      emailController = TextEditingController(text: authProvider.user.email);
      fullNameController =
          TextEditingController(text: authProvider.profile.fullName ?? "");
      phoneController = TextEditingController(text: authProvider.profile.phone);
      genderController =
          TextEditingController(text: authProvider.profile.gender);
      countryController =
          TextEditingController(text: authProvider.profile.country ?? "");
      cityController =
          TextEditingController(text: authProvider.profile.city ?? "");
      stateController =
          TextEditingController(text: authProvider.profile.state ?? "");
      addressController =
          TextEditingController(text: authProvider.profile.address ?? "");
      isLoading = false;
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
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CommonTextFieldView(
                            titleText: "Full Name",
                            controller: fullNameController,
                            hintText: "Enter your full name",
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            keyboardType: TextInputType.text,
                          ),
                          CommonTextFieldView(
                            titleText: "Phone Number",
                            controller: phoneController,
                            hintText: "Enter your phone number",
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            keyboardType: TextInputType.phone,
                            onChanged: (value) =>
                                authProvider.validatePhone(value),
                            errorText: authProvider.errorPhone,
                          ),
                          CommonTextFieldView(
                            titleText: "Gender",
                            controller: genderController,
                            hintText: "Enter your gender",
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            keyboardType: TextInputType.text,
                            // onChanged: (value) => authProvider.gender = value,
                            errorText: authProvider.errorGender,
                          ),
                          CommonTextFieldView(
                            titleText: "Country",
                            controller: countryController,
                            hintText: "Enter your country",
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            keyboardType: TextInputType.text,
                          ),
                          CommonTextFieldView(
                            titleText: "City",
                            controller: cityController,
                            hintText: "Enter your city",
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            keyboardType: TextInputType.text,
                          ),
                          CommonTextFieldView(
                            titleText: "State",
                            controller: stateController,
                            hintText: "Enter your state",
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            keyboardType: TextInputType.text,
                          ),
                          CommonTextFieldView(
                            titleText: "Address",
                            controller: addressController,
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
                                            fullNameController.text.trim(),
                                            phoneController.text.trim(),
                                            genderController.text.trim(),
                                            countryController.text.trim(),
                                            cityController.text.trim(),
                                            stateController.text.trim(),
                                            addressController.text.trim(),
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
