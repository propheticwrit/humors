import 'package:flutter/material.dart';
import 'package:humors/app/models/category.dart';

class CategoryItem extends StatelessWidget {

  final Category category;
  final VoidCallback onTap;

  const CategoryItem({required Category this.category, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        elevation: 8,
        child: ListTile(
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 8, vertical: 5.0),
          leading: CircleAvatar(
            child: Text(
              'CT',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            backgroundColor: Colors.orange,
          ),
          title: Text(
            category.name,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
          ),
          trailing: IconButton(
            icon: const Icon(Icons.keyboard_arrow_right),
            iconSize: 25.0,
            color: Colors.grey,
            onPressed: () {},
          ),
          onTap: onTap,
        ),
      ),
    );
  }
}