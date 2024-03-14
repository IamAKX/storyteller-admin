import 'package:flutter/material.dart';

import '../../util/colors.dart';

class SideMenuItem extends StatelessWidget {
  const SideMenuItem({
    super.key,
    required this.title,
    required this.iconData,
    required this.press,
    required this.isHighlighted,
  });

  final String title;
  final IconData iconData;
  final VoidCallback press;
  final isHighlighted;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      horizontalTitleGap: 0,
      leading: Icon(
        iconData,
        color: primaryColor,
        size: 20,
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.labelLarge,
      ),
      tileColor:
          isHighlighted ? primaryColor.withOpacity(0.1) : Colors.transparent,
      onTap: press,
    );
  }
}
