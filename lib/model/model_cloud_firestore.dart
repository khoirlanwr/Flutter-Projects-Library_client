import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:random_string/random_string.dart';

class Cloud {

  // create database reference
  final _db = Firestore.instance;

  void storeToCloud(String idBuku, String idMhs, String namaBuku, String namaMhs, String deviceToken) async {
    if (deviceToken != null) {
      
      // random for doc id
      String docId = randomAlphaNumeric(10);

      // collections
      var _borrowedBooks = _db
        .collection("borrowedBooks")
        .document(docId);

      // specific
      await _borrowedBooks.setData({
        "idBuku" : idBuku,
        "idMhs" : idMhs,
        "namaBuku" : namaBuku,
        "namaMhs" : namaMhs,
        "deviceToken" : deviceToken,
        "createdAt" : FieldValue.serverTimestamp() 
      });
    }    
  }


}