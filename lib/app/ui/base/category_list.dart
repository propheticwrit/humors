import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:humors/app/models/category.dart';
import '../nav/menu.dart';
import 'package:humors/common/list/category_item.dart';
import 'package:humors/services/api.dart';
import 'package:provider/provider.dart';

class CategoryListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final apiConnector = Provider.of<Connector>(context, listen: false);
    Menu menu = Menu(connector: apiConnector);
    return StreamBuilder<Map<Category, List<Category>>>(
      stream: apiConnector.baseCategories,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          apiConnector.apiBaseCategories();
          return Center(child: CircularProgressIndicator());
        } else {
          final Map<Category, List<Category>>? baseCategories = snapshot.data;
          if (baseCategories != null) {
            return Scaffold(
              appBar: AppBar(
                elevation: 2.0,
                title: Text('Categories'),
                centerTitle: true,
                actions: <Widget>[
                  menu.buildMenu(context),
                ],
              ),
              body: _buildContent(context, baseCategories),
            );
          } else {
            return Center(child: Text('No data in categories list'));
          }
        }
      },
    );
  }

  Widget _buildContent(
      BuildContext context, Map<Category, List<Category>> baseCategories) {
    return ListView.builder(
      itemCount: baseCategories.length,
      itemBuilder: (context, index) {
        Category baseCategory = baseCategories.keys.toList()[index];
        final item = baseCategory.id;
        return Dismissible(
          key: Key(item.toString()),
          onDismissed: (direction) {
            print('dismiss key: ' + item.toString());
          },
          child: Column(
            children: _columnList(baseCategory, baseCategories[baseCategory]),
          ),
        );
      },
    );
  }

  List<Widget> _columnList(
      Category baseCategory, List<Category>? childCategories) {
    List<Widget> columnList = <Widget>[];

    columnList.add(Padding(
      padding: const EdgeInsets.all(15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(width: 50),
          Text(
            baseCategory.name,
            style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    ));

    if (childCategories != null) {
      for (Category childCategory in childCategories) {
        columnList.add(CategoryItem.childCategoryCard(childCategory));
      }
    }
    return columnList;
  }
}
