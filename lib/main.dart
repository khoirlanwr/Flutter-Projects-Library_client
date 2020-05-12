import 'package:flutter/material.dart';
import 'package:library_client/model/model_user_function.dart';
import 'package:library_client/screen/halaman_root.dart';
import 'package:library_client/screen/halaman_login.dart';
import 'package:library_client/screen/halaman_beranda.dart';
import 'package:library_client/screen/halaman_tambah_edit.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: HalamanRoot(user: new User()),
      // initialRoute: HalamanBeranda.id,
      routes: {
        HalamanRoot.id: (context) => HalamanRoot(),
        HalamanLogin.id: (context) => HalamanLogin(),
        HalamanBeranda.id: (context) => HalamanBeranda(),
        HalamanTambahEdit.id: (context) => HalamanTambahEdit()
      },
    );
  }
}
