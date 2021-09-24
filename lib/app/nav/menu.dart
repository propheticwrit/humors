import 'package:flutter/material.dart';
import 'package:humors/app/configuration/ui/configuration.dart';
import 'package:humors/app/settings/ui/settings.dart';
import 'package:humors/common/alert_dialog.dart';
import 'package:humors/services/api.dart';
import 'package:humors/services/auth.dart';
import 'package:provider/provider.dart';

class Menu {

  final Connector connector;

  const Menu({required this.connector});

  PopupMenuButton buildMenu(BuildContext context) {
    return PopupMenuButton(
      icon: Icon(Icons.menu),  //don't specify icon if you want 3 dot menu
      offset: Offset(0, 45),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      itemBuilder: (context) => [
        _buildMenuItem(value: 0, text: 'Settings', icon: Icon(Icons.settings, color: Colors.black54)),
        _buildMenuItem(value: 1, text: 'Configuration', icon: Icon(Icons.build, color: Colors.black54)),
        _buildMenuItem(value: 2, text: 'Logout', icon: Icon(Icons.logout, color: Colors.black54)),
      ],
      onSelected: (item) => _selectedItem(context, connector, item),
    );
  }

  PopupMenuItem<int> _buildMenuItem({required int value, required String text, Icon? icon}) {
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

  void _selectedItem(BuildContext context, Connector connector, item) {
    switch (item) {
      case 0:
        SettingsPage.show(context: context, connector: connector);
        break;
      case 1:
        ConfigurationPage.show(context: context, connector: connector);
        break;
      case 2:
        print("User Logged out");
        _confirmSignOut(context);
        break;
    }
  }

  Future<void> _signOut(BuildContext context) async {
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      await auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _confirmSignOut(BuildContext context) async {
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