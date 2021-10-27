import 'package:flutter/material.dart';
import 'package:humors/app/models/survey.dart';
import 'package:humors/common/icon/circle_avatar.dart';

import 'base_item.dart';

class SurveyItem extends BaseItem {
  SurveyItem({
    required Survey survey,
    required VoidCallback onTap,
    required VoidCallback onPressed,
    required VoidCallback onLongPress,
  }) : super(
    name: survey.name,
    leading: CardAvatar(text: 'SV'),
    onTap: onTap,
    onPressed: onPressed,
    onLongPress: onLongPress,
  );
}
