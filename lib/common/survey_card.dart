import 'package:flutter/material.dart';
import 'package:humors/app/models/survey.dart';

import 'base_card.dart';
import 'icon/circle_avatar.dart';

class SurveyCard extends BaseCard {
  SurveyCard({
    required Survey survey,
    required List<Widget> questionList,
    required VoidCallback onPressed,
  }) : super(
    child: Column(
      children: [
        ListTile(
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 8, vertical: 5.0),
          leading: CardAvatar(text: 'SV'),
          title: Text(
            survey.name,
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
          ),
          trailing: IconButton(
            icon: const Icon(Icons.arrow_circle_up_rounded),
            iconSize: 20.0,
            color: Colors.grey,
            onPressed: onPressed,
          ),
        ),
        Column(
            children: questionList,
        ),
      ],
    ),
        );


}
