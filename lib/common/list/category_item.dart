import 'package:flutter/material.dart';
import 'package:humors/app/models/category.dart';

import 'base_item.dart';

class CategoryItem extends BaseItem {
  CategoryItem({
    required Category category,
    required VoidCallback onTap,
  }) : super(
          name: category.name,
          leading: CircleAvatar(
            child: Text(
              'CT',
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
            backgroundColor: Colors.orange,
          ),
          onTap: onTap,
        );
}
