import 'package:flutter/material.dart';
import 'package:humors/app/settings/ui/settings.dart';
import 'package:humors/common/alert_dialog.dart';
import 'package:humors/services/auth.dart';
import 'package:provider/provider.dart';

class Menu {

  static PopupMenuButton buildMenu(BuildContext context) {
    return PopupMenuButton(
      icon: Icon(Icons.menu),  //don't specify icon if you want 3 dot menu
      color: Colors.blue,
      itemBuilder: (context) => [
        _buildMenuItem(value: 0, text: 'settings'),
        _buildMenuItem(value: 1, text: 'logout', icon: Icon(Icons.logout, color: Colors.red)),
      ],
      onSelected: (item) => _selectedItem(context, item),
    );
  }

  static PopupMenuItem<int> _buildMenuItem({required int value, required String text, Icon? icon}) {
    return PopupMenuItem<int>(
        value: value,
        child: Row(
          children: [
            icon != null ? icon : Icon(Icons.clear, color: Colors.red),
            const SizedBox(
              width: 7,
            ),
            Text(text)
          ],
        )
    );
  }

  static void _selectedItem(BuildContext context, item) {
    switch (item) {
      case 0:
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => SettingsPage()));
        break;
      case 1:
        print("User Logged out");
        _confirmSignOut(context);
        break;
    }
  }

  static Future<void> _signOut(BuildContext context) async {
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      await auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  static Future<void> _confirmSignOut(BuildContext context) async {
    final didRequestSignOut = await showAlertDialog(
      context,
      title: 'Logout',
      content: 'Are you sure that you want to logout?',
      cancelActionText: 'Cancel',
      defaultActionText: 'Logout',
    );
    if (didRequestSignOut == true) {
      _signOut(context);
    }
  }
}