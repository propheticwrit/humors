import 'package:flutter/material.dart';
import 'package:humors/app/models/category.dart';
import '../../nav/menu.dart';
import 'package:humors/services/api.dart';

class ConfigurationPage extends StatefulWidget {
  const ConfigurationPage({required this.connector});
  final Connector connector;

  static Future<void> show({required BuildContext context, required Connector connector}) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ConfigurationPage(connector: connector),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  State<StatefulWidget> createState() => _ConfigurationPageState();
}


class _ConfigurationPageState extends State<ConfigurationPage> {

  @override
  Widget build(BuildContext context) {
    final apiConnector = widget.connector;

    return StreamBuilder<List<Category>>(
      stream: apiConnector.categories,
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting) {
          apiConnector.apiCategories();
          return Center(child: CircularProgressIndicator());
        } else {
          final List<Category>? categories = snapshot.data;
          if (categories != null) {
            Menu menu = Menu(connector: widget.connector);
            return Scaffold(
              appBar: AppBar(
                elevation: 2.0,
                title: Text('Configure'),
                centerTitle: true,
                actions: <Widget>[
                  menu.buildMenu(context),
                ],
              ),
              body: _buildContent(context, categories),
            );
          } else {
            return Center(child: Text('No data in categories list'));
          }
        }
      },
    );
  }

  Widget _buildContent(BuildContext context, List<Category> categories) {
    return ListView.builder(
      itemCount: categories.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(categories[index].name),
        );
      },
    );
  }
}