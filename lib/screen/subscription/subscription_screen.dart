import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:story_teller_admin/model/subscription_model.dart';
import 'package:story_teller_admin/model/subscription_model_list.dart';
import 'package:story_teller_admin/screen/subscription/subscription_popup.dart';
import 'package:story_teller_admin/util/colors.dart';

import '../../service/api_provider.dart';
import '../../util/theme.dart';
import '../../widget/gaps.dart';
import '../../widget/header.dart';
import '../../widget/input_field_round.dart';
import '../../widget/responsive.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key, required this.navigateMenu});
  final Function(int index) navigateMenu;
  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  final TextEditingController search = TextEditingController();
  late ApiProvider _api;
  SubscriptionModelList? subscriptionModelList;

  @override
  void initState() {
    super.initState();
    search.addListener(() {
      String searchText = search.text;
      if (searchText.isEmpty) {
        reloadScreen();
      } else {
        fetchSubscriptionByName(searchText);
      }
    });
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => reloadScreen(),
    );
  }

  fetchSubscriptionByName(String name) {
    _api.getSubscriptionByName(name).then((value) {
      setState(() {
        subscriptionModelList = value;
      });
    });
  }

  reloadScreen() {
    _api.getAllSubscription().then((value) {
      setState(() {
        subscriptionModelList = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    _api = Provider.of<ApiProvider>(context);
    return getBody(context);
  }

  Widget getBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Header(title: 'Package'),
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(
                'All packages',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const Spacer(),
              SizedBox(
                width: 300,
                child: InputFieldRound(
                    hint: 'Search by name',
                    controller: search,
                    keyboardType: TextInputType.text,
                    obscure: false,
                    icon: LineAwesomeIcons.search),
              ),
              horizontalGap(defaultPadding),
              ElevatedButton(
                onPressed: () {
                  SubscriptionPopup.showCreatePopup(context, reloadScreen);
                },
                child: const Text('Create New'),
              ),
            ],
          ),
          verticalGap(defaultPadding),
          Expanded(
            child: GridView.builder(
              itemCount: subscriptionModelList?.data?.length ?? 0,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: Responsive.isDesktop(context) ? 5 : 3,
                childAspectRatio: 0.6,
                mainAxisSpacing: defaultPadding,
                crossAxisSpacing: defaultPadding,
              ),
              itemBuilder: (context, index) {
                SubscriptionModel? subscriptionModel =
                    subscriptionModelList?.data?.elementAt(index);
                return buildSubscriptionCard(subscriptionModel, context);
              },
            ),
          )
        ],
      ),
    );
  }

  Widget buildSubscriptionCard(
      SubscriptionModel? subscriptionModel, BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Card(
            elevation: 5,
            child: Stack(
              children: [
                Column(
                  children: [
                    verticalGap(75),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        subscriptionModel?.title ?? '',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: primaryColor.shade300,
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                            ),
                      ),
                    ),
                    verticalGap(defaultPadding),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        '₹ ${subscriptionModel?.amount}',
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  color: textColorDark,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 35,
                                ),
                      ),
                    ),
                    verticalGap(defaultPadding),
                    Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: defaultPadding),
                        child: Text(
                          '${subscriptionModel?.description}',
                          textAlign: TextAlign.center,
                          maxLines: 3,
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: textColorDark,
                                  ),
                        ),
                      ),
                    ),
                    const Spacer(),
                    InkWell(
                      onTap: () {},
                      child: Container(
                        margin: const EdgeInsets.all(defaultPadding),
                        width: double.infinity,
                        height: 50,
                        color: primaryColor,
                        alignment: Alignment.center,
                        child: Text(
                          'BUY',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                        ),
                      ),
                    )
                  ],
                ),
                Visibility(
                  visible: subscriptionModel?.otherInfo?.isNotEmpty ?? false,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(4),
                    height: 30,
                    color: primaryColor.shade700,
                    alignment: Alignment.center,
                    child: Text(
                      subscriptionModel?.otherInfo ?? '',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton(
              onPressed: () {
                SubscriptionPopup.showEditPopup(
                    context, subscriptionModel, reloadScreen);
              },
              child: Text(
                'Edit',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            TextButton(
              onPressed: () {
                _api
                    .deleteSubscription(subscriptionModel?.id ?? -1)
                    .then((value) => reloadScreen());
              },
              child: Text(
                'Delete',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
          ],
        )
      ],
    );
  }
}
