import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:movies_app/core/sources/assets_manager.dart';
import 'package:movies_app/core/sources/colors_manager.dart';

class LangSwitch extends StatefulWidget {
  const LangSwitch({super.key});

  @override
  State<LangSwitch> createState() => _LangSwitchState();
}

class _LangSwitchState extends State<LangSwitch> {
  bool isArabic = false;
  @override
  Widget build(BuildContext context) {
    return AnimatedToggleSwitch<bool>.size(
      current: isArabic,
      values: const [false, true],
      iconOpacity: 1.0,
      selectedIconScale: 1.0,
      spacing: 20.0,
      height: 48.0,
      style: ToggleStyle(
        backgroundColor: ColorsManager.black,
        borderColor: ColorsManager.yellow,
        borderRadius: BorderRadius.circular(30),
        indicatorColor: Colors.transparent,
      ),
      foregroundIndicatorIconBuilder: (context, global) {
        return SizedBox.fromSize(
          size: global.indicatorSize,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.transparent,
              shape: BoxShape.circle,
              border: Border.all(
                color: ColorsManager.yellow,
                width: 8.0,
              ),
            ),
          ),
        );
      },
      customIconBuilder: (context, local, global) {
        return ClipOval(
          child: Image.asset(
            local.value ? ImageAssets.arFlag : ImageAssets.enFlag,
            fit: BoxFit.cover,
          ),
        );
      },
      onChanged: (value) {
        setState(() {
          isArabic = value;
        });
      },
    );
  }
}
