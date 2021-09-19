import 'package:flutter/material.dart';
import 'package:humors/common/alert_dialog.dart';
import 'package:humors/services/api.dart';
import 'package:humors/services/auth.dart';
import 'package:provider/provider.dart';

import 'package:humors/services/models/api_user.dart';

class HomePage extends StatelessWidget {

  Future<void> _signOut(BuildContext context) async {
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      await auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    final didRequestSignOut = await showAlertDialog(
      context,
      title: 'Logout',
      content: 'Are you sure that you want to logout?',
      cancelActionText: 'Cancel',
      defaultActionText: 'Logout',
    );
    if (didRequestSignOut == true) {
      _signOut(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
        actions: <Widget>[
          FlatButton(
            child: Text(
              'Logout',
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.white,
              ),
            ),
            onPressed: () => _confirmSignOut(context),
          ),
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
              _signOut(context);
              return Center(child: Text('Null API User'));
            }
          } else if (snapshot.hasError) {
            _signOut(context);
            return Center(child: Text('Snapshot error: ${snapshot.error}'));
          } else {
            _signOut(context);
            return Center(child: Text('No data returned from the API'));
          }
        }
      },
    );
  }
}
