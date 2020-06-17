import 'package:firebase_messaging/firebase_messaging.dart';

class Fcm {

  final FirebaseMessaging _fcm = new FirebaseMessaging();
  String _deviceToken="";
  static int _i=0;

  String getToken() {
    _fcm.getToken().then((token) => {
      _deviceToken = token,
      print('token: $token')
    });    
    return _deviceToken;
  }

  void configureListen() {
    _fcm.configure(
      onMessage: (Map<String, dynamic>message) async {
        // simpan data yang kedua
        if (_i%2 == 0) {
          print('title: $message');
          // Alert(context: context, title: "RFLUTTER", desc: "Flutter is awesome.").show();       
        }
        _i++;
      },
      onResume: (Map<String, dynamic> message) async {
        print('onResume: $message');
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('onLaunch: $message');
      }      
    );    
  }



}