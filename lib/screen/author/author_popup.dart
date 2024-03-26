import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:story_teller_admin/model/author_model.dart';
import 'package:story_teller_admin/service/storage_provider.dart';

import '../../service/api_provider.dart';
import '../../service/toast_service.dart';
import '../../util/colors.dart';
import '../../util/theme.dart';
import '../../widget/gaps.dart';
import '../../widget/input_field_round.dart';

class AuthorPopup {
  static showEditPopup(
      BuildContext context, AuthorModel? author, Function() reloadScreen) {
    TextEditingController nameCtrl =
        TextEditingController(text: author?.name ?? '');
    Uint8List? fromPicker;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: Text(
              'Edit Author',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(color: secondaryColor),
            ),
            content: SizedBox(
              width: 300,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CachedNetworkImage(
                        imageUrl: '${author?.image}',
                        fit: BoxFit.cover,
                        width: 80,
                        height: 80,
                        placeholder: (context, url) =>
                            const CircularProgressIndicator(),
                        errorWidget: (context, url, error) => const Center(
                          child: Text('Image not loaded'),
                        ),
                      ),
                      horizontalGap(defaultPadding),
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          border: Border.all(color: hintColor),
                        ),
                        alignment: Alignment.center,
                        child: fromPicker == null
                            ? IconButton(
                                onPressed: () async {
                                  fromPicker =
                                      await ImagePickerWeb.getImageAsBytes();
                                  setState(() {});
                                },
                                icon: const Icon(LineAwesomeIcons.plus))
                            : Image.memory(
                                fromPicker!,
                                width: 80,
                                height: 80,
                              ),
                      ),
                    ],
                  ),
                  verticalGap(defaultPadding),
                  InputFieldRound(
                      hint: 'Name',
                      controller: nameCtrl,
                      keyboardType: TextInputType.name,
                      obscure: false,
                      icon: LineAwesomeIcons.icons),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  if (nameCtrl.text.isEmpty) {
                    ToastService.instance.showError('Name is empty');
                    return;
                  }
                  author?.name = nameCtrl.text;
                  Map<String, dynamic> reqBody = author?.toMap() ?? {};
                  reqBody.remove('id');
                  if (fromPicker != null) {
                    String imageLink = await StorageProvider.instance
                        .uploadFile('author', DateTime.now().toIso8601String(),
                            fromPicker!);
                    reqBody['image'] = imageLink;
                  }
                  ApiProvider.instance
                      .updateAuthor(author?.id ?? -1, reqBody)
                      .then((value) {
                    reloadScreen();
                  });
                  Navigator.pop(context);
                },
                child: Text(
                  'Update',
                  style: Theme.of(context)
                      .textTheme
                      .labelLarge
                      ?.copyWith(color: Colors.blue),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Cancel',
                  style: Theme.of(context)
                      .textTheme
                      .labelLarge
                      ?.copyWith(color: Colors.red),
                ),
              ),
            ],
          );
        });
      },
    );
  }

  static showCreatePopup(BuildContext context, Function() reloadScreen) {
    Uint8List? fromPicker;
    TextEditingController nameCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: Text(
              'Add Author',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(color: secondaryColor),
            ),
            content: SizedBox(
              width: 300,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      border: Border.all(color: hintColor),
                    ),
                    alignment: Alignment.center,
                    child: fromPicker == null
                        ? IconButton(
                            onPressed: () async {
                              fromPicker =
                                  await ImagePickerWeb.getImageAsBytes();
                              setState(() {});
                            },
                            icon: const Icon(LineAwesomeIcons.plus))
                        : Image.memory(
                            fromPicker!,
                            width: 80,
                            height: 80,
                          ),
                  ),
                  verticalGap(defaultPadding),
                  InputFieldRound(
                      hint: 'Name',
                      controller: nameCtrl,
                      keyboardType: TextInputType.name,
                      obscure: false,
                      icon: LineAwesomeIcons.icons),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  if (nameCtrl.text.isEmpty || fromPicker == null) {
                    ToastService.instance.showError('Name or image is empty');
                    return;
                  }

                  String imageLink = await StorageProvider.instance.uploadFile(
                      'author', DateTime.now().toIso8601String(), fromPicker!);
                  Map<String, dynamic> reqBody = {};
                  reqBody['name'] = nameCtrl.text;
                  reqBody['image'] = imageLink;

                  ApiProvider.instance.createAuthor(reqBody).then((value) {
                    reloadScreen();
                  });
                  Navigator.pop(context);
                },
                child: Text(
                  'Create',
                  style: Theme.of(context)
                      .textTheme
                      .labelLarge
                      ?.copyWith(color: Colors.blue),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Cancel',
                  style: Theme.of(context)
                      .textTheme
                      .labelLarge
                      ?.copyWith(color: Colors.red),
                ),
              ),
            ],
          );
        });
      },
    );
  }
}
