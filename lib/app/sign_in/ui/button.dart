import 'package:flutter/material.dart';

class SignInButton extends StatelessWidget {
  SignInButton({
    required this.child,
    required this.primaryColor,
    required this.textColor,
    required this.height,
    required this.onPressed
  });

  final Widget child;
  final Color primaryColor;
  final Color textColor;
  final double height;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ElevatedButton(
        child: child,
        style: ElevatedButton.styleFrom(
            textStyle: TextStyle(
              fontSize: 20,
              color: textColor,
            ),
            primary: primaryColor,
            shape: const BeveledRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
            minimumSize: Size.fromHeight(height)
        ),
        onPressed: onPressed,
      ),
    );
  }
}
