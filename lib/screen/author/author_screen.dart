import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:story_teller_admin/model/author_model.dart';
import 'package:story_teller_admin/model/author_model_list.dart';
import 'package:story_teller_admin/screen/author/author_popup.dart';
import 'package:story_teller_admin/util/timestamp_formatter.dart';
import 'package:story_teller_admin/widget/responsive.dart';

import '../../service/api_provider.dart';
import '../../util/theme.dart';
import '../../widget/gaps.dart';
import '../../widget/header.dart';
import '../../widget/input_field_round.dart';

class AuthorScreen extends StatefulWidget {
  const AuthorScreen({super.key, required this.navigateMenu});
  final Function(int index) navigateMenu;

  @override
  State<AuthorScreen> createState() => _AuthorScreenState();
}

class _AuthorScreenState extends State<AuthorScreen> {
  final TextEditingController search = TextEditingController();
  late ApiProvider _api;
  AuthorModelList? authorModelList;

  @override
  void initState() {
    super.initState();
    search.addListener(() {
      String searchText = search.text;
      if (searchText.isEmpty) {
        reloadScreen();
      } else {
        fetchAuthorByName(searchText);
      }
    });
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => reloadScreen(),
    );
  }

  fetchAuthorByName(String name) {
    _api.getAuthorByName(name).then((value) {
      setState(() {
        authorModelList = value;
      });
    });
  }

  reloadScreen() {
    _api.getAllAuthor().then((value) {
      setState(() {
        authorModelList = value;
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
          const Header(title: 'Author'),
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(
                'All authors',
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
                  AuthorPopup.showCreatePopup(context, reloadScreen);
                },
                child: const Text('Create New'),
              ),
            ],
          ),
          verticalGap(defaultPadding),
          Expanded(
            child: GridView.builder(
              itemCount: authorModelList?.data?.length ?? 0,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: Responsive.isDesktop(context) ? 5 : 3,
                childAspectRatio: 0.6,
                mainAxisSpacing: defaultPadding,
                crossAxisSpacing: defaultPadding,
              ),
              itemBuilder: (context, index) {
                AuthorModel? authorModel =
                    authorModelList?.data?.elementAt(index);
                return buildAuthorCard(authorModel, context);
              },
            ),
          )
        ],
      ),
    );
  }

  Card buildAuthorCard(AuthorModel? authorModel, BuildContext context) {
    return Card(
      elevation: 5,
      color: Colors.white,
      child: Container(
        child: Column(
          children: [
            Expanded(
              flex: 7,
              child: Stack(
                children: [
                  Container(
                    child: CachedNetworkImage(
                      imageUrl: '${authorModel?.image}',
                      fit: BoxFit.cover,
                      height: double.infinity,
                      placeholder: (context, url) =>
                          const Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) => const Center(
                        child: Text('Image not loaded'),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: Column(
                      children: [
                        IconButton(
                          onPressed: () {
                            AuthorPopup.showEditPopup(
                                context, authorModel, reloadScreen);
                          },
                          icon: const Icon(
                            LineAwesomeIcons.edit,
                            color: Colors.blue,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            _api
                                .deleteAuthor(authorModel?.id ?? -1)
                                .then((value) => reloadScreen());
                          },
                          icon: const Icon(
                            LineAwesomeIcons.trash,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.all(defaultPadding / 2),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        authorModel?.name ?? '-',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                    ),
                    verticalGap(defaultPadding / 4),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Tooltip(
                        message: TimestampFormatter.dateWithTime(
                            authorModel?.createdOn ?? ''),
                        child: Text(
                          'Created ${TimestampFormatter.timesAgo(authorModel?.createdOn ?? '')}',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(),
                        ),
                      ),
                    ),
                    verticalGap(defaultPadding / 4),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Tooltip(
                        message: TimestampFormatter.dateWithTime(
                            authorModel?.updatedOn ?? ''),
                        child: Text(
                          'Updated ${TimestampFormatter.timesAgo(authorModel?.updatedOn ?? '')}',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
