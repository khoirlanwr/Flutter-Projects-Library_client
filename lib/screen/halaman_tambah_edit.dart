import 'package:flutter/material.dart';
import 'package:library_client/model/model_user_function.dart';
import 'package:library_client/model/response_post.dart';
import 'package:library_client/service/size_config.dart';
import 'package:toast/toast.dart';
import 'package:library_client/model/model_cloud_firestore.dart';
import 'package:library_client/model/model_push_notification.dart';

class HalamanTambahEdit extends StatefulWidget {
  static const String id = "HALAMANTAMBAHEDIT";
  
  final Record record;
  final BaseUser user;

  HalamanTambahEdit({this.record, this.user});

  @override
  _HalamanTambahEditState createState() => _HalamanTambahEditState();
}

class _HalamanTambahEditState extends State<HalamanTambahEdit> {
  
  SizeConfig sizeConfig;
  Cloud cloud;
  Fcm fcm;

  String deviceToken;
  String namaMhs="";

  @override
  void initState() {
    super.initState();
    
    sizeConfig = new SizeConfig();
    cloud = new Cloud();
    fcm = new Fcm();

    getNamaMhs();

    deviceToken = fcm.getToken();
    fcm.configureListen();    
  }

  void getNamaMhs() {
    widget.user.getCurrentUser().then((user) {
      setState(() {
        namaMhs = user.data.nama;
      });
    });    
  }

  
  @override
  Widget build(BuildContext context) {
    sizeConfig.init(context);
    return Scaffold(
      backgroundColor: Color(0xfff9f9f9),
      appBar: appBar(),
      body: body(),
    );
  }

  Widget appBar() {
    return AppBar(
      elevation: 0.0,
      backgroundColor: Colors.indigoAccent,
      centerTitle: true,
      title: new Text("Library Client Apps", style: TextStyle(color: Colors.white)),      
    );
  }

  Widget body() {
    return Container(
      child: Column(
        children: <Widget>[
          Expanded(child:Stack(children: <Widget>[backgroundHeader(), summaryCash()])),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: sizeConfig.getBlockHorizontal(2)
              ),
              child: Column(
                children : <Widget>[
                  itemBuku(widget.record), buttonStore()
                ]
              )
            )
          ),
        ],
      ),
    );
  }



  Widget summaryCash() {
    return Positioned(
      top: sizeConfig.getBlockVertical(30),
      left: sizeConfig.getBlockHorizontal(10),
      right: sizeConfig.getBlockHorizontal(10),
      child: Container(
        width: sizeConfig.getBlockHorizontal(40),
        height: sizeConfig.getBlockVertical(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(sizeConfig.getBlockHorizontal(2)),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: sizeConfig.getBlockVertical(5)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Book Information",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.w300),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget backgroundHeader() {
    return Container(      
      width: double.infinity,
      height: sizeConfig.getBlockVertical(45),
      decoration: BoxDecoration(
        color: Colors.indigoAccent,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(0),
          bottomRight: Radius.circular(70),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: sizeConfig.getBlockVertical(1), horizontal: sizeConfig.getBlockHorizontal(2)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            topBar()
          ],
        )
      ),
    );
  }

  Widget itemBuku(Record buku) {

    String namaBuku = buku.nama;
    String pengarang = buku.pengarang;
    String penerbit = buku.penerbit;
    String tahunTerbit = buku.tahun;

    return Container(
      width: sizeConfig.getBlockHorizontal(80),
      height: sizeConfig.getBlockVertical(35),
      margin: EdgeInsets.symmetric(
        vertical: sizeConfig.getBlockVertical(1), 
        horizontal: sizeConfig.getBlockHorizontal(1)
      ),
      padding: EdgeInsets.symmetric(
        horizontal: sizeConfig.getBlockHorizontal(4),
        vertical: sizeConfig.getBlockVertical(4)
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(sizeConfig.getBlockHorizontal(1)),
        boxShadow: [
          BoxShadow(
              color: Colors.grey[300], blurRadius: 5.0, offset: Offset(0, 3))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(sizeConfig.getBlockHorizontal(5)),
                child: Image.asset(
                  "images/book-open-flat.png",
                  height: sizeConfig.getBlockVertical(10), //sizeConfig.getBlockVertical(10),
                  width: sizeConfig.getBlockHorizontal(15), //sizeConfig.getBlockHorizontal(10),
                ),
              ),
              SizedBox(width: sizeConfig.getBlockHorizontal(5)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget> [
                    Text(
                      "$namaBuku",
                      style: TextStyle(fontWeight: FontWeight.w800, fontSize: sizeConfig.getBlockHorizontal(4)),
                    ),
                    Text(
                      "Author: $pengarang | Tahun: $tahunTerbit",
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: sizeConfig.getBlockHorizontal(3)),
                    ),
                    Text(
                      "Penerbit: $penerbit",
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: sizeConfig.getBlockHorizontal(3)),
                    ),
                  ]
                )
              )
            ],
          )
        ],
      )
    );
  }


  Widget topBar() {
    return Padding (
      padding: EdgeInsets.only(
        top:sizeConfig.getBlockVertical(0),
        left:sizeConfig.getBlockHorizontal(4),         
        right:sizeConfig.getBlockHorizontal(2)
      ),
      child: Row(      
        children: <Widget>[
          Text(
            "Interested to this book?",
            style: TextStyle(
              fontWeight: FontWeight.w600, 
              fontSize: sizeConfig.getBlockHorizontal(5),
              color: Colors.white)
          ),
          Spacer(),
          IconButton(
            icon: Icon(Icons.search, color: Colors.white), 
            onPressed: null
          ),
          CircleAvatar(
            backgroundImage: NetworkImage("https://i.pinimg.com/originals/7c/c7/a6/7cc7a630624d20f7797cb4c8e93c09c1.png"),
          )
        ],
      )
    );
  }  

  Widget buttonStore() {
    return Container(
      width: sizeConfig.getBlockHorizontal(80),
      height: sizeConfig.getBlockVertical(7),
      margin: EdgeInsets.symmetric(
        vertical: sizeConfig.getBlockVertical(1), 
        horizontal: sizeConfig.getBlockHorizontal(1)
      ),
      padding: EdgeInsets.symmetric(
        horizontal: sizeConfig.getBlockHorizontal(0),
        vertical: sizeConfig.getBlockVertical(0)
      ),
      decoration: BoxDecoration(
        color: Colors.grey[80],
        borderRadius: BorderRadius.circular(sizeConfig.getBlockHorizontal(1)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              inkWellBtnPinjam(),
              Spacer(),
              inkWellBtnRefresh()
            ],
          )
        ],
      ),
    );
  }


  Widget inkWellBtnPinjam() {
    return InkWell(
      splashColor: Colors.indigo,
      borderRadius: BorderRadius.circular(sizeConfig.getBlockHorizontal(3)),
      child: Container(
        width: sizeConfig.getBlockHorizontal(59),
        height: sizeConfig.getBlockVertical(7),
        decoration: BoxDecoration(
          color: Colors.indigoAccent,
          borderRadius: BorderRadius.circular(sizeConfig.getBlockHorizontal(2))
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: sizeConfig.getBlockHorizontal(2)
          ),
          child: ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.save, color: Colors.white),
                SizedBox(width: sizeConfig.getBlockHorizontal(2)),
                Text("Pinjam buku", style: TextStyle(fontWeight: FontWeight.w400, color: Colors.white))
              ],
            )
          ),
        )
      ),
      onTap: () {
        storeToCloud();        
      },
    );
  }

  Widget inkWellBtnRefresh() {
    return InkWell(
      splashColor: Colors.indigo,
      borderRadius: BorderRadius.circular(sizeConfig.getBlockHorizontal(2)),
      child: Container(
        width: sizeConfig.getBlockHorizontal(20),
        height: sizeConfig.getBlockVertical(7),
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(sizeConfig.getBlockHorizontal(2))
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: sizeConfig.getBlockHorizontal(1)
          ),
          child: ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(width: sizeConfig.getBlockHorizontal(2)),
                Icon(Icons.refresh, color: Colors.white),
                SizedBox(width: sizeConfig.getBlockHorizontal(2)),
              ],
            )
          ),
        )
      ),
      onTap: () {
        cekUserExists();
      },
    );
  }

  void cekUserExists() async {
    // final         await user.getDataUsers();
    // final users = await user.getDataUsers();
    // bool isExist = user.isExist('Khoirul Anwar', '12345678');
    // print(isExist);
  }

  void storeToCloud() async {
    deviceToken = await fcm.getToken();
    if (deviceToken.isNotEmpty) {
      cloud.storeToCloud(widget.record.bukuId, widget.record.nama, namaMhs, deviceToken);
      Navigator.pop(context);      
      // Navigator.pushNamedAndRemoveUntil(context, HalamanBeranda.id, (Route<dynamic> route) => false);
      setState(() {
        Toast.show('Berhasil', context);
      });
    } else {
      print('Gagal, token kosong');
      // setState(() {
      //   Toast.show('Gagal, token kosong', context);
      // });          
    }
  }


  Widget animationPerson() {
    return Positioned(
      top: sizeConfig.getBlockVertical(3),
      left: sizeConfig.getBlockHorizontal(0),
      right: sizeConfig.getBlockHorizontal(5),
      child: Container(
        margin: EdgeInsets.all(sizeConfig.getBlockHorizontal(1)),
        child: Center(
          child: Image.asset('images/transparent/book.png', width: sizeConfig.getBlockHorizontal(30), height: sizeConfig.getBlockVertical(40))
        ),
      )
    );
  }

}
