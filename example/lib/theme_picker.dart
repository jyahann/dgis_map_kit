import 'package:dgis_map_kit/dgis_map_kit.dart';
import 'package:flutter/material.dart';

class ThemePicker extends StatefulWidget {
  final void Function(MapTheme theme) onThemeChange;

  const ThemePicker({super.key, required this.onThemeChange});

  @override
  State<ThemePicker> createState() => _ThemePickerState();
}

class _ThemePickerState extends State<ThemePicker> {
  bool inDarkMode = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 15.0,
        right: 15.0,
        bottom: 15.0,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15.0),
        child: Material(
          color: Colors.black.withOpacity(0.5), // Button color
          child: InkWell(
            onTap: () => onTap(),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 4.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Flexible(
                    child: Text(
                      "Dark theme",
                      style: TextStyle(
                        fontSize: 22.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  buildSwitch(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildSwitch() {
    return Switch(
      value: inDarkMode,
      onChanged: (_) => onTap(),
    );
  }

  onTap() {
    widget.onThemeChange(!inDarkMode ? MapTheme.dark : MapTheme.light);
    setState(() {
      inDarkMode = !inDarkMode;
    });
  }
}
