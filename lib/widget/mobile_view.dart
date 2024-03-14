import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:story_teller_admin/util/colors.dart';
import 'package:story_teller_admin/util/theme.dart';
import 'package:story_teller_admin/widget/gaps.dart';

class MobileView extends StatelessWidget {
  const MobileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Align(
          alignment: Alignment.center,
          child: SvgPicture.asset(
            'assets/svg/view_in_desktop.svg',
            width: 300,
          ),
        ),
        verticalGap(defaultPadding),
        Align(
          alignment: Alignment.center,
          child: Flexible(
            child: Text(
              'Please use desktop or table to you the application',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: primaryColor.withOpacity(0.5),
                  ),
            ),
          ),
        ),
      ],
    );
  }
}
