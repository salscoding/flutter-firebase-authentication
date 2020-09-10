import 'package:flutter/material.dart';
import 'package:loginexample/core/services/auth.dart';
import 'package:loginexample/view/screens/home_screen.dart';
import 'package:loginexample/view/screens/sign_in.dart';
import 'package:provider/provider.dart';

class AuthCheck extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthBase>(context);
    return StreamBuilder<User>(
        stream: auth.onAuthStateChanged,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            User user = snapshot.data;
            if (user == null) {
              return SignInScreen.create(context);
            }
            return HomeScreen();
          } else {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        });
  }
}
