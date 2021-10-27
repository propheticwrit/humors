import 'package:flutter/material.dart';
import 'package:humors/app/models/category.dart';
import 'package:humors/app/models/survey.dart';
import 'package:humors/common/icon/circle_avatar.dart';

import 'base_item.dart';

class QuestionItem extends BaseItem {
  QuestionItem({
    required Question question,
    required VoidCallback onTap,
    required VoidCallback onPressed,
    required VoidCallback onLongPress,
  }) : super(
    name: question.name,
    leading: CardAvatar(text: 'QT'),
    onTap: onTap,
    onPressed: onPressed,
    onLongPress: onLongPress,
  );
}
