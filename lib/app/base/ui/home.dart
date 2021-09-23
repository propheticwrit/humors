import 'package:flutter/material.dart';
import 'package:humors/app/nav/menu.dart';
import 'package:humors/services/api.dart';
import 'package:provider/provider.dart';

import 'package:humors/services/models/api_user.dart';

class HomePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
        actions: <Widget>[
          Menu.buildMenu(context),
        ],
      ),
      body: _buildContents(context),
    );
  }

  Widget _buildContents(BuildContext context) {
    final apiConnector = Provider.of<Connector>(context, listen: false);

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
            return Center(child: Text('Snapshot error: ${snapshot.error}'));
          } else {
            return Center(child: Text('No data returned from the API'));
          }
        }
      },
    );
  }
}
