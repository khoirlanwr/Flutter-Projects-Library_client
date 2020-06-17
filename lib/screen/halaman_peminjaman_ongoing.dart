import 'package:flutter/material.dart';
import 'package:library_client/model/response_peminjaman_ongoing.dart';
import 'package:library_client/service/api_service.dart';
import 'package:library_client/service/size_config.dart';
import 'package:library_client/model/model_user_function.dart';

class HalamanPeminjamanOnGoing extends StatefulWidget {
  static const String id = "HALAMANPEMINJAMANONGOING";
  final BaseUser user;

  HalamanPeminjamanOnGoing({this.user});

  @override
  _HalamanPeminjamanOnGoingState createState() => _HalamanPeminjamanOnGoingState();
}

class _HalamanPeminjamanOnGoingState extends State<HalamanPeminjamanOnGoing> {

  SizeConfig sizeConfig;
  String idMahasiswa = "";

  @override
  void initState() {
    super.initState();
    _getIdentity();

    sizeConfig = new SizeConfig();
  }

  _getIdentity() async {
    await widget.user.getCurrentUser().then((value) {
      setState(() {        
        idMahasiswa = value.data.mhsId;      
      });
    });    
  }

  Widget topBar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0, horizontal: sizeConfig.getBlockHorizontal(2)),
      child: Row(
        children: <Widget>[
          Text(          
            "Peminjaman On-Going",
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: sizeConfig.getBlockHorizontal(5)),          
          ),
          Spacer(),
          CircleAvatar(
            backgroundImage: NetworkImage("https://i.pinimg.com/originals/7c/c7/a6/7cc7a630624d20f7797cb4c8e93c09c1.png"),
          )
        ],
      ),
    );
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
      backgroundColor: Color(0xFF1E90FF),
      centerTitle: true,
      title: new Text("Library Client Apps", style: TextStyle(color: Colors.white)),      
    );
  }

  Widget body() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: sizeConfig.getBlockHorizontal(2)),      
      child: Column(
        children: <Widget>[
          SizedBox(height: sizeConfig.getBlockHorizontal(5)),          
          topBar(context),
          SizedBox(height: sizeConfig.getBlockHorizontal(5)),
          Expanded(child: dataRecords()),
        ],
      ),
    );
  }


  Widget dataRecords() {

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(0.0),
        child: FutureBuilder<List<RecordOnGoing>>(
          future: ApiService.peminjamanOnGoing(idMahasiswa),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              print('waiting data record future builder peminjaman on going');
              return CircularProgressIndicator();
            } else {
              print('completed data record future builder peminjaman on going');

              // siapkan variable penampung
              List<RecordOnGoing> listPeminjamanOnGoing = [];

              // assign hasil future query ke list records
              listPeminjamanOnGoing = snapshot.data;
              // print(listPeminjamanOnGoing.length);

              return ListView.builder(
                itemCount: listPeminjamanOnGoing?.length ?? 0,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    child: item(listPeminjamanOnGoing[index]),
                    onTap: null,
                  );
                }
              );

            }
          },
        ),
      ),
    );
  }

  Widget item(RecordOnGoing object) {

    String tanggalPeminjaman = object.dataPeminjaman.tanggalPeminjaman.toString();
    tanggalPeminjaman = tanggalPeminjaman.substring(0, 16);

    var tanggalPengembalianDay = object.dataPeminjaman.tanggalPengembalian.day;
    var tanggalPengembalianMonth = object.dataPeminjaman.tanggalPengembalian.month;
    
    var now = new DateTime.now();
    var nowDay = now.day;
    var nowMonth = now.month;

    String estimasiDay = "";
    if (tanggalPengembalianMonth >= nowMonth) {
      
      if (tanggalPengembalianDay > nowDay) {
        print(tanggalPengembalianDay - nowDay);
        estimasiDay = (tanggalPengembalianDay - nowDay).toString();
        estimasiDay = estimasiDay + " days left";
      } else if (tanggalPengembalianDay < nowDay) {
        
        if (tanggalPengembalianMonth > nowMonth) {
          var a = (30 - nowDay.toInt()) + tanggalPengembalianDay.toInt();
          estimasiDay = a.toString() + " days left";

        } else if(tanggalPengembalianMonth == nowMonth) {
          var late = (nowDay.toInt() - tanggalPengembalianDay.toInt());
          estimasiDay = "late $late days";
        }

      }                
    } 

    // Duration difference = now.difference(tanggalPengembalian);
    // print(tanggalPengembalian);
    // print(now);

    String judulBuku = object.detailBuku.judul;
  
    return Card(
      margin: EdgeInsets.only(top: 15, left: 15, right: 15),
      elevation: 8,
      child: ListTile(
        leading: Icon(
          Icons.subdirectory_arrow_right,
          color: Colors.lightGreen,
        ),
        title: Text(
          '$judulBuku',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('Tanggal pinjam: $tanggalPeminjaman'),
        trailing: Text(
          "$estimasiDay",
          style: TextStyle(color:Colors.orangeAccent),
        ),
      ),
    );
  }

  Widget itemBuku(RecordOnGoing buku) {

    String namaBuku = buku.detailBuku.judul;
    String pengarang = buku.detailBuku.penulis;
    String penerbit = buku.detailBuku.penerbit;
    String kategori = buku.detailBuku.kategori;

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

}