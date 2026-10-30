import 'package:flutter/material.dart';
import 'package:movies_app/features/main_layout/widgets/custom_tab_item.dart';

class CustomTabBar extends StatefulWidget {
  const CustomTabBar({
    super.key,
    required this.genres,
    required this.selectedBgColor,
    required this.unselectedBgColor,
    required this.selectedFgColor,
    required this.unSelectedFgColor,
    this.initialGenre,
    this.onSelectedGenreChanged,
  });

  final List<String> genres;
  final Color selectedBgColor;
  final Color unselectedBgColor;
  final Color selectedFgColor;
  final Color unSelectedFgColor;
  final String? initialGenre;
  final void Function(String genre)? onSelectedGenreChanged;

  @override
  State<CustomTabBar> createState() => _CustomTabBarState();
}

class _CustomTabBarState extends State<CustomTabBar> {
  int selectedGenreIndex = 0;

  @override
  void initState() {
    super.initState();
    if (widget.initialGenre != null) {
      int index = widget.genres.indexOf(widget.initialGenre!);
      if (index != -1) selectedGenreIndex = index;
    }
  }

  void _onGenreSelected(int index) {
    setState(() {
      selectedGenreIndex = index;
    });
    if (widget.onSelectedGenreChanged != null) {
      widget.onSelectedGenreChanged!(widget.genres[index]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 45,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.genres.length,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemBuilder: (context, index) {
          final isSelected = selectedGenreIndex == index;
          return GestureDetector(
            onTap: () => _onGenreSelected(index),
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              child: CustomTabItem(
                genre: widget.genres[index],
                isSelected: isSelected,
                selectedBgColor: widget.selectedBgColor,
                unselectedBgColor: widget.unselectedBgColor,
                selectedFgColor: widget.selectedFgColor,
                unSelectedFgColor: widget.unSelectedFgColor,
              ),
            ),
          );
        },
      ),
    );
  }
}
