import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:humors/app/models/category.dart';
import 'package:humors/app/ui/pages/configuration/survey.dart';
import 'package:humors/common/form_dialog.dart';
import 'package:humors/common/list/add_item.dart';
import '../../nav/menu.dart';
import 'package:humors/common/list/category_item.dart';
import 'package:humors/services/api.dart';
import 'package:provider/provider.dart';

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
          SizedBox(width: 50),
          Text(
            baseCategory.name,
            style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    ));

    if (childCategories != null) {
      columnList.add(
        AddItem(
          label: 'Add Category',
          // onPressed: () => AddCategoryPage.show(context, parentID: baseCategory.id != null ? baseCategory.id! : 1),
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
                      context, baseCategory.id != null ? baseCategory.id : 1),
                ),
              ],
            ),
          ),
        ),
      );
      for (Category childCategory in childCategories) {
        columnList.add(CategoryItem(
            category: childCategory,
            onTap: () => EditCategoryPage.show(
                context: context, category: childCategory)));
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
    // Category? base;
    // Category? child;
    //
    // if (baseCategories != null) {
    //   for (Category baseCategory in baseCategories!.keys) {
    //     base = baseCategory;
    //     List<Category>? categories = baseCategories![baseCategory];
    //     if ( categories != null ) {
    //       for (Category c in categories) {
    //         if (c.id == category.id) {
    //           child = c;
    //           break;
    //         }
    //       }
    //     }
    //   }
    //
    //   if ( base != null && child != null ) {
    //     if ( baseCategories![base] != null ) {
    //       baseCategories![base]!.remove(child);
    //     }
    //   }
    // }
  }

  Future<void> _submit(BuildContext context, int? parentID) async {
    if (_validateAndSaveForm()) {
      CategoryListBloc categoryListBloc = CategoryListBloc();
      categoryListBloc.addCategory(Category(name: _name, parent: parentID));
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CategoryListPage()),
      );
    }
  }
}
