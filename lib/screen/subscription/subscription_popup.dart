import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:story_teller_admin/model/subscription_model.dart';

import '../../service/api_provider.dart';
import '../../service/toast_service.dart';
import '../../util/colors.dart';
import '../../util/theme.dart';
import '../../widget/gaps.dart';
import '../../widget/input_field_round.dart';

class SubscriptionPopup {
  static showEditPopup(BuildContext context, SubscriptionModel? subscription,
      Function() reloadScreen) {
    TextEditingController titleCtrl =
        TextEditingController(text: subscription?.title ?? '');
    TextEditingController descCtrl =
        TextEditingController(text: subscription?.description ?? '');
    TextEditingController amountCtrl =
        TextEditingController(text: subscription?.amount.toString() ?? '');
    TextEditingController durationCtrl =
        TextEditingController(text: subscription?.duration.toString() ?? '');
    TextEditingController otherInfoCtrl =
        TextEditingController(text: subscription?.otherInfo ?? '');
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Edit Package',
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
                InputFieldRound(
                    hint: 'Other Info (Top badge)',
                    controller: otherInfoCtrl,
                    keyboardType: TextInputType.name,
                    obscure: false,
                    icon: LineAwesomeIcons.star),
                verticalGap(defaultPadding / 2),
                InputFieldRound(
                    hint: 'Title',
                    controller: titleCtrl,
                    keyboardType: TextInputType.name,
                    obscure: false,
                    icon: LineAwesomeIcons.star),
                verticalGap(defaultPadding / 2),
                InputFieldRound(
                    hint: 'Amount',
                    controller: amountCtrl,
                    keyboardType: TextInputType.number,
                    obscure: false,
                    icon: LineAwesomeIcons.star),
                verticalGap(defaultPadding / 2),
                InputFieldRound(
                    hint: 'Duration in days',
                    controller: durationCtrl,
                    keyboardType: TextInputType.number,
                    obscure: false,
                    icon: LineAwesomeIcons.star),
                verticalGap(defaultPadding / 2),
                InputFieldRound(
                    hint: 'Description',
                    controller: descCtrl,
                    keyboardType: TextInputType.text,
                    obscure: false,
                    icon: LineAwesomeIcons.star),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (titleCtrl.text.isEmpty ||
                    descCtrl.text.isEmpty ||
                    amountCtrl.text.isEmpty ||
                    durationCtrl.text.isEmpty) {
                  ToastService.instance.showError(
                      'Title or Desciption or Amount or Duration is empty');
                  return;
                }
                subscription?.title = titleCtrl.text;
                subscription?.description = descCtrl.text;
                subscription?.otherInfo = otherInfoCtrl.text;
                subscription?.duration = int.parse(durationCtrl.text);
                subscription?.amount = int.parse(amountCtrl.text);

                Map<String, dynamic> reqBody = subscription?.toMap() ?? {};
                reqBody.remove('id');

                ApiProvider.instance
                    .updateSubscription(subscription?.id ?? -1, reqBody)
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
      },
    );
  }

  static showCreatePopup(BuildContext context, Function() reloadScreen) {
    TextEditingController titleCtrl = TextEditingController();
    TextEditingController descCtrl = TextEditingController();
    TextEditingController amountCtrl = TextEditingController();
    TextEditingController durationCtrl = TextEditingController();
    TextEditingController otherInfoCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Create Package',
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
                InputFieldRound(
                    hint: 'Other Info (Top badge)',
                    controller: otherInfoCtrl,
                    keyboardType: TextInputType.name,
                    obscure: false,
                    icon: LineAwesomeIcons.star),
                verticalGap(defaultPadding / 2),
                InputFieldRound(
                    hint: 'Title',
                    controller: titleCtrl,
                    keyboardType: TextInputType.name,
                    obscure: false,
                    icon: LineAwesomeIcons.star),
                verticalGap(defaultPadding / 2),
                InputFieldRound(
                    hint: 'Amount',
                    controller: amountCtrl,
                    keyboardType: TextInputType.number,
                    obscure: false,
                    icon: LineAwesomeIcons.star),
                verticalGap(defaultPadding / 2),
                InputFieldRound(
                    hint: 'Duration in days',
                    controller: durationCtrl,
                    keyboardType: TextInputType.number,
                    obscure: false,
                    icon: LineAwesomeIcons.star),
                verticalGap(defaultPadding / 2),
                InputFieldRound(
                    hint: 'Description',
                    controller: descCtrl,
                    keyboardType: TextInputType.text,
                    obscure: false,
                    icon: LineAwesomeIcons.star),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (titleCtrl.text.isEmpty ||
                    descCtrl.text.isEmpty ||
                    amountCtrl.text.isEmpty ||
                    durationCtrl.text.isEmpty) {
                  ToastService.instance.showError(
                      'Title or Desciption or Amount or Duration is empty');
                  return;
                }
                SubscriptionModel subscription = SubscriptionModel();
                subscription.title = titleCtrl.text;
                subscription.description = descCtrl.text;
                subscription.otherInfo = otherInfoCtrl.text;
                subscription.duration = int.parse(durationCtrl.text);
                subscription.amount = int.parse(amountCtrl.text);

                Map<String, dynamic> reqBody = subscription.toMap();
                reqBody.remove('id');

                ApiProvider.instance.createSubscription(reqBody).then((value) {
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
      },
    );
  }
}
