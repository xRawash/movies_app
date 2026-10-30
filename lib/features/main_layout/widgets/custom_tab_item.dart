import 'package:flutter/material.dart';

class CustomTabItem extends StatelessWidget {
  const CustomTabItem({
    super.key,
    required this.genre,
    required this.isSelected,
    required this.selectedBgColor,
    required this.unselectedBgColor,
    required this.selectedFgColor,
    required this.unSelectedFgColor,
  });

  final String genre;
  final bool isSelected;
  final Color selectedBgColor;
  final Color unselectedBgColor;
  final Color selectedFgColor;
  final Color unSelectedFgColor;

  @override
  Widget build(BuildContext context) {
    String title = genre[0].toUpperCase() + genre.substring(1);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? selectedBgColor : unselectedBgColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: selectedBgColor, width: 1.5),
      ),
      alignment: Alignment.center,
      child: Text(
        title,
        style: TextStyle(
          color: isSelected ? selectedFgColor : unSelectedFgColor,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }
}
