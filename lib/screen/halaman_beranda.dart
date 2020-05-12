import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:library_client/model/model_user_function.dart';
import 'package:library_client/model/response_post.dart';
import 'package:library_client/service/api_service.dart';
import 'package:library_client/service/size_config.dart';
import 'package:library_client/screen/halaman_scan.dart';
import 'package:library_client/screen/halaman_tambah_edit.dart';
import 'package:library_client/screen/halaman_print.dart';

class HalamanBeranda extends StatefulWidget {
  static const String id = "HALAMANBERANDA";

  HalamanBeranda({this.user, this.logoutCallback});

  final BaseUser user;
  final VoidCallback logoutCallback;

  _HalamanBerandaState createState() => new _HalamanBerandaState();
}

class _HalamanBerandaState extends State<HalamanBeranda> {
  
  final SizeConfig sizeConfig = new SizeConfig();
  String searchQuery = "";
  String namaMhs = "";

  void logOut() {
    widget.user.signOut();
    widget.logoutCallback();
  }

  String getNamaMhs() {
    widget.user.getCurrentUser().then((user) {
      setState((){
        namaMhs = user.data.nama;
        print(namaMhs);    
      });
    });

    return namaMhs;
  }

  @override
  void initState() {
    super.initState();
    namaMhs = getNamaMhs();
  }

  Widget itemBuku(Record buku) {

    String namaBuku = buku.nama;
    String pengarang = buku.pengarang;
    String penerbit = buku.penerbit;
    String tahunTerbit = buku.tahun;

    return Container(
      margin: EdgeInsets.symmetric(
        vertical: sizeConfig.getBlockVertical(1), 
        horizontal: sizeConfig.getBlockHorizontal(1)
      ),
      padding: EdgeInsets.all(sizeConfig.getBlockHorizontal(3)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(sizeConfig.getBlockHorizontal(5)),
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

  Widget dataRecords() {
    return Center(
      child: Padding(
          padding: const EdgeInsets.all(0.0),
          child: FutureBuilder<List<Record>>(
            future: ApiService.getDataBuku(1, 2),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                print('waiting ..');
                return CircularProgressIndicator();
              } else {
                print('not waiting ..');
                List<Record> listBarang= [];
                List<Record> finalListBarang=[];

                listBarang = snapshot.data;                 

                if (searchQuery.isNotEmpty) {
                  for (var index=0; index<listBarang.length; index++) {
                    var namabuku = listBarang[index].nama;
                    bool ok = false;

                    // 1. split berdasarkan banyak spasi
                    var newQuery = searchQuery.split(" ");
                    print(newQuery.length);

                    // ubah setiap karakter pertama menjadi kapital
                    for(var i=0; i<newQuery.length; i++) {
                      var str = newQuery[i], strLow;
                      str = str[0].toUpperCase() + str.substring(1);
                      strLow = str[0].toLowerCase() + str.substring(1);  

                      if ((namabuku.contains(str) || namabuku.contains(strLow)) && ok == false) {
                        finalListBarang.add(listBarang[index]);
                        ok = true;
                      }                      
                    }
                  }                  
                } else {
                  for(var index=0; index<listBarang.length; index++){
                    finalListBarang.add(listBarang[index]);
                  }
                }

                return ListView.builder(
                  itemCount: finalListBarang?.length?? 0 ,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      child: itemBuku(finalListBarang[index]),
                      onTap: () {
                        Navigator.push(context, 
                        MaterialPageRoute(builder: (context) => HalamanTambahEdit(
                          record: finalListBarang[index], user: widget.user,
                        )));
                      },
                    );
                  }
                );
              }
            },
          )
        )
      );    
  }

  Widget searchBox() {
    return TextField(
        onChanged: (value) {
          searchQuery = value;
        },
        decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          border: InputBorder.none,
          prefixIcon: Icon(Icons.search),
          hintText: "Looking for a book? search here!",
        ),
      );
  }

  Widget topBar(BuildContext context) {
    return Row(
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.exit_to_app, color: Colors.blueGrey), 
          onPressed: logOut,
        ),
        Text(          
          "Welcome, $namaMhs",
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: sizeConfig.getBlockHorizontal(5)),          
        ),
        Spacer(),
        IconButton(
          icon: Icon(Icons.search, color: Colors.blueGrey), 
          onPressed: () {
            Navigator.push(context,
              MaterialPageRoute(builder: (context) => ScanScreen(user: widget.user)) 
            );            
          }
        ),
        CircleAvatar(
          backgroundImage: NetworkImage("https://i.pinimg.com/originals/7c/c7/a6/7cc7a630624d20f7797cb4c8e93c09c1.png"),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    sizeConfig.init(context);
    return Scaffold(
      backgroundColor: Color(0xfff9f9f9),
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Color(0xfff9f9f9),
        centerTitle: true,
        title: new Text("Library Client Apps", style: TextStyle(color: Colors.black87)),                  
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: sizeConfig.getBlockHorizontal(2)),
        child: Column(
          children: <Widget>[
            topBar(context),
            SizedBox(height: sizeConfig.getBlockHorizontal(5)),            
            searchBox(),
            SizedBox(height: sizeConfig.getBlockHorizontal(3)),
            Expanded(child:dataRecords())
          ]
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.indigoAccent,
        child: Icon(Icons.print),
        onPressed: () {
          setState(() {
            Navigator.push(context,
              MaterialPageRoute(builder: (context) => HalamanPrint()) 
            );            
            // print('refreshed');
          });
        },
      ),
    );
  }
}
