import 'package:flutter/material.dart';
import 'package:humors/app/models/category.dart';
import 'package:humors/app/models/survey.dart';

import 'base_item.dart';

class QuestionItem extends BaseItem {
  QuestionItem({
    required Question question,
    required VoidCallback onTap,
  }) : super(
    name: question.name,
    leading: CircleAvatar(
      child: Text(
        'QT',
        style: TextStyle(color: Colors.white, fontSize: 12),
      ),
      backgroundColor: Colors.yellow,
    ),
    onTap: onTap,
  );
}
