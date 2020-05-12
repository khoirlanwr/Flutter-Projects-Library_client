import 'package:library_client/model/model_user_function.dart';
import 'package:flutter/material.dart';
import 'package:library_client/screen/halaman_login.dart';
import 'package:library_client/screen/halaman_beranda.dart';

enum AuthState {
  NOT_DETERMINED,
  NOT_LOGGED_IN,
  LOGGED_IN
}

class HalamanRoot extends StatefulWidget {
  static const String id = "HALAMANROOT";

  HalamanRoot({this.user});
  final BaseUser user;

  @override
  _HalamanRootState createState() => _HalamanRootState();
}

class _HalamanRootState extends State<HalamanRoot>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  String userID = "";
  AuthState authState = AuthState.NOT_DETERMINED;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    widget.user.getCurrentUser().then((user) {
      setState(() {
        if (user != null) 
          userID = user.data.mhsId;
          
        if (userID.isEmpty) {
          authState = AuthState.NOT_LOGGED_IN;
          print('empty');
        }           
        else {
          authState = AuthState.LOGGED_IN;
          print('not empty');
        } 
          
      });
    });
  }  

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    switch (authState) {
      case AuthState.NOT_LOGGED_IN:
        print('not logged in'); 
        return new HalamanLogin(
          user: widget.user,
          loginCallback: loginCallback,
        );
        break;

      case AuthState.LOGGED_IN:
        if ((userID.length > 0) && (userID != null)) {
          return new HalamanBeranda(
            user: widget.user,
            logoutCallback: logoutCallback,
          );
        } else {
          return buildWaitingScreen();
        }
        break;

      case AuthState.NOT_DETERMINED:
        return buildWaitingScreen();
        break;

      default: 
        return buildWaitingScreen();
    }
  }


  void loginCallback() {
    widget.user.getCurrentUser().then((user){
      setState(() {
        userID = user.data.mhsId;
        authState = AuthState.LOGGED_IN;
      });
    });
  }

  void logoutCallback() {
    setState(() {
      authState = AuthState.NOT_LOGGED_IN;
      userID = "";  
    });
  }

  Widget buildWaitingScreen() {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator()
      ),
    );
  }


}
