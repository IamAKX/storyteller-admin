import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:story_teller_admin/model/story_chat_model.dart';
import 'package:story_teller_admin/model/story_model.dart';

import '../../model/author_model.dart';
import '../../model/category_model.dart';
import '../../service/api_provider.dart';
import '../../service/storage_provider.dart';
import '../../service/toast_service.dart';
import '../../util/colors.dart';
import '../../util/theme.dart';
import '../../widget/gaps.dart';
import '../../widget/input_field_round.dart';

class StoryPopup {
  static List<String> items = ['ME', 'OTHER'];

  static showEditChatPopup(BuildContext context, StoryChatModel? chatModel,
      Function() reloadChat, Function(int, int) deleteChat) {
    TextEditingController textCtrl =
        TextEditingController(text: chatModel?.text ?? '');
    String selectedItem = chatModel?.sender ?? 'ME';
    Uint8List? fromPicker;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: Text(
              'Edit Chat',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(color: secondaryColor),
            ),
            content: SizedBox(
              width: 500,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  (chatModel?.messageType == 'TEXT')
                      ? InputFieldRound(
                          hint: 'Message',
                          controller: textCtrl,
                          keyboardType: TextInputType.name,
                          obscure: false,
                        )
                      : Row(
                          children: [
                            CachedNetworkImage(
                              imageUrl: '${chatModel?.mediaUrl}',
                              fit: BoxFit.cover,
                              width: 80,
                              height: 80,
                              placeholder: (context, url) =>
                                  const CircularProgressIndicator(),
                              errorWidget: (context, url, error) =>
                                  const Center(
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
                                        fromPicker = await ImagePickerWeb
                                            .getImageAsBytes();
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
                  verticalGap(defaultPadding / 2),
                  DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: selectedItem,
                      onChanged: (String? newValue) {
                        selectedItem = newValue!;
                      },
                      items: items.map<DropdownMenuItem<String>>(
                        (String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        },
                      ).toList(),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  Map<String, dynamic> reqBody = {};
                  reqBody['sender'] = selectedItem;
                  if (chatModel?.messageType == 'TEXT' &&
                      textCtrl.text.isEmpty) {
                    ToastService.instance.showError('Message cannot be empty');
                    return;
                  }
                  if (chatModel?.messageType == 'IMAGE' && fromPicker == null) {
                    ToastService.instance
                        .showError('Selected image cannot be empty');
                    return;
                  }
                  if (chatModel?.messageType == 'TEXT') {
                    reqBody['text'] = textCtrl.text;
                  } else {
                    reqBody['mediaUrl'] = await StorageProvider.instance
                        .uploadFile('author', DateTime.now().toIso8601String(),
                            fromPicker!);
                  }
                  ApiProvider.instance
                      .updateStoryChat(chatModel?.id ?? -1, reqBody)
                      .then((value) {
                    reloadChat();
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
                  deleteChat(chatModel!.id!, chatModel.story!.id!);
                  Navigator.pop(context);
                },
                child: Text(
                  'Delete',
                  style: Theme.of(context)
                      .textTheme
                      .labelLarge
                      ?.copyWith(color: Colors.red),
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
                      ?.copyWith(color: Colors.amber),
                ),
              ),
            ],
          );
        });
      },
    );
  }

  static showCreatePopup(BuildContext context, List<AuthorModel> authorList,
      List<CategoryModel> categoryList, Function() reloadScreen) {
    AuthorModel? authorModel;
    CategoryModel? categoryModel;
    Uint8List? fromPicker;
    TextEditingController nameCtrl = TextEditingController();
    TextEditingController tagCtrl = TextEditingController();
    TextEditingController userMeCtrl = TextEditingController();
    TextEditingController userOtherCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: Text(
              'Add Story',
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
                      hint: 'Tags (coma separated)',
                      controller: tagCtrl,
                      keyboardType: TextInputType.name,
                      obscure: false,
                      icon: LineAwesomeIcons.icons),
                  verticalGap(defaultPadding / 2),
                  InputFieldRound(
                      hint: 'Right side user name',
                      controller: userMeCtrl,
                      keyboardType: TextInputType.name,
                      obscure: false,
                      icon: LineAwesomeIcons.user),
                  verticalGap(defaultPadding / 2),
                  InputFieldRound(
                      hint: 'Left side user name',
                      controller: userOtherCtrl,
                      keyboardType: TextInputType.name,
                      obscure: false,
                      icon: LineAwesomeIcons.user_1),
                  verticalGap(defaultPadding / 2),
                  DropdownButtonHideUnderline(
                    child: DropdownButton<AuthorModel>(
                      hint: const Text('Select Author'),
                      value: authorModel,
                      onChanged: (AuthorModel? newValue) {
                        authorModel = newValue!;
                        setState(() {});
                      },
                      items: authorList.map((AuthorModel author) {
                        return DropdownMenuItem<AuthorModel>(
                          value: author,
                          child: Text(author.name!),
                        );
                      }).toList(),
                    ),
                  ),
                  verticalGap(defaultPadding / 2),
                  DropdownButtonHideUnderline(
                    child: DropdownButton<CategoryModel>(
                      hint: const Text('Select category'),
                      value: categoryModel,
                      onChanged: (CategoryModel? newValue) {
                        categoryModel = newValue!;
                        setState(() {});
                      },
                      items: categoryList.map((CategoryModel category) {
                        return DropdownMenuItem<CategoryModel>(
                          value: category,
                          child: Text(category.name!),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  if (nameCtrl.text.isEmpty ||
                      categoryModel == null ||
                      authorModel == null ||
                      fromPicker == null ||
                      userMeCtrl.text.isEmpty ||
                      userOtherCtrl.text.isEmpty) {
                    ToastService.instance.showError(
                        'Name, Category, Left user name, Right user name, Author or Image is empty');
                    return;
                  }
                  Map<String, dynamic> reqBody = {
                    "category": {"id": categoryModel!.id},
                    "author": {"id": authorModel!.id},
                    "name": nameCtrl.text,
                    "image": await StorageProvider.instance.uploadFile(
                        'story', DateTime.now().toIso8601String(), fromPicker!),
                    "tags": tagCtrl.text,
                    "userMe": userMeCtrl.text,
                    "userOther": userOtherCtrl.text
                  };

                  ApiProvider.instance.createStory(reqBody).then((value) {
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

  static showUpdateStoryPopup(
      StoryModel? storyModel,
      BuildContext context,
      List<AuthorModel> authorList,
      List<CategoryModel> categoryList,
      Function() reloadScreen) {
    AuthorModel? authorModel;
    CategoryModel? categoryModel;
    Uint8List? fromPicker;
    TextEditingController nameCtrl =
        TextEditingController(text: storyModel?.name ?? '');
    TextEditingController tagCtrl =
        TextEditingController(text: storyModel?.tags ?? '');

    authorModel = authorList
        .firstWhere((element) => element.id == storyModel?.author?.id);
    categoryModel = categoryList
        .firstWhere((element) => element.id == storyModel?.category?.id);

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: Text(
              'Update Story',
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
                        imageUrl: '${storyModel?.image}',
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
                      hint: 'Tags (coma separated)',
                      controller: tagCtrl,
                      keyboardType: TextInputType.name,
                      obscure: false,
                      icon: LineAwesomeIcons.icons),
                  verticalGap(defaultPadding / 2),
                  DropdownButtonHideUnderline(
                    child: DropdownButton<AuthorModel>(
                      hint: const Text('Select Author'),
                      value: authorModel,
                      onChanged: (AuthorModel? newValue) {
                        authorModel = newValue!;
                        setState(() {});
                      },
                      items: authorList.map((AuthorModel author) {
                        return DropdownMenuItem<AuthorModel>(
                          value: author,
                          child: Text(author.name!),
                        );
                      }).toList(),
                    ),
                  ),
                  verticalGap(defaultPadding / 2),
                  DropdownButtonHideUnderline(
                    child: DropdownButton<CategoryModel>(
                      hint: const Text('Select category'),
                      value: categoryModel,
                      onChanged: (CategoryModel? newValue) {
                        categoryModel = newValue!;
                        setState(() {});
                      },
                      items: categoryList.map((CategoryModel category) {
                        return DropdownMenuItem<CategoryModel>(
                          value: category,
                          child: Text(category.name!),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  if (nameCtrl.text.isEmpty ||
                      categoryModel == null ||
                      authorModel == null) {
                    ToastService.instance
                        .showError('Name, Category, Author or Image is empty');
                    return;
                  }
                  Map<String, dynamic> reqBody = {
                    "category": {"id": categoryModel!.id},
                    "author": {"id": authorModel!.id},
                    "name": nameCtrl.text,
                    "tags": tagCtrl.text
                  };
                  if (fromPicker != null) {
                    String imageLink = await StorageProvider.instance
                        .uploadFile('author', DateTime.now().toIso8601String(),
                            fromPicker!);
                    reqBody['image'] = imageLink;
                  }
                  ApiProvider.instance
                      .updateStory(storyModel!.id!, reqBody)
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
}
