import 'package:flutter/material.dart';

import '../base_card.dart';

class ConfigurationItem extends BaseCard {

  ConfigurationItem({
    required String name,
    required Widget leading,
    required VoidCallback trailingPressed,
    required VoidCallback onTap
  }) : super(
    child: ListTile(
      contentPadding:
      const EdgeInsets.symmetric(horizontal: 8, vertical: 5.0),
      leading: leading,
      title: Text(
        name,
        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
      ),
      trailing: IconButton(
        icon: const Icon(Icons.edit),
        iconSize: 18.0,
        color: Colors.grey,
        onPressed: trailingPressed,
      ),
      onTap: onTap,
    ),
  );
}