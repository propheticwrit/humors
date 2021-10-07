import 'package:flutter/material.dart';
import '../nav/menu.dart';

import 'package:humors/services/models/api_user.dart';

import 'login_bloc.dart';

class HomePage extends StatelessWidget {
  final loginBloc = LoginBloc();

  @override
  Widget build(BuildContext context) {
    Menu menu = Menu();
    return StreamBuilder<APIUser>(
      stream: loginBloc.apiUser,
      builder: (context, snapshot) {
        if( snapshot.connectionState == ConnectionState.waiting ) {
          loginBloc.login();
          return Scaffold(
            appBar: AppBar(
              title: Text('Home Page'),
              centerTitle: true,
              actions: <Widget>[
                menu.buildMenu(context),
              ],
            ),
            body: Center(child: CircularProgressIndicator()),
          );
        } else {
          APIUser? user = snapshot.data;
          return Scaffold(
            appBar: AppBar(
              title: Text('Home Page'),
              centerTitle: true,
              actions: <Widget>[
                menu.buildMenu(context),
              ],
            ),
            body: _buildContents(context, snapshot.hasData ? snapshot.data : null),
          );
        }
      }
    );
  }

  Widget _buildContents(BuildContext context, APIUser? user) {
    if ( user != null ) {
      return Center(child: Text('User: ${user.username}'));
    } else {
      loginBloc.login();
      return Center(child: Text('Null API User'));
    }
  }
}
