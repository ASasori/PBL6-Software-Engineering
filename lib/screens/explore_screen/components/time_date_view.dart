import 'package:booking_hotel_app/main.dart';
import 'package:booking_hotel_app/models/room_data.dart';
import 'package:booking_hotel_app/screens/explore_screen/components/room_popup_view.dart';
import 'package:booking_hotel_app/motel_app.dart';
import 'package:booking_hotel_app/providers/theme_provider.dart';
import 'package:booking_hotel_app/utils/enum.dart';
import 'package:booking_hotel_app/widgets/common_button.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../../language/appLocalizations.dart';
import '../../../utils/helper.dart';
import '../../../utils/text_styles.dart';
import 'calendar_popup_view.dart';

class TimeDateView extends StatefulWidget {
  final Function(DateTime startDate, DateTime endDate)? onDateChanged; // Add callback
  const TimeDateView({super.key, this.onDateChanged});

  @override
  State<TimeDateView> createState() => _TimeDateViewState();
}

class _TimeDateViewState extends State<TimeDateView> {
  RoomData _roomData = RoomData(1, 2);

  late DateTime startDate ;
  late DateTime endDate ;
  LanguageType _languageType = applicationcontext == null ? LanguageType.en : applicationcontext!.read<ThemeProvider>().languageType;

  final DateRangePickerController _controller = DateRangePickerController();
  @override
  void initState() {
    startDate = DateTime.now();
    endDate = DateTime.now().add(Duration(days: 5));
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 16, bottom: 16, right: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _getDateRoomUi(AppLocalizations(context).of("choose_date"),
              "${DateFormat("dd, MMM", _languageType.toString().split(".")[1]).format(startDate)} - ${DateFormat("dd, MMM", _languageType.toString().split(".")[1]).format(endDate)}",
                  () {
                _showDemoDialog(context);
              }),
          Container(
            width: 1,
            height: 42,
            color: Colors.grey.withOpacity(0.8),
          ),
          _getDateRoomUi(AppLocalizations(context).of("number_room"),
              Helper.getRoomText(_roomData), () {
                _showPopUp();
              }),
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
              borderRadius: BorderRadius.all(
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
                      // "Choose date",
                      style: TextStyles(context)
                          .getDescriptionStyle()
                          .copyWith(fontSize: 16),
                    ),
                    SizedBox(
                      height: 8,
                    ),
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
                          startDate = args.value.startDate!;
                          endDate = args.value.endDate!;
                        }
                      });
                    },
                    allowViewNavigation: false,
                  ),
                ),
                // Buttons to confirm or cancel the selection
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 8),
                  child: CommonButton(
                    buttonText: AppLocalizations(context).of("Apply_date"),
                    onTap: () {
                      // Close the dialog and update the parent state
                      Navigator.pop(context);
                      if (widget.onDateChanged != null) {
                        widget.onDateChanged!(startDate, endDate); // Notify the parent
                      }
                      // Ensure parent widget updates with the selected dates
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



  void _showPopUp() {
    showDialog(
      context: context,
      builder: (BuildContext context) => RoomPopupView(
        roomData: _roomData,
        barrierDismissible: true,
        onChnage: (data) {
          setState(() {
            _roomData = data;
          });
        },
      ),
    );
  }
}
