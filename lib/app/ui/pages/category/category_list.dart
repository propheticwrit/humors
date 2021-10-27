import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:humors/app/models/category.dart';
import 'package:humors/app/ui/pages/configuration/configuration.dart';
import 'package:humors/common/list/add_item.dart';
import 'package:uuid/uuid.dart';
import '../../nav/menu.dart';
import 'package:humors/common/list/category_item.dart';

import 'edit_category.dart';
import 'category_list_bloc.dart';

class CategoryListPage extends StatelessWidget {
  final categoryListBloc = CategoryListBloc();

  final _formKey = GlobalKey<FormState>();

  String _name = '';

  @override
  Widget build(BuildContext context) {
    Menu menu = Menu();
    return StreamBuilder<Map<Category, List<Category>>>(
      stream: categoryListBloc.baseCategories,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          categoryListBloc.fetchBaseCategories();
          return Center(child: CircularProgressIndicator());
        } else {
          Map<Category, List<Category>>? baseCategories = snapshot.data;
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
              body: baseCategories != null
                  ? _buildContent(context, baseCategories)
                  : Text('No categories found for this user.'),
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
        return Column(
          children:
              _columnList(context, baseCategory, baseCategories[baseCategory]),
        );
      },
    );
  }

  List<Widget> _columnList(BuildContext context, Category baseCategory,
      List<Category>? childCategories) {
    List<Widget> columnList = <Widget>[];
    columnList.add(Padding(
      padding: const EdgeInsets.all(15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(width: 30),
          ElevatedButton(
            child: Text(baseCategory.name, style: TextStyle(color: Colors.black, fontSize: 18),),
            style: ElevatedButton.styleFrom(
                primary: Colors.orange,
                onPrimary: Colors.orange,
                onSurface: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20))
            ),
            onPressed: null,
          ),
        ],
      ),
    ));

    if (childCategories != null) {
      columnList.add(
        AddItem(
          label: 'Add Category',
          onPressed: () => showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Add Category'),
              content: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Category Name'),
                        initialValue: _name,
                        validator: (value) => value != null && value.isNotEmpty
                            ? null
                            : 'Name can\'t be empty',
                        onSaved: (value) => _name = value != null ? value : '',
                      ),
                    ],
                  ),
                ),
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text('Cancel'),
                  onPressed: () => Navigator.of(context).pop(false),
                ),
                FlatButton(
                  child: Text('Submit'),
                  onPressed: () => _submit(
                      context, baseCategory.id),
                ),
              ],
            ),
          ),
        ),
      );
      for (Category childCategory in childCategories) {
        // TODO: on long press opens edit popup
        columnList.add(CategoryItem(
            category: childCategory,
            onTap: () => ConfigurationPage.show(
                context: context, category: childCategory),
            onPressed: () => ConfigurationPage.show(
                context: context, category: childCategory),
            onLongPress: () => {},
        ),
        );
      }
    }
    return columnList;
  }

  bool _validateAndSaveForm() {
    final form = _formKey.currentState;
    if (form != null) {
      if (form.validate()) {
        form.save();
        return true;
      }
    }
    return false;
  }

  Future<void> _delete(BuildContext context, Category category) async {
    CategoryListBloc categoryListBloc = CategoryListBloc();
    await categoryListBloc.deleteCategory(category);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CategoryListPage()),
    );
  }

  Future<void> _submit(BuildContext context, String parentID) async {
    if (_validateAndSaveForm()) {
      var uuid = Uuid();
      CategoryListBloc categoryListBloc = CategoryListBloc();
      categoryListBloc.addCategory(Category(id: uuid.v4(), name: _name, parent: parentID));
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CategoryListPage()),
      );
    }
  }
}
