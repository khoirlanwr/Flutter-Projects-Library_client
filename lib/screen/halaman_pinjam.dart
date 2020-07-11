import 'package:flutter/material.dart';
import 'package:library_client/model/model_user_function.dart';
import 'package:library_client/model/response_get_data_id.dart';
import 'package:library_client/model/response_peminjaman_ongoing.dart';
import 'package:library_client/service/api_service.dart';
import 'package:library_client/service/size_config.dart';
import 'package:library_client/model/model_push_notification.dart';
import 'package:library_client/model/model_cloud_firestore.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:library_client/screen/halaman_print.dart';

class HalamanPinjam extends StatefulWidget {
  static const String id = "HALAMANPINJAM";

  // class ini menerima parameter idBuku
  final String bukuId;
  final BaseUser user;

  HalamanPinjam({this.bukuId, this.user});

  @override
  _HalamanPinjamState createState() => _HalamanPinjamState();


}

class _HalamanPinjamState extends State<HalamanPinjam> {

  ApiService apiService;
  ResponseGetDataId responseGetDataId;
  SizeConfig sizeConfig;
  Fcm pushNotif;
  Cloud cloud;

  String devicetoken = "";
  String namaMhs = "";
  String idMhs = "";

  static int prevLength = 0;
  List<RecordOnGoing> listPeminjamanOnGoing = [];
  

  @override
  void initState() {
    super.initState();

    apiService = new ApiService();
    responseGetDataId = new ResponseGetDataId();
    sizeConfig = new SizeConfig();    
    pushNotif = new Fcm();
    cloud = new Cloud();

    // dari bukuId ambil data data lainnya.
    takeGood();
    // get token
    devicetoken = pushNotif.getToken();
    // initial listen config
    pushNotif.configureListen();
    getNamaMhs();

    // getPeminjamanBerlangsung();
  }

  void takeGood() async {
    responseGetDataId = await apiService.getDataById(widget.bukuId);
  }

  void getNamaMhs() {
    widget.user.getCurrentUser().then((user) {
      setState(() {
        namaMhs = user.data.nama;
        idMhs = user.data.mhsId;
      });
    });
  }

  Widget dataRecords() {

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(0.0),
        child: FutureBuilder<List<RecordOnGoing>>(
          future: ApiService.peminjamanOnGoing(idMhs),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              print('waiting data record future builder peminjaman on going');
              return Container(
                height: 0,
                width: 0,
              );

            } else {
              print('completed data record future builder peminjaman on going');

              // siapkan variable penampung
              // List<RecordOnGoing> listPeminjamanOnGoing = [];
              if (snapshot.data == null) {

              } else {
                // assign hasil future query ke list records
                listPeminjamanOnGoing = snapshot.data;
              }

              print(listPeminjamanOnGoing.length);

              return Container(
                height: 0,
                width: 0,
              );
            }
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    sizeConfig.init(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Color(0xFF1E90FF),
        centerTitle: true,
        title: new Text("Library Client Apps", style: TextStyle(color: Colors.white)),                  
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(child: Stack(children: <Widget>[backgroundHeader(), recordBuku()])),        
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: sizeConfig.getBlockHorizontal(2)),
                child: Column(
                children : <Widget>[
                    itemBuku(), buttonStore()
                  ]
                ),
              )
            ),
            dataRecords()
            // detailBuku() 
          ],
        ),
      ),
    );
  }

  Widget backgroundHeader() {
    return Container(      
      width: double.infinity,
      height: sizeConfig.getBlockVertical(45),
      decoration: BoxDecoration(
        color: Color(0xFF1E90FF),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(0),
          bottomRight: Radius.circular(70),
        ),
      ),
    );
  }

  Widget recordBuku() {

    String bahasa = responseGetDataId.data.bahasa;
    String letakBuku = responseGetDataId.data.lokasi;
    String tahunBuku = responseGetDataId.data.tahunTerbit;

    return Positioned(
      top: sizeConfig.getBlockVertical(10),
      left: sizeConfig.getBlockHorizontal(10),
      right: sizeConfig.getBlockHorizontal(10),
      child: Container(
        width: sizeConfig.getBlockHorizontal(40),
        height: sizeConfig.getBlockVertical(40),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(sizeConfig.getBlockHorizontal(2)),
        ),
        child: FutureBuilder<ResponseGetDataId>(
          future: apiService.getDataById(widget.bukuId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(
                width: sizeConfig.getBlockHorizontal(0),
                height: sizeConfig.getBlockVertical(0),
              );
            } else {
              return Padding(
                padding: EdgeInsets.symmetric(
                  vertical: sizeConfig.getBlockVertical(2),
                  horizontal: sizeConfig.getBlockHorizontal(5)
                ),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(sizeConfig.getBlockHorizontal(5)),
                          child: Image.asset(
                            "images/cover2.png",
                            height: sizeConfig.getBlockVertical(10), 
                            width: sizeConfig.getBlockHorizontal(13), 
                          ),
                        ),
                        SizedBox(width: sizeConfig.getBlockHorizontal(5)),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget> [
                              Text(responseGetDataId.data.judul,
                                style: TextStyle(fontWeight: FontWeight.w600, fontSize: sizeConfig.getBlockHorizontal(4)),
                              ),
                              Divider()
                            ]
                          )
                        )
                      ],
                    ),
                    Divider(color: Colors.white, height: sizeConfig.getBlockVertical(1)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Expanded(
                          child:  Column(
                            children: <Widget>[                  
                              Text('$bahasa', style: TextStyle(color: Colors.black, fontSize: sizeConfig.getBlockHorizontal(3), fontWeight: FontWeight.bold)),
                              Divider(color: Colors.white, height: sizeConfig.getBlockVertical(1)),
                              Text('Bahasa', style: TextStyle(color: Colors.black, fontSize: sizeConfig.getBlockHorizontal(3), fontWeight: FontWeight.w400))
                            ],
                          ),
                        ),
                        SizedBox(width: sizeConfig.getBlockHorizontal(5)),
                        Expanded(
                          child:  Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[                  
                              Text("$tahunBuku", style: TextStyle(color: Colors.black, fontSize: sizeConfig.getBlockHorizontal(3), fontWeight: FontWeight.bold)),
                              Divider(color: Colors.white, height: sizeConfig.getBlockVertical(1)),
                              Text('Tahun', style: TextStyle(color: Colors.black, fontSize: sizeConfig.getBlockHorizontal(3), fontWeight: FontWeight.w400))
                            ],
                          ),
                        ),
                        Expanded(
                          child:  Column(
                            children: <Widget>[                  
                              Text('$letakBuku', style: TextStyle(color: Colors.black, fontSize: sizeConfig.getBlockHorizontal(3), fontWeight: FontWeight.bold)),
                              Divider(color: Colors.white, height: sizeConfig.getBlockVertical(1)),
                              Text('Letak', style: TextStyle(color: Colors.black, fontSize: sizeConfig.getBlockHorizontal(3), fontWeight: FontWeight.w400))
                            ],
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: sizeConfig.getBlockVertical(2), bottom: sizeConfig.getBlockVertical(1)),
                      child: Column(              
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget> [
                              Icon(Icons.account_circle, color: Colors.blue),
                              SizedBox(width: sizeConfig.getBlockHorizontal(2)),
                              Expanded(child: Text(responseGetDataId.data.pengarang, style: TextStyle(fontWeight: FontWeight.w400, fontSize: sizeConfig.getBlockHorizontal(3))))
                            ]
                          ),
                          Divider(color: Colors.white, height: sizeConfig.getBlockVertical(1)),
                          Row(                  
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget> [
                              Icon(Icons.account_balance, color: Colors.green),
                              SizedBox(width: sizeConfig.getBlockHorizontal(2)),
                              Expanded(child: Text(responseGetDataId.data.penerbit, style: TextStyle(fontWeight: FontWeight.w400, fontSize: sizeConfig.getBlockHorizontal(3))))
                            ]
                          ),
                          Divider(color: Colors.white, height: sizeConfig.getBlockVertical(1)),
                          Row(                  
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget> [
                              Icon(Icons.label, color: Colors.orange),
                              SizedBox(width: sizeConfig.getBlockHorizontal(2)),
                              Expanded(child: Text(responseGetDataId.data.kategori, style: TextStyle(fontWeight: FontWeight.w400, fontSize: sizeConfig.getBlockHorizontal(3))))
                            ]
                          )

                        ],
                      ),
                    ),

                  ],
                ),
              );
            }
          }
        ),
      ),
    );
  }

  Widget itemBuku() {

    String deskripsi = responseGetDataId.data.deskripsi;
    String edisi = responseGetDataId.data.edisi;
    String kotaTerbit = responseGetDataId.data.kotaTerbit;
    String isbn = responseGetDataId.data.isbn; 
    String noInventaris = responseGetDataId.data.bukuId;
    String umumres = responseGetDataId.data.umumRes;
    var stok = responseGetDataId.data.stok;

    return Container(
      width: sizeConfig.getBlockHorizontal(80),
      height: sizeConfig.getBlockVertical(35),
      margin: EdgeInsets.symmetric(
        vertical: sizeConfig.getBlockVertical(1), 
        horizontal: sizeConfig.getBlockHorizontal(1)
      ),
      padding: EdgeInsets.only(
        left: sizeConfig.getBlockHorizontal(4),
        right: sizeConfig.getBlockHorizontal(4),
        bottom: sizeConfig.getBlockVertical(3)
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
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: sizeConfig.getBlockVertical(2), bottom: sizeConfig.getBlockVertical(1)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,              
              children: <Widget>[
                Text("Deskripsi buku: ", style: TextStyle(fontSize: sizeConfig.getBlockHorizontal(4))),
                Text("$deskripsi", style: TextStyle(fontSize: sizeConfig.getBlockHorizontal(4))),

                Divider(color: Colors.white, height: sizeConfig.getBlockVertical(1)),
                Divider(color: Colors.white, height: sizeConfig.getBlockVertical(1)),
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget> [
                    // Icon(Icons.account_circle, color: Colors.blue),
                    Text("No inventaris: ", style: TextStyle(fontSize: sizeConfig.getBlockHorizontal(4))),
                    SizedBox(width: sizeConfig.getBlockHorizontal(2)),
                    Expanded(child: Text("$noInventaris", style: TextStyle(fontWeight: FontWeight.w400, fontSize: sizeConfig.getBlockHorizontal(4))))
                  ]
                ),
                Divider(color: Colors.white, height: sizeConfig.getBlockVertical(1)),
                Row(                  
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget> [
                    // Icon(Icons.account_balance, color: Colors.green),
                    Text("Edisi: ", style: TextStyle(fontSize: sizeConfig.getBlockHorizontal(4))),
                    SizedBox(width: sizeConfig.getBlockHorizontal(2)),
                    Expanded(child: Text("$edisi", style: TextStyle(fontWeight: FontWeight.w400, fontSize: sizeConfig.getBlockHorizontal(4))))
                  ]
                ),
                Divider(color: Colors.white, height: sizeConfig.getBlockVertical(1)),
                Row(                  
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget> [
                    Text("Kota terbit: ", style: TextStyle(fontSize: sizeConfig.getBlockHorizontal(4))),
                    SizedBox(width: sizeConfig.getBlockHorizontal(2)),
                    Expanded(child: Text("$kotaTerbit", style: TextStyle(fontWeight: FontWeight.w400, fontSize: sizeConfig.getBlockHorizontal(4))))
                  ]
                ),
                Divider(color: Colors.white, height: sizeConfig.getBlockVertical(1)),
                Row(                  
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget> [
                    // Icon(Icons.label, color: Colors.orange),
                    Text("ISBN: ", style: TextStyle(fontSize: sizeConfig.getBlockHorizontal(4))),
                    SizedBox(width: sizeConfig.getBlockHorizontal(2)),
                    Expanded(child: Text("$isbn", style: TextStyle(fontWeight: FontWeight.w400, fontSize: sizeConfig.getBlockHorizontal(4))))
                  ]
                ),
                Divider(color: Colors.white, height: sizeConfig.getBlockVertical(1)),
                Row(                  
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget> [
                    // Icon(Icons.label, color: Colors.orange),
                    Text("Umum/res: ", style: TextStyle(fontSize: sizeConfig.getBlockHorizontal(4))),
                    SizedBox(width: sizeConfig.getBlockHorizontal(2)),
                    Expanded(child: Text("$umumres", style: TextStyle(fontWeight: FontWeight.w400, fontSize: sizeConfig.getBlockHorizontal(4))))
                  ]
                ),
                Divider(color: Colors.white, height: sizeConfig.getBlockVertical(1)),
                Row(                  
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget> [
                    // Icon(Icons.label, color: Colors.orange),
                    Text("Status: ", style: TextStyle(fontSize: sizeConfig.getBlockHorizontal(4))),
                    SizedBox(width: sizeConfig.getBlockHorizontal(2)),
                    Expanded(child: Text("$stok", style: TextStyle(fontWeight: FontWeight.w400, fontSize: sizeConfig.getBlockHorizontal(4))))
                  ]
                )

                // Text("Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged.", style: TextStyle(color: Colors.black, fontSize: sizeConfig.getBlockHorizontal(3), fontWeight: FontWeight.w400)),
                // Text("Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old. Richard McClintock, a Latin professor at Hampden-Sydney College in Virginia, looked", style: TextStyle(color: Colors.black, fontSize: sizeConfig.getBlockHorizontal(3), fontWeight: FontWeight.w400))

                // Text("Summary", style: TextStyle(fontSize: sizeConfig.getBlockHorizontal(4))),
                // Text("Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged.", style: TextStyle(color: Colors.black, fontSize: sizeConfig.getBlockHorizontal(3), fontWeight: FontWeight.w400)),
                // Text("Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old. Richard McClintock, a Latin professor at Hampden-Sydney College in Virginia, looked", style: TextStyle(color: Colors.black, fontSize: sizeConfig.getBlockHorizontal(3), fontWeight: FontWeight.w400))
              ],
            ),
          ),
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


  Widget topBar() {
    return Padding (
      padding: EdgeInsets.only(
          top:sizeConfig.getBlockVertical(0),
          left:sizeConfig.getBlockHorizontal(4),         
          right:sizeConfig.getBlockHorizontal(2)
      ),
    child: Row(children: <Widget>[])
    );
  }

  Widget textDesc(String text, int blockWidth, TextAlign align, double fontSize) {
    return new Container(
    padding: const EdgeInsets.all(16.0),
      width: sizeConfig.getBlockHorizontal(blockWidth),
      child: new Column (
        children: <Widget>[
          new Text (text, textAlign: align, style: TextStyle(fontSize: fontSize),),
        ],
      ),
    );
  }  

  Widget inkWellBtnRefresh() {
    return InkWell(
      splashColor: Color(0xFF1E90FF),
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
              crossAxisAlignment: CrossAxisAlignment.center,
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
        setState(() {});
        
      },
    );
  }

  Widget inkWellBtnPinjam() {
    return InkWell(
      splashColor: Color(0xFF1E90FF),
      borderRadius: BorderRadius.circular(sizeConfig.getBlockHorizontal(3)),
      child: Container(
        width: sizeConfig.getBlockHorizontal(59),
        height: sizeConfig.getBlockVertical(7),
        decoration: BoxDecoration(
          color: Color(0xFF1E90FF),
          borderRadius: BorderRadius.circular(sizeConfig.getBlockHorizontal(2))
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: sizeConfig.getBlockHorizontal(2)
          ),
          child: ListTile(
            title: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
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
        print('panjang list peminjaman on going: ');
        print(listPeminjamanOnGoing.length);
        
        var stokBuku = responseGetDataId.data.stok;
        String namaBuku = responseGetDataId.data.judul;
        
        // cek kondisi 
        if (stokBuku <= 0) {
          // gagal pinjam karena stok kosong
          Alert(
            context: context,
            type: AlertType.error,
            title: "Status",
            desc: "Stok buku $namaBuku kosong!",
            buttons: [
              DialogButton(
                child: Text(
                  "Confirm",
                  style: TextStyle(color: Colors.white, fontSize: sizeConfig.getBlockHorizontal(4)),
                ),
                onPressed: () => Navigator.pop(context),
                width: sizeConfig.getBlockHorizontal(20),
              )
            ],
          ).show();

        } else if (listPeminjamanOnGoing.length >= 2) {
          // gagal pinjam karena masih ada 2 buku yang belum dikembalikan
          Alert(
            context: context,
            type: AlertType.error,
            title: "Status",
            desc: "Masih ada 2 buku yang belum dikembalikan!",
            buttons: [
              DialogButton(
                child: Text(
                  "Confirm",
                  style: TextStyle(color: Colors.white, fontSize: sizeConfig.getBlockHorizontal(4)),
                ),
                onPressed: () => Navigator.pop(context),
                width: sizeConfig.getBlockHorizontal(20),
              )
            ],
          ).show();

        } else {
          // lanjutkan proses peminjaman

          // simpan ke mariadb
          ApiService.postPeminjamanBuku(widget.bukuId, idMhs);

          // simpan ke firestore 
          cloud.storeToCloud(
            widget.bukuId,
            idMhs,          
            responseGetDataId.data.judul,
            namaMhs,
            pushNotif.getToken()
          );

          // konfirmasi cetak struk peminjaman
          Alert(
              context: context,
              type: AlertType.success,
              title: "Status",
              desc: "Buku $namaBuku berhasil dipinjam",
              buttons: [
                DialogButton(
                  child: Text(
                    "Confirm",
                    style: TextStyle(color: Colors.white, fontSize: sizeConfig.getBlockHorizontal(4)),
                  ),
                  onPressed: () => Navigator.push(context, 
                    MaterialPageRoute(builder: (context) => HalamanPrint(idUser: idMhs, namaMhs: namaMhs, judulBuku: namaBuku))),
                  width: sizeConfig.getBlockHorizontal(20),
                )
              ],
            ).show();


        }

        // simpan ke mariadb
        // ApiService.postPeminjamanBuku(widget.bukuId, idMhs);

        // simpan ke firestore
        // cloud.storeToCloud(
        //   widget.bukuId,
        //   idMhs,          
        //   responseGetDataId.data.judul,
        //   namaMhs,
        //   pushNotif.getToken()
        // );
        // String namaBuku = responseGetDataId.data.judul;

      // cetak struk peminjaman
      // setState(() {
      //   Navigator.push(context, 
      //     MaterialPageRoute(builder: (context) => HalamanPrint(idUser: idMhs, namaMhs: namaMhs, judulBuku: responseGetDataId.data.judul))
      //   );
      // });


        // showAlert("$namaBuku berhasil dipinjam!", AlertType.success);                                      

      },
    );
  }

  void showAlert(String text, AlertType type) {
   Alert(
      context: context,
      type: type,
      title: "Status",
      desc: text,
      buttons: [
        DialogButton(
          child: Text(
            "Confirm",
            style: TextStyle(color: Colors.white, fontSize: sizeConfig.getBlockHorizontal(4)),
          ),
          onPressed: () => Navigator.pop(context),
          width: sizeConfig.getBlockHorizontal(20),
        )
      ],
    ).show();
  }


}