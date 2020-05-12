import 'package:flutter/material.dart';
import 'package:library_client/model/model_user_function.dart';
import 'package:library_client/model/response_get_data_id.dart';
import 'package:library_client/service/api_service.dart';
import 'package:library_client/service/size_config.dart';
import 'package:library_client/model/model_push_notification.dart';
import 'package:toast/toast.dart';
import 'package:library_client/model/model_cloud_firestore.dart';

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
  static int prevLength = 0;
  String namaMhs = "";

  void takeGood() async {
    responseGetDataId = await apiService.getDataById(widget.bukuId);
  }

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
  }

  void getNamaMhs() {
    widget.user.getCurrentUser().then((user) {
      setState(() {
        namaMhs = user.data.nama;
      });
    });
  }

  Widget dataRecords() {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(0.0),
        child: FutureBuilder<ResponseGetDataId>(
          future: apiService.getDataById(widget.bukuId),
          builder: (context, snapshot) {
            if(snapshot.connectionState == ConnectionState.waiting) {
              return Container(
                width: double.infinity,
                height: sizeConfig.getBlockVertical(60),
                decoration: BoxDecoration(
                  color: Colors.indigoAccent,                  
                ),
                child: CircularProgressIndicator()
              );
            } else {
              return Stack(
                children: <Widget>[
                  backgroundHeader(),
                  animationPerson(),
                  summaryRecord()
                ],
              );
            }
          }
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
        backgroundColor: Colors.indigoAccent,
        centerTitle: true,
        title: new Text("Library Client Apps", style: TextStyle(color: Colors.white)),                  
      ),
      body: Container(
        child: Column(
          children: <Widget>[        
            Expanded(
              child: dataRecords() 
            ),
            detailBuku()
          ],
        ),
      ),

      // floatingActionButton: FloatingActionButton(
      //   backgroundColor: Colors.indigo,
      //   child: Icon(Icons.refresh),
      //   onPressed: () {
      //     setState(() {
            
      //     });
      //   }
      // ), 
    );
  }

  Widget backgroundHeader() {
    return Container(      
      width: double.infinity,
      height: sizeConfig.getBlockVertical(60),
      decoration: BoxDecoration(
        color: Colors.indigoAccent,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(0),
          bottomRight: Radius.circular(50),
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

  Widget summaryRecord() {
    return Positioned(
      top: sizeConfig.getBlockVertical(40),
      left: sizeConfig.getBlockHorizontal(10),
      child: Container(
        width: sizeConfig.getBlockHorizontal(80),
        height: sizeConfig.getBlockVertical(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: sizeConfig.getBlockVertical(3), horizontal: sizeConfig.getBlockHorizontal(3)),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Column(
                    children: <Widget> [
                      ClipRRect(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                        child: Icon(Icons.book, size: sizeConfig.getBlockHorizontal(15), color: Colors.indigo)
                      ),
                    ]
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      textDesc(responseGetDataId.data.nama, 
                        55, 
                        TextAlign.left, 
                        sizeConfig.getBlockHorizontal(4)
                      ),                      
                      textDesc(responseGetDataId.data.pengarang, 
                        55, 
                        TextAlign.left, 
                        sizeConfig.getBlockHorizontal(3)
                      ),
                    ],
                  ),
                ],
              )
            ],
          ), 
        ),
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


  Widget animationPerson() {

    return Positioned(
      top: sizeConfig.getBlockVertical(10),
      left: sizeConfig.getBlockHorizontal(0),
      right: sizeConfig.getBlockHorizontal(5),
      child: Container(
        margin: EdgeInsets.all(sizeConfig.getBlockHorizontal(1)),
        child: Center(
          child: Image.asset('images/transparent/people-reading.png', height: sizeConfig.getBlockHorizontal(40), width: sizeConfig.getBlockVertical(80))
        ),
      )
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


  Widget detailBuku() {    
    return Container(
      width: sizeConfig.getBlockHorizontal(80),
      height: sizeConfig.getBlockVertical(37),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10)
      ),
      child: Padding(
        padding: EdgeInsets.only(top: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
              children: <Widget>[
                textDesc("As an educator and researcher in the field of algorithms for over two decades, I can unequivocally say that the Cormen et al book is the best textbook that I have ever seen on this subject. It offers an incisive, encyclopedic, and modern treatment of algorithms, and our department will continue to use it for teaching at both the graduate and undergraduate levels, as well as a reliable research reference, --Gabriel Robins, Department of Computer Science, University of Virginia (Gabriel Robins)", 80, TextAlign.left, sizeConfig.getBlockHorizontal(3)),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                // InkWell(
                //   splashColor: Colors.indigo,
                //   borderRadius: BorderRadius.circular(10.0),
                //   child: Container(
                //     padding: EdgeInsets.symmetric(vertical: sizeConfig.getBlockVertical(0), horizontal: sizeConfig.getBlockHorizontal(20)),                    
                //     width: sizeConfig.getBlockHorizontal(80),
                //     height: sizeConfig.getBlockVertical(7),
                //     decoration: BoxDecoration(
                //       color: Colors.indigoAccent,
                //       borderRadius: BorderRadius.circular(10)
                //     ),
                //     child: ListTile(
                //       title: Text('pinjam buku ini', style: TextStyle(color: Colors.white, fontSize: sizeConfig.getBlockHorizontal(5))),                      
                //     ),
                //   ),
                //   onTap: () {

                //       cloud.storeToCloud(
                //         widget.bukuId,
                //         responseGetDataId.data.nama,
                //         namaMhs,
                //         pushNotif.getToken()
                //       );
                //       Navigator.pop(context);                      
                //       // Navigator.pushNamedAndRemoveUntil(context, 
                //       //   HalamanBeranda.id, (Route<dynamic> route) => false);
                //       setState(() {});
                //       Toast.show('Berhasil', context);
                    
                //       // // simpan panjang data peminjaman
                //       // prevLength = peminjaman.length;

                //       // // tambah data ke list peminjaman
                //       // peminjaman.add(
                //       //   RecordPeminjaman(
                //       //     namaMhs: "Khoirul Anwar",
                //       //     namaBuku: responseGetDataId.data.nama,
                //       //     bukuId: widget.bukuId,
                //       //     devToken: pushNotif.getToken() 
                //       //   )
                //       // );

                //       // if ((peminjaman.length - prevLength) == 1 ) {
                        
                //       //   // // tambahkan data ke cloud firestore
                //       //   // print("Data berhasil ditambahkan");
                        

                //       //   // Navigator.pushNamedAndRemoveUntil(context, 
                //       //   //   HalamanBeranda.id, 
                //       //   //   (Route<dynamic> route) => false);
                //       //   // setState(() {});
                //       //   // Toast.show('Berhasil', context);
                      
                //       // } else {
                //       //   Toast.show('Gagal', context);
                //       // }
                //   },
                // ),
                inkWellBtnPinjam(),
                Divider(),
                Divider(),
                inkWellBtnRefresh()
              ],
            )
          ] 
        ) 
      ),
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
        setState(() {});
        
      },
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

        cloud.storeToCloud(
          widget.bukuId,
          responseGetDataId.data.nama,
          namaMhs,
          pushNotif.getToken()
        );

        setState(() {
          Toast.show('Berhasil', context);         
        });
        Navigator.pop(context);
                                      
      },
    );
  }

}