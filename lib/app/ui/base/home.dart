import 'package:flutter/material.dart';
import '../nav/menu.dart';
import 'package:humors/services/api.dart';
import 'package:provider/provider.dart';

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
          return Center(child: CircularProgressIndicator());
        } else {
          if ( snapshot.hasData ) {
            APIUser? user = snapshot.data;
            return Scaffold(
              appBar: AppBar(
                title: Text('Home Page'),
                centerTitle: true,
                actions: <Widget>[
                  menu.buildMenu(context),
                ],
              ),
              body: _buildContents(context, user),
            );
          } else if ( snapshot.hasError ) {
            loginBloc.login();
            return Center(child: CircularProgressIndicator());
          }
        }
        return Center(child: CircularProgressIndicator());
      }
    );
  }

  Widget _buildContents(BuildContext context, APIUser? user) {
    if ( user != null ) {
      return Center(child: Text('User: ${user.username}'));
    } else {
      return Center(child: Text('Null API User'));
    }
  }
}
