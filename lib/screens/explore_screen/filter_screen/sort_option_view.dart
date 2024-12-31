import 'package:flutter/material.dart';

class SortOptionView extends StatefulWidget {
  final int selectedSortIndex;
  final Function(int) onChangeSortOption;
  const SortOptionView({super.key, required this.selectedSortIndex, required this.onChangeSortOption});

  @override
  State<SortOptionView> createState() => _SortOptionViewState();
}

class _SortOptionViewState extends State<SortOptionView> {
  late int _selectedSortIndex;

  @override
  void initState() {
    _selectedSortIndex = widget.selectedSortIndex;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<String> options = [
      "Price Low",
      "Price High",
      "Rating Low",
      "Rating High"
    ];

    return Column(
      children: List.generate(4, (index) {
        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedSortIndex = index;
              widget.onChangeSortOption(_selectedSortIndex);
            });
          },
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
            decoration: BoxDecoration(
              color: _selectedSortIndex == index
                  ? Theme.of(context).primaryColor.withOpacity(0.1)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: _selectedSortIndex == index
                    ? Theme.of(context).primaryColor
                    : Colors.grey,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  _selectedSortIndex == index
                      ? Icons.check_circle
                      : Icons.circle_outlined,
                  color: _selectedSortIndex == index
                      ? Theme.of(context).primaryColor
                      : Colors.grey,
                ),
                const SizedBox(width: 10),
                Text(
                  options[index],
                  style: TextStyle(
                    color: _selectedSortIndex == index
                        ? Theme.of(context).primaryColor
                        : Colors.black,
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
