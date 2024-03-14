import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:story_teller_admin/model/category_model.dart';
import 'package:story_teller_admin/model/category_model_list.dart';
import 'package:story_teller_admin/screen/category/category_popups.dart';
import 'package:story_teller_admin/util/colors.dart';
import 'package:story_teller_admin/util/timestamp_formatter.dart';
import 'package:story_teller_admin/widget/input_field_round.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../service/api_provider.dart';
import '../../util/theme.dart';
import '../../widget/gaps.dart';
import '../../widget/header.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key, required this.navigateMenu});
  final Function(int index) navigateMenu;
  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final TextEditingController search = TextEditingController();
  late ApiProvider _api;
  CategoryModelList? categoryModelList;
  final int COL_1_FLEX = 1;
  final int COL_2_FLEX = 2;
  final int COL_3_FLEX = 4;

  final int COL_5_FLEX = 2;
  final int COL_6_FLEX = 2;
  final int COL_7_FLEX = 3;

  @override
  void initState() {
    super.initState();
    search.addListener(() {
      String searchText = search.text;
      if (searchText.isEmpty) {
        reloadScreen();
      } else {
        fetchCategoryByName(searchText);
      }
    });
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => reloadScreen(),
    );
  }

  fetchCategoryByName(String name) {
    _api.getCategoryByName(name).then((value) {
      setState(() {
        categoryModelList = value;
      });
    });
  }

  reloadScreen() {
    _api.getAllCategory().then((value) {
      setState(() {
        categoryModelList = value;
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
          const Header(title: 'Category'),
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(
                'All categories',
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
                  CategoryPopup.showCreatePopup(context, reloadScreen);
                },
                child: const Text('Create New'),
              ),
            ],
          ),
          verticalGap(defaultPadding),
          Expanded(
            child: Card(
              color: Colors.white,
              elevation: 5,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  createTableHeader(context),
                  const Divider(
                    color: hintColor,
                  ),
                  categoryModelList?.data?.isEmpty ?? true
                      ? Expanded(child: Container())
                      : Expanded(
                          child: ListView.builder(
                            itemCount: categoryModelList?.data?.length ?? 0,
                            itemBuilder: (context, index) {
                              CategoryModel? category =
                                  categoryModelList?.data?.elementAt(index);
                              return createRowForTable(context, category);
                            },
                          ),
                        ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Row createTableHeader(BuildContext context) {
    return Row(
      children: [
        Flexible(
          flex: COL_1_FLEX,
          child: Container(
            padding: const EdgeInsets.all(defaultPadding / 2),
            alignment: Alignment.centerLeft,
            child: Text(
              'ID',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: secondaryColor,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
        ),
        Flexible(
          flex: COL_2_FLEX,
          child: Container(
            padding: const EdgeInsets.all(defaultPadding / 2),
            alignment: Alignment.centerLeft,
            child: Text(
              'NAME',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: secondaryColor,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
        ),
        Flexible(
          flex: COL_3_FLEX,
          child: Container(
            padding: const EdgeInsets.all(defaultPadding / 2),
            alignment: Alignment.centerLeft,
            child: Text(
              'DESCRIPTION',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: secondaryColor,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
        ),
        Flexible(
          flex: COL_5_FLEX,
          child: Container(
            padding: const EdgeInsets.all(defaultPadding / 2),
            alignment: Alignment.centerLeft,
            child: Text(
              'CREATED AT',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: secondaryColor,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
        ),
        Flexible(
          flex: COL_6_FLEX,
          child: Container(
            padding: const EdgeInsets.all(defaultPadding / 2),
            alignment: Alignment.centerLeft,
            child: Text(
              'UPDATED AT',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: secondaryColor,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
        ),
        Flexible(
          flex: COL_7_FLEX,
          child: Container(
            padding: const EdgeInsets.all(defaultPadding / 2),
            alignment: Alignment.center,
            child: Text(
              'ACTION',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: secondaryColor,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
        ),
      ],
    );
  }

  Widget createRowForTable(BuildContext context, CategoryModel? category) {
    return Row(
      children: [
        Flexible(
          flex: COL_1_FLEX,
          child: Container(
            padding: const EdgeInsets.all(defaultPadding / 2),
            alignment: Alignment.centerLeft,
            child: Text(
              '${category?.id}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(),
            ),
          ),
        ),
        Flexible(
          flex: COL_2_FLEX,
          child: Container(
            padding: const EdgeInsets.all(defaultPadding / 2),
            alignment: Alignment.centerLeft,
            child: Text(
              '${category?.name}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(),
            ),
          ),
        ),
        Flexible(
          flex: COL_3_FLEX,
          child: Container(
            padding: const EdgeInsets.all(defaultPadding / 2),
            alignment: Alignment.centerLeft,
            child: Text(
              '${category?.description}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(),
            ),
          ),
        ),
        Flexible(
          flex: COL_5_FLEX,
          child: Container(
            padding: const EdgeInsets.all(defaultPadding / 2),
            alignment: Alignment.centerLeft,
            child: Tooltip(
              message:
                  TimestampFormatter.dateWithTime('${category?.createdOn}'),
              child: Text(
                TimestampFormatter.timesAgo('${category?.createdOn}'),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(),
              ),
            ),
          ),
        ),
        Flexible(
          flex: COL_6_FLEX,
          child: Container(
            padding: const EdgeInsets.all(defaultPadding / 2),
            alignment: Alignment.centerLeft,
            child: Tooltip(
              message:
                  TimestampFormatter.dateWithTime('${category?.updatedOn}'),
              child: Text(
                TimestampFormatter.timesAgo('${category?.updatedOn}'),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(),
              ),
            ),
          ),
        ),
        Flexible(
          flex: COL_7_FLEX,
          child: Container(
              padding: const EdgeInsets.all(defaultPadding / 2),
              alignment: Alignment.centerLeft,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: () {
                      CategoryPopup.showDetailPopup(
                          context, category, reloadScreen);
                    },
                    child: const Icon(
                      LineAwesomeIcons.eye,
                      color: Colors.amber,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      CategoryPopup.showEditPopup(
                          context, category, reloadScreen);
                    },
                    child: const Icon(
                      LineAwesomeIcons.edit,
                      color: Colors.blue,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      _api
                          .deleteCategory(category?.id ?? -1)
                          .then((value) => reloadScreen());
                    },
                    child: const Icon(
                      LineAwesomeIcons.trash,
                      color: Colors.red,
                    ),
                  ),
                ],
              )),
        ),
      ],
    );
  }
}
