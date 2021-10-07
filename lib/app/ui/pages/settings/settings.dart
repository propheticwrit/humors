import 'package:flutter/material.dart';
import 'package:humors/app/models/category.dart';
import '../../nav/menu.dart';
import 'package:humors/services/api.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage();

  static Future<void> show({required BuildContext context}) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SettingsPage(),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  State<StatefulWidget> createState() => _SettingsPageState();
}


class _SettingsPageState extends State<SettingsPage> {

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
