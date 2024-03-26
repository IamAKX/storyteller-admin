import 'dart:developer';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:story_teller_admin/model/author_model.dart';
import 'package:story_teller_admin/model/author_model_list.dart';
import 'package:story_teller_admin/model/category_model.dart';
import 'package:story_teller_admin/model/category_model_list.dart';
import 'package:story_teller_admin/model/story_chat_model.dart';
import 'package:story_teller_admin/model/story_model.dart';
import 'package:story_teller_admin/model/story_model_list.dart';
import 'package:story_teller_admin/util/colors.dart';

import '../../service/api_provider.dart';
import '../../service/storage_provider.dart';
import '../../service/toast_service.dart';
import '../../util/theme.dart';
import '../../widget/gaps.dart';
import '../../widget/header.dart';
import '../../widget/input_field_round.dart';
import '../author/author_popup.dart';
import 'story_popups.dart';

class StoryScreen extends StatefulWidget {
  const StoryScreen({super.key, required this.navigateMenu});
  final Function(int index) navigateMenu;

  @override
  State<StoryScreen> createState() => _StoryScreenState();
}

class _StoryScreenState extends State<StoryScreen> {
  final TextEditingController search = TextEditingController();
  late ApiProvider _api;
  StoryModelList? storyModelList;
  int selectedStory = -1;
  List<StoryChatModel> storyChatList = [];
  CategoryModelList? categoryModelList;
  AuthorModelList? authorModelList;
  String selectedItem = 'ME';
  ScrollController storyChatScrollController = ScrollController();
  double height = 0;
  TextEditingController messageCtrl = TextEditingController();
  scrollToBottom() {
    log('mex = ${storyChatScrollController.position.maxScrollExtent}');
    storyChatScrollController
        .jumpTo(storyChatScrollController.position.maxScrollExtent);
  }

  @override
  void initState() {
    super.initState();
    search.addListener(() {
      String searchText = search.text;
      if (searchText.isEmpty) {
        reloadScreen();
      } else {
        fetchStoryByName(searchText);
      }
    });
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        loadCategortAndAuthor();
        reloadScreen();
      },
    );
  }

  loadCategortAndAuthor() async {
    categoryModelList = await _api.getAllCategory();
    authorModelList = await _api.getAllAuthor();
    setState(() {});
    log('category : ${categoryModelList?.data?.length}');
    log('author : ${authorModelList?.data?.length}');
  }

  fetchStoryByName(String name) {
    _api.getStoryByName(name).then((value) {
      setState(() {
        storyModelList = value;
      });
    });
  }

  reloadScreen() {
    _api.getAllStory().then((value) {
      setState(() {
        storyModelList = value;
      });
    });
  }

  loadStoryChatByStoryId(int id) async {
    selectedStory = id;

    _api.getStoryChatByStoryId(id).then((value) {
      storyChatList = value?.data ?? [];
      setState(() {});
      scrollToBottom();
    });
  }

  loadStoryChatByStoryIdWithoutScroll(int id) async {
    selectedStory = id;
    _api.getStoryChatByStoryId(id).then((value) {
      storyChatList = value?.data ?? [];
      setState(() {});
    });
  }

  deleteChatStory(int id, int storyId) {
    _api
        .deleteStoryChat(id)
        .then((value) => loadStoryChatByStoryIdWithoutScroll(storyId));
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    _api = Provider.of<ApiProvider>(context);
    return getBody(context);
  }

  Widget getBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(defaultPadding),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          const Header(title: 'Story'),
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(
                'All story',
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
                onPressed: (authorModelList?.data?.isNotEmpty ?? false) &&
                        (categoryModelList?.data?.isNotEmpty ?? false)
                    ? () {
                        StoryPopup.showCreatePopup(
                            context,
                            authorModelList!.data!,
                            categoryModelList!.data!,
                            reloadScreen);
                      }
                    : null,
                child: const Text('Create New'),
              ),
            ],
          ),
          verticalGap(defaultPadding),
          Expanded(
            child: Row(
              children: [getStoryListView(), getStoryDetailView()],
            ),
          )
        ],
      ),
    );
  }

  Expanded getStoryDetailView() {
    final List<String> items = ['ME', 'OTHER'];
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(defaultPadding),
        height: double.infinity,
        color: Colors.blue.withOpacity(0.1),
        child: Center(
          child: Column(
            children: [
              storyChatList.isEmpty
                  ? Expanded(
                      child: Center(
                        child: Text(
                          'No chat added',
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(
                                color: hintColor,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                    )
                  : Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        padding: const EdgeInsets.only(bottom: defaultPadding),
                        controller: storyChatScrollController,
                        itemBuilder: (context, index) {
                          StoryChatModel chat = storyChatList.elementAt(index);
                          return InkWell(
                            onTap: () {
                              StoryPopup.showEditChatPopup(
                                  context,
                                  chat,
                                  loadStoryChatByStoryIdWithoutScroll,
                                  deleteChatStory);
                            },
                            child: ChatBubble(
                              clipper: ChatBubbleClipper5(
                                type: chat.sender == 'ME'
                                    ? BubbleType.sendBubble
                                    : BubbleType.receiverBubble,
                              ),
                              alignment: chat.sender == 'ME'
                                  ? Alignment.topRight
                                  : Alignment.topLeft,
                              margin: const EdgeInsets.only(top: 10),
                              backGroundColor: chat.sender == 'ME'
                                  ? Colors.blue
                                  : Colors.white,
                              child: Container(
                                constraints: const BoxConstraints(
                                  maxWidth: 200,
                                  //MediaQuery.of(context).size.width * 0.7,
                                ),
                                child: chat.messageType == 'TEXT'
                                    ? Text(
                                        chat.text ?? '',
                                        style: TextStyle(
                                          color: chat.sender == 'ME'
                                              ? Colors.white
                                              : textColorDark,
                                        ),
                                      )
                                    : CachedNetworkImage(
                                        imageUrl: '${chat.mediaUrl}',
                                        fit: BoxFit.fitWidth,
                                        placeholder: (context, url) =>
                                            const CircularProgressIndicator(),
                                        errorWidget: (context, url, error) =>
                                            const Center(
                                          child: Text('Image not loaded'),
                                        ),
                                      ),
                              ),
                            ),
                          );
                        },
                        itemCount: storyChatList.length,
                      ),
                    ),
              Row(
                children: [
                  DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: selectedItem,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedItem = newValue!;
                        });
                        log('selecte  dItem : $selectedItem');
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
                  Expanded(
                    child: TextField(
                      controller: messageCtrl,
                      onSubmitted: (value) {
                        if (messageCtrl.text.isEmpty) return;
                        // createChat
                        Map<String, dynamic> reqBody = {
                          'story': {'id': selectedStory},
                          'text': messageCtrl.text,
                          'mediaUrl': '',
                          'messageType': 'TEXT',
                          'reactionType': '',
                          'reactionEnabled': false,
                          'sender': selectedItem,
                          'chatTimestamp': ''
                        };
                        _api.createStoryChat(reqBody).then((value) async {
                          messageCtrl.text = '';
                          await loadStoryChatByStoryId(selectedStory);
                          scrollToBottom();
                        });
                      },
                      decoration: InputDecoration(
                        hintStyle: const TextStyle(fontSize: 14),
                        alignLabelWithHint: true,
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        suffixIcon: IconButton(
                          onPressed: () {
                            if (messageCtrl.text.isEmpty) return;
                            // createChat
                            Map<String, dynamic> reqBody = {
                              'story': {'id': selectedStory},
                              'text': messageCtrl.text,
                              'mediaUrl': '',
                              'messageType': 'TEXT',
                              'reactionType': '',
                              'reactionEnabled': false,
                              'sender': selectedItem,
                              'chatTimestamp': ''
                            };
                            _api.createStoryChat(reqBody).then((value) async {
                              messageCtrl.text = '';
                              await loadStoryChatByStoryId(selectedStory);
                              scrollToBottom();
                            });
                          },
                          icon: const Icon(
                            Icons.send,
                            color: primaryColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                  horizontalGap(10),
                  IconButton(
                    onPressed: () async {
                      Uint8List? fromPicker;
                      fromPicker = await ImagePickerWeb.getImageAsBytes();
                      if (fromPicker == null) {
                        ToastService.instance.showError('Select image');
                        return;
                      }
                      Map<String, dynamic> reqBody = {
                        'story': {'id': selectedStory},
                        'text': '',
                        'mediaUrl': await StorageProvider.instance.uploadFile(
                            'story',
                            DateTime.now().toIso8601String(),
                            fromPicker!),
                        'messageType': 'IMAGE',
                        'reactionType': '',
                        'reactionEnabled': false,
                        'sender': selectedItem,
                        'chatTimestamp': ''
                      };
                      _api.createStoryChat(reqBody).then((value) async {
                        messageCtrl.text = '';
                        await loadStoryChatByStoryId(selectedStory);
                        scrollToBottom();
                      });
                    },
                    icon: const Icon(
                      Icons.image,
                      color: primaryColor,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Expanded getStoryListView() {
    return Expanded(
      child: ListView.separated(
          itemBuilder: (context, index) {
            StoryModel? model = storyModelList?.data?.elementAt(index);
            return ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: CachedNetworkImage(
                  imageUrl: '${model?.image}',
                  fit: BoxFit.cover,
                  width: 50,
                  height: 50,
                  placeholder: (context, url) =>
                      const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => const Center(
                    child: Text('Image not loaded'),
                  ),
                ),
              ),
              title: Text(
                model?.name ?? '-',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                  'By ${model?.author?.name} | ${model?.category?.name} | ${model?.tags}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () {
                      StoryPopup.showUpdateStoryPopup(
                          model,
                          context,
                          authorModelList!.data!,
                          categoryModelList!.data!,
                          reloadScreen);
                    },
                    icon: const Icon(
                      LineAwesomeIcons.edit,
                      color: Colors.blue,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      _api
                          .deleteStory(model!.id!)
                          .then((value) => reloadScreen());
                    },
                    icon: const Icon(
                      LineAwesomeIcons.trash,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
              onTap: () async {
                loadStoryChatByStoryId(model?.id ?? -1);
                await scrollToBottom();
              },
            );
          },
          separatorBuilder: (context, index) {
            return const Divider(color: dividerColor);
          },
          itemCount: storyModelList?.data?.length ?? 0),
    );
  }
}
