import 'package:flutter/material.dart';
import 'package:humors/app/models/category.dart';
import 'package:humors/app/models/survey.dart';

import 'base_item.dart';

class SurveyItem extends BaseItem {
  SurveyItem({
    required Survey survey,
    required VoidCallback onTap,
  }) : super(
    name: survey.name,
    leading: CircleAvatar(
      child: Text(
        'SV',
        style: TextStyle(color: Colors.white, fontSize: 12),
      ),
      backgroundColor: Colors.yellow,
    ),
    onTap: onTap,
  );
}
