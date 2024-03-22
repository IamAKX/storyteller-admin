import 'package:flutter/material.dart';
import 'package:story_teller_admin/screen/author/author_screen.dart';
import 'package:story_teller_admin/screen/category/category_screen.dart';
import 'package:story_teller_admin/screen/story/story_screen.dart';
import 'package:story_teller_admin/screen/subscription/subscription_screen.dart';
import 'package:story_teller_admin/widget/mobile_view.dart';

import '../../widget/responsive.dart';
import 'side_menu.dart';

class HomeContainer extends StatefulWidget {
  const HomeContainer({super.key});
  static const String routePath = '/homeContainer';
  static dynamic args;
  static int selectedIndex = 5;
  static GlobalKey<ScaffoldState> scafoldKey = GlobalKey<ScaffoldState>();

  @override
  State<HomeContainer> createState() => _HomeContainerState();
}

class _HomeContainerState extends State<HomeContainer> {
  navigateMenu(int index) {
    setState(() {
      HomeContainer.selectedIndex = index;
    });
  }

  Widget getMenuFromIndex() {
    switch (HomeContainer.selectedIndex) {
      case 1:
        return CategoryScreen(navigateMenu: navigateMenu);
      case 2:
        return AuthorScreen(navigateMenu: navigateMenu);
      case 4:
        return SubscriptionScreen(navigateMenu: navigateMenu);
      case 5:
        return StoryScreen(navigateMenu: navigateMenu);
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: HomeContainer.scafoldKey,
      drawer: SideMenu(
        navigateMenu: (int index) {
          navigateMenu(index);
        },
      ),
      body: SafeArea(
        child: Responsive(
          mobile: const MobileView(),
          tablet: getBody(context),
          desktop: getBody(context),
        ),
      ),
    );
  }

  Row getBody(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (Responsive.isDesktop(context))
          Expanded(
            child: SideMenu(
              navigateMenu: (int index) {
                navigateMenu(index);
              },
            ),
          ),
        Expanded(
          flex: 5,
          child: getMenuFromIndex(),
        ),
      ],
    );
  }
}
