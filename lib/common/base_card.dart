import 'package:flutter/material.dart';

class BaseCard extends StatelessWidget {

  final Widget child;

  const BaseCard({required Widget this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        elevation: 8,
        child: child,
      ),
    );
  }
}