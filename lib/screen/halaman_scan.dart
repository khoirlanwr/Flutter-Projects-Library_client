import 'dart:async';
import 'package:flutter/material.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:library_client/model/model_user_function.dart';
import 'package:library_client/screen/halaman_pinjam.dart';
import 'package:library_client/service/size_config.dart';

SizeConfig sizeConfig = new SizeConfig();

class ScanScreen extends StatefulWidget {

  final BaseUser user;

  ScanScreen({this.user});

  @override
  _ScanScreenState createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  
  String barcode = "";

  @override 
  void initState() {
    super.initState();

    widget.user.getCurrentUser().then((user) {
      print(user.data.nama);
    });
    
    // print('');
  }

  Widget topBar(BuildContext context) {
    return Padding (
        padding: EdgeInsets.only(
          top:sizeConfig.getBlockVertical(0),
          left:sizeConfig.getBlockHorizontal(4),         
          right:sizeConfig.getBlockHorizontal(2)),
        child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Text(
            "Scan your barcode.",
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: sizeConfig.getBlockHorizontal(5)),          
          ),
          Spacer(),
          CircleAvatar(
            backgroundImage: NetworkImage("https://i.pinimg.com/originals/7c/c7/a6/7cc7a630624d20f7797cb4c8e93c09c1.png"),
          )
        ],
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    sizeConfig.init(context);
    return Scaffold(
     backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Color(0xfff9f9f9),
        centerTitle: true,
        title: new Text("Library Client Apps", style: TextStyle(color: Colors.black87)),                  
      ),
      body: new Container(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            topBar(context),
            Padding(
              padding: EdgeInsets.all(0),
              child: Image.asset('images/character-illustration-people-with-creative.jpg', 
                width: sizeConfig.getBlockHorizontal(80), 
                height: sizeConfig.getBlockVertical(40)
              ),
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 1.0),
              child: 
                InkWell(
                  splashColor: Colors.indigoAccent,
                  borderRadius: BorderRadius.circular(10.0),
                  child: Container(                    
                    width: sizeConfig.getBlockHorizontal(80),
                    height: sizeConfig.getBlockVertical(7),
                    padding: EdgeInsets.symmetric(vertical: sizeConfig.getBlockVertical(0), horizontal: sizeConfig.getBlockHorizontal(20)),
                    decoration: BoxDecoration(
                      color: Colors.indigoAccent,
                      borderRadius: BorderRadius.circular(20)
                    ),
                    child: ListTile(
                      title: Text('Scan barcode', style: TextStyle(color: Colors.white, fontSize: sizeConfig.getBlockHorizontal(5))),                      
                    ),
                  ),
                  onTap: () {                    
                    scan();
                  },
                ) 
            ),
          ],
        ),
      )
    );
  }

  Future scan() async {
    barcode = await scanner.scan();
    barcode = '20a63f88bab718ef28ad6859fadfe4b9';
    Navigator.push(context, 
      MaterialPageRoute(builder: (context) => HalamanPinjam(bukuId: barcode, user: widget.user)));
  }

}