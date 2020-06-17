import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:library_client/model/model_user_function.dart';
import 'package:library_client/model/response_kategori.dart';
import 'package:library_client/model/response_list_kategori.dart';
import 'package:library_client/model/response_post.dart';
import 'package:library_client/service/api_service.dart';
import 'package:library_client/service/size_config.dart';
import 'package:library_client/screen/halaman_scan.dart';
import 'package:library_client/screen/halaman_tambah_edit.dart';
import 'package:library_client/screen/halaman_print.dart';
import 'package:library_client/screen/halaman_peminjaman_ongoing.dart';
import 'package:library_client/screen/halaman_riwayat_pinjam.dart';
import 'package:library_client/screen/halaman_tambah_edit_kategori.dart';


class DrawerItem {
  String title;
  DrawerItem(this.title); // constructur
}

class HalamanBeranda extends StatefulWidget {
  static const String id = "HALAMANBERANDA";

  HalamanBeranda({this.user, this.logoutCallback});

  final BaseUser user;
  final VoidCallback logoutCallback;

  _HalamanBerandaState createState() => new _HalamanBerandaState();
}

class _HalamanBerandaState extends State<HalamanBeranda> {

  // Edited 
  int _selectedDrawerIndex = 0;
  

  final SizeConfig sizeConfig = new SizeConfig();
  String searchQuery = "";
  String namaMhs = "";
  String alias = "";

  void logOut() {
    widget.user.signOut();
    widget.logoutCallback();
  }

  void getNamaMhs() {
    String namaTmp = "";
    widget.user.getCurrentUser().then((user) {
      setState((){

        namaTmp = user.data.nama;
        var splitted = namaTmp.split(" ");
        // print(namaMhs);

        namaMhs = splitted[0];    
        alias = _getSubsetString(namaMhs);
        // print(namaMhs);
      });
    });
  }

  @override
  void initState() {
    super.initState();

    _getKategoriBuku();    
    getNamaMhs();
    // ApiService.peminjamanOnGoing('2210171047');
  }

  Widget itemBuku(Record buku) {

    String namaBuku = buku.judul;
    String pengarang = buku.penulis;
    String penerbit = buku.penerbit;
    String kategori = buku.kategori;
    // String tahunTerbit = buku.tahun;

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
                      "Author: $pengarang | Penerbit: $penerbit",
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: sizeConfig.getBlockHorizontal(3)),
                    ),
                    Text(
                      "Kategori: $kategori",
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

  Widget itemBukuKategori(RecordKategori buku) {

    String namaBuku = buku.judul;
    String pengarang = buku.penulis;
    String penerbit = buku.penerbit;
    String kategori = buku.kategori;
    // String tahunTerbit = buku.tahun;

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
                      "Author: $pengarang | Penerbit: $penerbit",
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: sizeConfig.getBlockHorizontal(3)),
                    ),
                    Text(
                      "Kategori: $kategori",
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

  _getAllBooksOrSearch() {
    if (searchQuery.isNotEmpty) {
      print(searchQuery);
      return ApiService.searchBookByTitle(searchQuery, 1, 5);
    } else {
      return ApiService.getDataBuku(1, 2);
    }
  }

  Widget dataRecords() {
    return Center(
      child: Padding(
          padding: const EdgeInsets.all(0.0),
          child: FutureBuilder<List<Record>> (
            future: _getAllBooksOrSearch(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                print('waiting ..');
                return CircularProgressIndicator();
              } else {
                print('not waiting ..');
                List<Record> listBarang= [];
                List<Record> finalListBarang=[];

                listBarang = snapshot.data;                 
                finalListBarang = listBarang;

                return ListView.builder(
                  itemCount: finalListBarang?.length?? 0,
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

  Widget dataRecordsKategori(String kategori) {
    return Center(
      child: Padding(
          padding: const EdgeInsets.all(0.0),
          child: FutureBuilder<List<RecordKategori>> (
            future: ApiService.getDataBukuKategori(kategori, '', 1, 5),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                print('waiting ..');
                return CircularProgressIndicator();
              } else {
                print('not waiting ..');
                List<RecordKategori> listBarang= [];
                List<RecordKategori> finalListBarang=[];

                listBarang = snapshot.data;                 
                finalListBarang = listBarang;

                return ListView.builder(
                  itemCount: finalListBarang?.length?? 0 ,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      child: itemBukuKategori(finalListBarang[index]),
                      // onTap: null,
                      onTap: () {
                        Navigator.push(context, 
                        MaterialPageRoute(builder: (context) => HalamanTambahEditKategori(
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
          _selectedDrawerIndex = 0;
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

  Widget _simplePopup() => PopupMenuButton<int>(
    itemBuilder: (context) => [
      PopupMenuItem(
        value: 1,
        child: Text("On going"),        
      ),
      PopupMenuItem(
        value: 2,
        child: Text("Riwayat"),
      ),
      PopupMenuItem(
        value: 3,
        child: Text("Scan barcode"),        
      ),
      PopupMenuItem(
        value: 4,
        child: Text("Logout"),
      ),
    ],
    offset: Offset(10, 10),
    onSelected: (value) {
      print('$value');
      switch (value) {
        case 1:
            setState(() {
              Navigator.push(context,
                MaterialPageRoute(builder: (context) => HalamanPeminjamanOnGoing(user: widget.user)) 
              );            
            });          
          break;

        case 2:
            setState(() {
              Navigator.push(context,
                MaterialPageRoute(builder: (context) => HalamanRiwayatPeminjaman(user: widget.user)) 
              );            
            });          
          break;

        case 3:
            setState(() {
              Navigator.push(context,
                MaterialPageRoute(builder: (context) => ScanScreen(user: widget.user)) 
              );            
            });          
          break;

        case 4:
            setState(() {
              logOut();
            });          
          break;


        default:
      }
    },
  );

  Widget topBar(BuildContext context) {
    
    return Padding(
      padding: EdgeInsets.symmetric(vertical: sizeConfig.getBlockVertical(2), horizontal: sizeConfig.getBlockHorizontal(2)),
      child: Row(
      children: <Widget>[
        Text(          
          "Welcome, $namaMhs",
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: sizeConfig.getBlockHorizontal(5)),          
        ),
        Spacer(),
        CircleAvatar(
          backgroundImage: NetworkImage("https://i.pinimg.com/originals/7c/c7/a6/7cc7a630624d20f7797cb4c8e93c09c1.png"),
        ),
      ],
      ),
    );
  }

  Widget categoryBar(BuildContext context, int position) {

    String category = '';
    if (drawerCategories.length > 0 ) {
      category = drawerCategories[position].title;  
    } else category = 'Home';

    return Padding(
      padding: EdgeInsets.only(left: sizeConfig.getBlockHorizontal(3)),
        child: Row(
        mainAxisAlignment: MainAxisAlignment.start,  
        children: <Widget>[
          Icon(Icons.label, color: Colors.blueAccent),
          SizedBox(width: sizeConfig.getBlockHorizontal(2)),
          Expanded(
            child:Text(          
              "$category",
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: sizeConfig.getBlockHorizontal(4)),          
            ),
 
          )
        ],
      ),
    );
  }

  _getDrawerItemWidget(int position) {
    if (position == 0) 
      return Expanded(child: dataRecords());
    else {
      for (var i = 0; i < drawerCategories.length; i++) {   
        if ((position == i) && (position != 0)) {
          return Expanded(child: dataRecordsKategori(drawerCategories[i].title));
        }
      }
    }

  }

  _onSelectItem(int index) {
    setState(() => _selectedDrawerIndex = index);
    Navigator.of(context).pop();
  }

  List<DrawerItem> drawerCategories = [];
  _getKategoriBuku() async {
    List<Datum> records = await ApiService.listKategori();
    
    drawerCategories.add(
      new DrawerItem('Home')
    );

    records.forEach((value){
      drawerCategories.add(
        new DrawerItem(value.kategori)
      );
    });

    // print('drawerCategories.length ' + drawerCategories.length.toString());
  } 

  String _getSubsetString(String name) {
    return name.substring(0, 1);
  }

  @override
  Widget build(BuildContext context) 
  {  
    // Edited for drawer
    var drawerOptions = <Widget>[];
    drawerOptions.add(
      new ListTile(
        title: new Text('Home'),
        selected: 0 == _selectedDrawerIndex,
        onTap: () => _onSelectItem(0),
      )
    );

    for (var i = 1; i < drawerCategories.length; i++) {
      var d = drawerCategories[i];
      drawerOptions.add(
        new ListTile(
          title: new Text(d.title),
          selected: i == _selectedDrawerIndex,
          onTap: () => _onSelectItem(i),
        )
      );
    }

    // String alias = _getSubsetString(namaMhs);
    // String alias = 'A';

    sizeConfig.init(context);
    return Scaffold(
      backgroundColor: Color(0xfff9f9f9),
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Color(0xFF1E90FF),
        centerTitle: true,
        title: new Text("Library Client Apps", style: TextStyle(color: Colors.white)),
        actions: <Widget>[
          _simplePopup()
        ],
      ),
      drawer: new Drawer(        
        child: ListView(        
          padding: EdgeInsets.zero,
          children: <Widget>[
            Container(
              child: UserAccountsDrawerHeader(
                decoration: BoxDecoration(
                  color: Color(0xFF1E90FF)
                ),
                accountName: new Text("Kategori Buku", style: TextStyle(fontSize: sizeConfig.getBlockHorizontal(5))), 
                accountEmail: null,
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Text(alias, style: TextStyle(fontSize: sizeConfig.getBlockHorizontal(7))),
                ),
                ), 
            ),
            new Column(children: drawerOptions)
          ],
        ),
      ),
      // body: _getDrawerItemWidget(_selectedDrawerIndex),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: sizeConfig.getBlockHorizontal(2)),
        child: Column(
          children: <Widget>[
            topBar(context),
            SizedBox(height: sizeConfig.getBlockHorizontal(1)),
            searchBox(),
            SizedBox(height: sizeConfig.getBlockHorizontal(3)),            
            categoryBar(context, _selectedDrawerIndex),            
            _getDrawerItemWidget(_selectedDrawerIndex),                        
          ]
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent,
        child: Icon(Icons.print),
        onPressed: () {
          setState(() {
            Navigator.push(context,
              MaterialPageRoute(builder: (context) => HalamanPrint()) 
            );
          });
        },
      ),
    );
  }
}
