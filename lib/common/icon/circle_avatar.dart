import 'package:flutter/material.dart';

class CardAvatar extends StatelessWidget {

  final String text;

  const CardAvatar({required String this.text});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Colors.black45,
      radius: 17.0,
      child: CircleAvatar(
        backgroundColor: Colors.white,
        radius: 16.0,
        child: Text(
          text,
          style: TextStyle(color: Colors.grey, fontSize: 12),
        ),
      ),
    );
  }
}