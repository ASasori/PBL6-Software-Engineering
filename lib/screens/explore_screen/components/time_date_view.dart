import 'package:booking_hotel_app/motel_app.dart';
import 'package:booking_hotel_app/providers/theme_provider.dart';
import 'package:booking_hotel_app/utils/enum.dart';
import 'package:booking_hotel_app/widgets/common_button.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../../language/appLocalizations.dart';
import '../../../utils/text_styles.dart';
import '../../../widgets/common_snack_bar.dart';

class TimeDateView extends StatefulWidget {
  final Function(DateTime startDate, DateTime endDate)? onDateChanged;
  const TimeDateView({super.key, this.onDateChanged});

  @override
  State<TimeDateView> createState() => _TimeDateViewState();
}

class _TimeDateViewState extends State<TimeDateView> {
  late DateTime startDate ;
  late DateTime endDate ;
  LanguageType _languageType = applicationcontext == null ? LanguageType.en : applicationcontext!.read<ThemeProvider>().languageType;

  final DateRangePickerController _controller = DateRangePickerController();
  @override
  void initState() {
    startDate = DateTime.now();
    endDate = DateTime.now().add(const Duration(days: 5));
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, bottom: 22),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          _getDateRoomUi(AppLocalizations(context).of("choose_date"),
              "${DateFormat("dd, MMM", _languageType.toString().split(".")[1]).format(startDate)} - ${DateFormat("dd, MMM", _languageType.toString().split(".")[1]).format(endDate)}",
                  () {
                _showDemoDialog(context);
              }),
          const SizedBox(width: 10),
          Container(
            width: 1,
            height: 100,
            color: Colors.grey.withOpacity(0.8),
          ),
        ],
      ),
    );
  }

  Widget _getDateRoomUi(String title, String subtitle, VoidCallback onTap) {
    return Expanded(
      child: Row(
        children: <Widget>[
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: const BorderRadius.all(
                Radius.circular(4.0),
              ),
              onTap: onTap,
              child: Padding(
                padding:
                const EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      title,
                      style: TextStyles(context)
                          .getDescriptionStyle()
                          .copyWith(fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      subtitle,
                      // "${DateFormat("dd, MMM").format(startDate)} - ${DateFormat("dd, MMM").format(endDate)}",
                      style: TextStyles(context).getRegularStyle(),
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

  void _showDemoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: StatefulBuilder(
          builder: (BuildContext context, StateSetter setStateInDialog) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Card(
                  margin: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                  child: SfDateRangePicker(
                    controller: _controller,
                    selectionMode: DateRangePickerSelectionMode.range,
                    onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
                      setStateInDialog(() {
                        if (args.value is PickerDateRange) {
                          startDate = args.value.startDate ?? DateTime.now(); // Gán giá trị mặc định nếu null
                          endDate = args.value.endDate ?? args.value.startDate ?? DateTime.now();
                        }
                      });
                    },
                    allowViewNavigation: false,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 8),
                  child: CommonButton(
                    buttonText: AppLocalizations(context).of("Apply_date"),
                    onTap: () {
                      Navigator.pop(context);
                      if (widget.onDateChanged != null ) {
                        if (startDate.compareTo(endDate) != 0)
                          {
                            widget.onDateChanged!(startDate, endDate);
                          }
                        else if (startDate.compareTo(endDate) == 0) {
                          CommonSnackBar.show(
                              context: context,
                              iconData: Icons.error_outline,
                              iconColor: Colors.red,
                              message:
                                "Start date cannot coincide with end date",
                              backgroundColor: Colors.black87);
                          endDate = startDate.add(const Duration(days: 1));
                          widget.onDateChanged!(startDate, endDate);
                        }
                      }
                      setState(() {
                      });
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
