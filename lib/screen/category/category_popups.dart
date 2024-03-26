import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:story_teller_admin/model/category_model.dart';
import 'package:story_teller_admin/service/api_provider.dart';
import 'package:story_teller_admin/service/toast_service.dart';
import 'package:story_teller_admin/util/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:story_teller_admin/util/theme.dart';
import 'package:story_teller_admin/widget/gaps.dart';
import 'package:story_teller_admin/widget/input_field_round.dart';

import '../../service/storage_provider.dart';

class CategoryPopup {
  static showDetailPopup(
      BuildContext context, CategoryModel? category, Function() reloadScreen) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Category Detail',
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
                CachedNetworkImage(
                  imageUrl: '${category?.icon}',
                  fit: BoxFit.cover,
                  width: 80,
                  height: 80,
                  placeholder: (context, url) =>
                      const CircularProgressIndicator(),
                  errorWidget: (context, url, error) => const Center(
                    child: Text('Image not loaded'),
                  ),
                ),
                verticalGap(defaultPadding),
                Text(
                  '${category?.name}',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(color: secondaryColor),
                ),
                verticalGap(defaultPadding / 2),
                Text(
                  '${category?.description}',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                showEditPopup(context, category, reloadScreen);
              },
              child: Text(
                'Edit',
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
      },
    );
  }

  static showEditPopup(
      BuildContext context, CategoryModel? category, Function() reloadScreen) {
    TextEditingController nameCtrl =
        TextEditingController(text: category?.name ?? '');
    TextEditingController descCtrl =
        TextEditingController(text: category?.description ?? '');
    Uint8List? fromPicker;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: Text(
              'Edit Category',
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
                        imageUrl: '${category?.icon}',
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
                  verticalGap(defaultPadding / 2),
                  InputFieldRound(
                      hint: 'Description',
                      controller: descCtrl,
                      keyboardType: TextInputType.name,
                      obscure: false,
                      icon: LineAwesomeIcons.icons),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  if (nameCtrl.text.isEmpty || descCtrl.text.isEmpty) {
                    ToastService.instance
                        .showError('Name or Desciption is empty');
                    return;
                  }
                  category?.name = nameCtrl.text;
                  category?.description = descCtrl.text;
                  if (fromPicker != null) {
                    String imageLink = await StorageProvider.instance
                        .uploadFile('author', DateTime.now().toIso8601String(),
                            fromPicker!);
                    category?.icon = imageLink;
                  }
                  Map<String, dynamic> reqBody = category?.toMap() ?? {};
                  reqBody.remove('id');

                  ApiProvider.instance
                      .updateCategory(category?.id ?? -1, reqBody)
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
    TextEditingController descCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: Text(
              'Add Category',
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
                  verticalGap(defaultPadding / 2),
                  InputFieldRound(
                      hint: 'Description',
                      controller: descCtrl,
                      keyboardType: TextInputType.name,
                      obscure: false,
                      icon: LineAwesomeIcons.icons),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  if (nameCtrl.text.isEmpty ||
                      descCtrl.text.isEmpty ||
                      fromPicker == null) {
                    ToastService.instance
                        .showError('Name or Desciption or Icon is empty');
                    return;
                  }
                  Map<String, dynamic> reqBody = {};
                  reqBody['name'] = nameCtrl.text;
                  reqBody['description'] = descCtrl.text;
                  reqBody['icon'] = await StorageProvider.instance.uploadFile(
                      'category',
                      DateTime.now().toIso8601String(),
                      fromPicker!);

                  ApiProvider.instance.createCategory(reqBody).then((value) {
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
