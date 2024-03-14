import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import '../../util/colors.dart';
import '../../util/theme.dart';
import '../login/login_screen.dart';
import 'side_menu_item.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({super.key, required this.navigateMenu});

  final Function(int index) navigateMenu;

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  int selectedIndex = 1;

  updateSelectedIndex(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      // backgroundColor: sidebar,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ListView(
              children: [
                DrawerHeader(
                  decoration: const BoxDecoration(color: primaryColor),
                  child: SizedBox(
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // const Icon(
                        //   LineAwesomeIcons.user_shield,
                        //   color: background,
                        //   size: 50,
                        // ),
                        // const SizedBox(
                        //   height: defaultPadding / 2,
                        // ),
                        Image.asset(
                          'assets/logo/logo.png',
                          width: 60,
                        ),
                        const SizedBox(
                          height: defaultPadding / 2,
                        ),
                        Text(
                          'Admin Panel',
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(color: background),
                        ),
                      ],
                    ),
                  ),
                ),
                SideMenuItem(
                  title: 'Category',
                  iconData: LineAwesomeIcons.bar_chart_1,
                  press: () {
                    widget.navigateMenu(1);
                    updateSelectedIndex(1);
                    if (Scaffold.of(context).isDrawerOpen) {
                      Navigator.of(context).pop();
                    }
                  },
                  isHighlighted: selectedIndex == 1,
                ),
                SideMenuItem(
                  title: 'Author',
                  iconData: LineAwesomeIcons.user_1,
                  press: () {
                    widget.navigateMenu(2);
                    updateSelectedIndex(2);
                    if (Scaffold.of(context).isDrawerOpen) {
                      Navigator.of(context).pop();
                    }
                  },
                  isHighlighted: selectedIndex == 2,
                ),
                SideMenuItem(
                  title: 'Dealer',
                  iconData: LineAwesomeIcons.user_tie,
                  press: () {
                    widget.navigateMenu(3);
                    updateSelectedIndex(3);
                    if (Scaffold.of(context).isDrawerOpen) {
                      Navigator.of(context).pop();
                    }
                  },
                  isHighlighted: selectedIndex == 3,
                ),
                SideMenuItem(
                  title: 'Subscription',
                  iconData: LineAwesomeIcons.users_cog,
                  press: () {
                    widget.navigateMenu(4);
                    updateSelectedIndex(4);
                    if (Scaffold.of(context).isDrawerOpen) {
                      Navigator.of(context).pop();
                    }
                  },
                  isHighlighted: selectedIndex == 4,
                ),
                SideMenuItem(
                  title: 'Story',
                  iconData: LineAwesomeIcons.poll_h,
                  press: () {
                    widget.navigateMenu(5);
                    updateSelectedIndex(5);
                    if (Scaffold.of(context).isDrawerOpen) {
                      Navigator.of(context).pop();
                    }
                  },
                  isHighlighted: selectedIndex == 5,
                ),
                SideMenuItem(
                  title: 'User Base',
                  iconData: LineAwesomeIcons.file_invoice,
                  press: () {
                    widget.navigateMenu(6);
                    updateSelectedIndex(6);
                    if (Scaffold.of(context).isDrawerOpen) {
                      Navigator.of(context).pop();
                    }
                  },
                  isHighlighted: selectedIndex == 6,
                )
              ],
            ),
          ),
          ListTile(
            horizontalTitleGap: 0,
            leading: const Icon(
              LineAwesomeIcons.alternate_sign_out,
              color: Colors.red,
              size: 20,
            ),
            title: Text(
              'Log out',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: Colors.red,
                  ),
            ),
            onTap: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                  LoginScreen.routePath, (route) => false);
            },
          ),
        ],
      ),
    );
  }
}
