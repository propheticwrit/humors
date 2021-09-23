import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:humors/app/models/category.dart';
import 'package:humors/app/nav/menu.dart';
import 'package:humors/services/api.dart';
import 'package:provider/provider.dart';

class CategoryListPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final apiConnector = Provider.of<Connector>(context, listen: false);

    return StreamBuilder<List<Category>>(
        stream: apiConnector.categories,
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting) {
            apiConnector.apiCategories();
            return Center(child: CircularProgressIndicator());
          } else {
            final List<Category>? categories = snapshot.data;
            if (categories != null) {
              return Scaffold(
                appBar: AppBar(
                  elevation: 2.0,
                  title: Text('Categories'),
                  centerTitle: true,
                  actions: <Widget>[
                    Menu.buildMenu(context),
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
