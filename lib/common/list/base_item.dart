import 'package:flutter/material.dart';

import '../base_card.dart';

class BaseItem extends BaseCard {

  BaseItem({
    required String name,
    required Widget leading,
    required VoidCallback onTap
  }) : super(
    child: ListTile(
      contentPadding:
      const EdgeInsets.symmetric(horizontal: 8, vertical: 5.0),
      leading: leading,
      title: Text(
        name,
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
      ),
      trailing: IconButton(
        icon: const Icon(Icons.keyboard_arrow_right),
        iconSize: 20.0,
        color: Colors.grey,
        onPressed: () {},
      ),
      onTap: onTap,
    ),
  );
}