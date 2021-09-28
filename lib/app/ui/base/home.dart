import 'package:flutter/material.dart';
import '../nav/menu.dart';
import 'package:humors/services/api.dart';
import 'package:provider/provider.dart';

import 'package:humors/services/models/api_user.dart';

class HomePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final apiConnector = MoodConnector();
    Menu menu = Menu(connector: apiConnector);
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
        centerTitle: true,
        actions: <Widget>[
          menu.buildMenu(context),
        ],
      ),
      body: _buildContents(context, apiConnector),
    );
  }

  Widget _buildContents(BuildContext context, Connector apiConnector) {
    return StreamBuilder<APIUser>(
      stream: apiConnector.apiUser,
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting) {
          apiConnector.login();
          return Center(child: CircularProgressIndicator());
        } else {
          if (snapshot.hasData) {
            APIUser? user = snapshot.data;
            if ( user != null ) {
              return Center(child: Text('User: ${user.username}'));
            } else {
              return Center(child: Text('Null API User'));
            }
          } else if (snapshot.hasError) {
            apiConnector.login();
            return Center(child: Text('Snapshot error: ${snapshot.error}'));
          } else {
            apiConnector.login();
            return Center(child: CircularProgressIndicator());
          }
        }
      },
    );
  }
}
