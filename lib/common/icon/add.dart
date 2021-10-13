import 'package:flutter/material.dart';

class IconAddButton extends StatelessWidget {
  const IconAddButton({
    required this.onPressedButton,
  });

  final ValueChanged<String> onPressedButton;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.add),
      iconSize: 20.0,
      color: Colors.grey,
      onPressed: () => onPressedButton,
    );
  }
}
