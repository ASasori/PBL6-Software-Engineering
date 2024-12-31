// import 'package:flutter/material.dart';
// import '../../../language/appLocalizations.dart';
// import '../../../routes/route_names.dart';
// import '../../../utils/text_styles.dart';
// import '../../../utils/themes.dart';
//
//
// class FilterBarUI extends StatelessWidget {
//   final int totalHotel;
//   FilterBarUI ({super.key, required this.totalHotel});
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: AppTheme.scaffoldBackgroundColor,
//       child: Stack(
//         children: <Widget>[
//           Padding(
//             padding:
//             const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 4),
//             child: Row(
//               children: <Widget>[
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Text(
//                     "$totalHotel",
//                     style: TextStyles(context).getRegularStyle(),
//                   ),
//                 ),
//                 Expanded(
//                   child: Padding(
//                     padding: const EdgeInsets.only(left: 0.0),
//                     child: Text(
//                       AppLocalizations(context).of("hotel_found"),
//                       style: TextStyles(context).getRegularStyle(),
//                     ),
//                   ),
//                 ),
//                 Material(
//                     color: Colors.transparent,
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.end,
//                       children: [
//                         InkWell(
//                           borderRadius: const BorderRadius.all(
//                             Radius.circular(4.0),
//                           ),
//                           onTap: () {
//                             NavigationServices(context).gotoFiltersScreen();
//                           },
//                           child: Padding(
//                             padding: const EdgeInsets.only(left: 8),
//                             child: Row(
//                               children: <Widget>[
//                                 Text(
//                                   AppLocalizations(context).of("sort"),
//                                   style: TextStyles(context).getRegularStyle(),
//                                 ),
//                                 Padding(
//                                   padding: const EdgeInsets.all(8.0),
//                                   child: Icon(Icons.swap_vert_sharp,
//                                       color: Theme
//                                           .of(context)
//                                           .primaryColor),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                         InkWell(
//                           borderRadius: const BorderRadius.all(
//                             Radius.circular(4.0),
//                           ),
//                           onTap: () {
//                             NavigationServices(context).gotoFiltersScreen();
//                           },
//                           child: Padding(
//                             padding: const EdgeInsets.only(left: 8),
//                             child: Row(
//                               children: <Widget>[
//                                 Text(
//                                   AppLocalizations(context).of("filtter"),
//                                   style: TextStyles(context).getRegularStyle(),
//                                 ),
//                                 Padding(
//                                   padding: const EdgeInsets.all(8.0),
//                                   child: Icon(Icons.filter_alt_outlined,
//                                       color: Theme
//                                           .of(context)
//                                           .primaryColor),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ],
//                     )
//                 ),
//               ],
//             ),
//           ),
//           const Positioned(
//             top: 0,
//             left: 0,
//             right: 0,
//             child: Divider(
//               height: 1,
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
//
// // RangeValues _values = const RangeValues(50, 200); // Giá trị khởi tạo
// //
// // Widget priceBarFilter(BuildContext context) {
// //   return Column(
// //     mainAxisSize: MainAxisSize.min,
// //     crossAxisAlignment: CrossAxisAlignment.start,
// //     children: <Widget>[
// //       Padding(
// //         padding: const EdgeInsets.all(16.0),
// //         child: Text(
// //           "Price (for 1 night)", // Thay thế AppLocalizations nếu cần
// //           style: TextStyle(
// //             color: Colors.grey,
// //             fontSize: MediaQuery.of(context).size.width > 360 ? 18 : 16,
// //             fontWeight: FontWeight.normal,
// //           ),
// //         ),
// //       ),
// //       RangeSlider(
// //         values: _values,
// //         min: 0,
// //         max: 500,
// //         divisions: 50,
// //         labels: RangeLabels(
// //           '\$${_values.start.round()}',
// //           '\$${_values.end.round()}',
// //         ),
// //         onChanged: (RangeValues values) {
// //           setState(() {
// //             _values = values;
// //           });
// //         },
// //       ),
// //       const SizedBox(height: 8),
// //       Align(
// //         alignment: Alignment.centerRight,
// //         child: Padding(
// //           padding: const EdgeInsets.only(right: 16.0),
// //           child: ElevatedButton(
// //             onPressed: () {
// //               // Trả về giá trị khi nhấn Apply
// //               Navigator.of(context).pop(_values);
// //             },
// //             child: Text("Apply"),
// //           ),
// //         ),
// //       ),
// //     ],
// //   );
// // }

import 'package:booking_hotel_app/screens/explore_screen/filter_screen/sort_option_view.dart';
import 'package:flutter/material.dart';

import '../../../language/appLocalizations.dart';
import '../../../models/hotel.dart';
import '../../../utils/text_styles.dart';
import '../../../utils/themes.dart';
import '../filter_screen/range_slider_view.dart';

class FilterBarUi extends StatefulWidget {
  final List<Hotel> hotelListData;
  final Function(RangeValues) onFilterChanged;
  final Function(int) onSortChanged;

  const FilterBarUi(
      {super.key,
      required this.hotelListData,
      required this.onFilterChanged,
      required this.onSortChanged});

  @override
  _FilterBarUIState createState() => _FilterBarUIState();
}

class _FilterBarUIState extends State<FilterBarUi> {
  late RangeValues _values = const RangeValues(20, 200);
  int _selectedSortIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.scaffoldBackgroundColor,
      child: Stack(
        children: <Widget>[
          Padding(
            padding:
                const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 4),
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "${widget.hotelListData.length}",
                    style: TextStyles(context).getRegularStyle(),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 0.0),
                    child: Text(
                      AppLocalizations(context).of("hotel_found"),
                      style: TextStyles(context).getRegularStyle(),
                    ),
                  ),
                ),
                Material(
                  color: Colors.transparent,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(4.0),
                        ),
                        onTap: () {
                          _showSortDialog();
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Row(
                            children: <Widget>[
                              Text(
                                AppLocalizations(context).of("sort"),
                                style: TextStyles(context).getRegularStyle(),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(Icons.swap_vert_sharp,
                                    color: Theme.of(context).primaryColor),
                              ),
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(4.0),
                        ),
                        onTap: () {
                          _showFilterDialog();
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Row(
                            children: <Widget>[
                              Text(
                                AppLocalizations(context).of("filtter"),
                                style: TextStyles(context).getRegularStyle(),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(Icons.filter_alt_outlined,
                                    color: Theme.of(context).primaryColor),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Divider(
              height: 1,
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Filter",
                  style: TextStyles(context).getTitleStyle(),
                ),
                const SizedBox(height: 16),
                priceBarFilter(),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: AppTheme.whiteColor,
                    ),
                    onPressed: () {
                      Navigator.pop(context, _values);
                    },
                    child: const Text("Apply"),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ).then((result) {
      if (result != null) {
        setState(() {
          _values = result;
          widget.onFilterChanged(_values);
        });
      }
    });
  }

  void _showSortDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Sort by",
                  style: TextStyles(context).getTitleStyle(),
                ),
                const SizedBox(height: 16),
                SortOptionView(
                    selectedSortIndex: _selectedSortIndex,
                    onChangeSortOption: (int value) {
                      setState(() {
                        _selectedSortIndex = value;
                      });
                    }),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: AppTheme.whiteColor,
                    ),
                    onPressed: () {
                      Navigator.pop(context, _selectedSortIndex);
                    },
                    child: const Text("Apply"),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ).then((result) {
      if (result != null) {
        setState(() {
          _selectedSortIndex = result;
          widget.onSortChanged(_selectedSortIndex);  // Trả về selected index
        });
      }
    });
  }

  Widget priceBarFilter() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            AppLocalizations(context).of("price_text"),
            textAlign: TextAlign.left,
            style: TextStyle(
              color: Colors.grey,
              fontSize: MediaQuery.of(context).size.width > 360 ? 18 : 16,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
        RangeSliderView(
          values: _values,
          onChnageRangeValues: (values) {
            setState(() {
              _values = values;
            });
          },
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
