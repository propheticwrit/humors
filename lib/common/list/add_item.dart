import 'package:flutter/material.dart';

import '../base_card.dart';

class AddItem extends BaseCard {

  AddItem({
    required String label,
    required VoidCallback onPressed
  }) : super(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: Text(label),
        ),
        IconButton(
          icon: const Icon(Icons.add),
          iconSize: 20.0,
          color: Colors.grey,
          onPressed: onPressed,
        )
      ],
    ),
  );
}