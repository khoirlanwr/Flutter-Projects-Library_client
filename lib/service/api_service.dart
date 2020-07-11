import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:library_client/model/model_user_login.dart';
import 'package:library_client/model/response_peminjaman_ongoing.dart';
import 'package:library_client/model/response_post.dart';
import 'package:library_client/model/response_create_viewId.dart';
import 'package:library_client/model/response_get_data_id.dart';
import 'package:library_client/model/response_post_user.dart';
import 'package:library_client/model/response_post_peminjaman.dart';
import 'package:library_client/model/response_register.dart';
import 'package:library_client/model/response_riwayat_peminjaman.dart';
import 'package:library_client/model/response_list_kategori.dart';
import 'package:library_client/model/response_kategori.dart';

class ApiService {

  static final String _url = 'http://192.168.43.119:6996/perpustakaan/api/v1/data_buku';
  static final String _userURI = 'http://192.168.43.119:6996/perpustakaan/api/v1/data_mhs';
  static final String _urlPeminjaman = 'http://192.168.43.119:6996/perpustakaan/api/v1/peminjaman';
  static final String _urlKategori = 'http://192.168.43.119:6996/perpustakaan/api/v1/kategori';


  static String timeParser(String time) {
    String timeSubString1 = time.substring(0, 17);
    String timeFinal = timeSubString1 + "00Z";
    return timeFinal;
  }

  static Future<List<Record>> getDataBuku(int pageNumber, int bookSize) async {    
    List<Record> records = []; 
    final response = await http.post('$_url/list', body: {
      'page': pageNumber.toString(),
      'size': bookSize.toString()
    });


    if(response.statusCode == 200) {
      final json = jsonDecode(response.body);
      ResponsePost responsePost = ResponsePost.fromJson(json);
      responsePost.data.records.forEach((value){
        records.add(value);  
      });

      print(records.length);
      return records;
    } else {
      return [];
    }
  }


  // Edited for search by judul buku
  static Future<List<Record>> searchBookByTitle(String keywords, int pageNumber, int bookSize) async {
    List<Record> records = [];
    Map data = {
      'search': keywords,
      'page': pageNumber.toString(),
      'size': bookSize.toString()
    };

    String bodyJson = json.encode(data);
    final response = await http.post('$_url/list', body: bodyJson);

    if (response.statusCode == 200) {
      print('status code == 200');
      final json = jsonDecode(response.body);
      print(json);
      
      ResponsePost responsePost = ResponsePost.fromJson(json);
      // ResponseSearchBook responseSearchBook = ResponseSearchBook.fromJson(json);
      
      // tambahkan setiap data hasil search ke records;
      responsePost.data.records.forEach((value) {
        print(value.judul);
        records.add(value);
      });

      print(records.length);
      return records;

    } else {
      print('status code != 200');
      return [];
    }
  }

  // Edited: for post data pinjam buku ke mariaDB
  static Future<ResponsePostPeminjaman> postPeminjamanBuku(String idBuku, String idMhs) async {
    
    String timeBorrowedBook = DateTime.now().toIso8601String();
    timeBorrowedBook = timeParser(timeBorrowedBook);    

    var now = new DateTime.now();
    var timeReturnedBook = now.add(new Duration(days: 14));
    String timeReturnedBooks = timeParser(timeReturnedBook.toIso8601String());

    Map data = {
      'id_buku': idBuku,
      'id_mhs': idMhs,
      'tanggal_peminjaman': timeBorrowedBook,
      'tanggal_pengembalian': timeReturnedBooks      
    };

    print(data['tanggal_peminjaman']);
    print(data['tanggal_pengembalian']);


    String bodyJson = json.encode(data);
    final response = await http.post('$_urlPeminjaman/pinjam', body: bodyJson);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      print(json);
      ResponsePostPeminjaman responsePostPeminjaman = ResponsePostPeminjaman.fromJson(json);

      return responsePostPeminjaman;
    } else {
      return null;
    }   
  }

  // Edited: for post data buku
  Future<ResponseCreateViewId> createRecord(String nama, String pengarang, String penerbit, String tahun, String stok) async {
    Map data = {
      'nama': nama,
      'pengarang': pengarang,
      'penerbit': penerbit,
      'tahun': tahun,
      'stok': int.parse(stok)
    };
    
    String bodyJson = json.encode(data);
    final response = await http.post('$_url/create', body: bodyJson);
    if (response.statusCode == 200) {

      final json = jsonDecode(response.body);
      // ResponsePost responsePost = ResponsePost.fromJson(json);
      ResponseCreateViewId responseCreateViewId = ResponseCreateViewId.fromJson(json);
            
      return responseCreateViewId;   
    } else {
      return null;
    }
  }

  Future<ResponseGetDataId> getDataById(String bukuId) async {
    final response = await http.get('$_url/view/$bukuId');
    
    print(response.statusCode);
    if (response.statusCode == 200) {

      // get pure json
      final json = jsonDecode(response.body);
      
      // convert to model space
      ResponseGetDataId responseGetDataId = ResponseGetDataId.fromJson(json);

      print(responseGetDataId.data.judul);

      return responseGetDataId;

    } else {
      return null;
    }
  }
  
  // Fungsi get data user 
  static Future<List<RecordMhs>> getDataUser() async {    
    List<RecordMhs> recordsMhs = [];
    final responseUser = await http.post('$_userURI/list');

    if (responseUser.statusCode == 200) {
      final json_pure = jsonDecode(responseUser.body);
      ResponseGetDataUser responseGetDataUser = ResponseGetDataUser.fromJson(json_pure);
      
      responseGetDataUser.data.records.forEach((item) {
        recordsMhs.add(item);
      });

      return recordsMhs;       
    } else {
      return [];
    }
  }

  // Fungsi login user mahasiswa
  Future<ResponseUserLogin> loginUser(String username, String password) async {
    Map data = {
      'mhs_id': username,
      'password': password,
    };

    String bodyJson = json.encode(data) ;
    final response = await http.post('$_userURI/login', body: bodyJson);
    
    if(response.statusCode == 200) {
      print("Status koneksi loginUser == 200");
      
      final json = jsonDecode(response.body);

      // print(json['status']);
      if (json['status'] == true) {
        ResponseUserLogin responseUserLogin = ResponseUserLogin.fromJson(json);      
        return responseUserLogin;
      } else {

      }

    } else {
      print('data tidak ditemukan');
      return null;
    }

  }

  Future<String> login(String username, String password) async {
    Map data = {
      'mhs_id': username,
      'password': password,
    };

    String bodyJson = json.encode(data) ;
    final response = await http.post('$_userURI/login', body: bodyJson);
    
    String result = "";

    if(response.statusCode == 200) {
      print("Status koneksi loginUser == 200");
      
      final json = jsonDecode(response.body);

      print(json['status']);
      if (json['status'] == true) {
        ResponseUserLogin responseUserLogin = ResponseUserLogin.fromJson(json);      
        print(responseUserLogin);
        result = responseUserLogin.data.mhsId;
      } else {
        result = "404";
      }

      return result;

    } else {
      print('status koneksi gagal!');
      return null;
    }

  }


  Future<String> register(String idMhs, String password, String confirmPassword, String tglLahir) async {
    
    print(idMhs);
    print(password);
    print(confirmPassword);
    print(tglLahir);


    if (password != confirmPassword) {
      return "PasswordNotSame!";
    } else {

      Map data = {
        "mhs_id" : idMhs,
        "password": password,
        "tanggal_lahir": tglLahir  
      };  

      // Map data = {
      //     "mhs_id" : "0916040030",
      //     "password": "halodunia123",
      //     "tanggal_lahir": "1998-04-14T00:00:00Z",
      // };

      String bodyJson = json.encode(data);
      final response = await http.post('$_userURI/register', body: bodyJson);
      
      if (response.statusCode == 200) {
        
        final json = jsonDecode(response.body);
        print(json);

        ResponseRegister responseRegister = ResponseRegister.fromJson(json);

        if (responseRegister.data.active == 1) {
          // maka berhasil register
          return "Akun berhasil diaktivasi!";
        } else {
          // maka gagal register
          return "Akun tidak ditemukan!";
        }
      } else {
        return null;
      }
    }
  } 


  // fungsi untuk cek user ada atau tidak
  Future<String> cekUser(String idMhs) async {
    final response = await http.get('$_userURI/view/$idMhs');

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      print(json);

      // memakai register kelas karena strukturnya sama
      ResponseRegister responseCekUser = ResponseRegister.fromJson(json);
      if (responseCekUser.status == false) {
        return "false";
      } else {
        return responseCekUser.data.nama;
      }     
    } else {
      return "koneksi gagal!";
    }

  }

  // Fungsi untuk melihat daftar buku yang sedang dipinjam
  static Future<List<RecordOnGoing>> peminjamanOnGoing(String idMhs) async {
    
    List<RecordOnGoing> records = [];
    Map data = {
      "id": idMhs,
      "page": "1",
      "size": "5"
    };

    var bodyJson = jsonEncode(data);
    final response = await http.post('$_urlPeminjaman/berlangsung',
    headers: {"Content-type": "application/json"}, 
    body: bodyJson);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      // print('json: ');
      // print(json);

      ResponsePeminjamanOnGoing responsePost = ResponsePeminjamanOnGoing.fromJson(json);

      responsePost.data.records.forEach((value){
        records.add(value);
      });

      print("Panjang records: ");
      print(records.length);
      return records;      
    } else {
      return [];
    }
  }

  // Fungsi untuk melihat daftar buku yang sudah selesai dikembalikan
  static Future<List<RecordRiwayatPeminjaman>> peminjamanRiwayat(String idMahasiswa) async {
    List<RecordRiwayatPeminjaman> records = [];
    Map data = {
      "id": idMahasiswa,
      "page": "1",
      "size": "5"
    };

    var bodyJson = jsonEncode(data);
    final response = await http.post('$_urlPeminjaman/riwayat',
    headers: {"Content-type": "application/json"}, 
    body: bodyJson);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      
      print(json);

      ResponseRiwayatPeminjaman responseRiwayatPeminjaman = ResponseRiwayatPeminjaman.fromJson(json);

      responseRiwayatPeminjaman.data.records.forEach((value) {
        records.add(value);
      });


      return records;
    } else {
      return [];
    }
  } 

  // Edited for: return list of kategori buku
  static Future<List<Datum>> listKategori() async {
    
    List<Datum> records = [];
    final response = await http.get('$_urlKategori/list');

    if (response.statusCode == 200) {
      
      final json = jsonDecode(response.body);
      ResponseListKategori responseListKategori = ResponseListKategori.fromJson(json);

      responseListKategori.data.forEach((value){
        records.add(value);
      });

      return records;

    } else {
      return [];
    }

  }   


  // Edited for melihat data buku dalam kategori
  static Future<List<RecordKategori>> getDataBukuKategori(String kategori, String namaBuku, int pageNumber, int bookSize) async {    
    List<RecordKategori> records = []; 
    Map data = {
      'category': kategori,
      'search': namaBuku,
      'page': pageNumber.toString(),
      'size': bookSize.toString()
    };
    String bodyJson = jsonEncode(data);
    final response = await http.post('$_url/list', body: bodyJson);

    if(response.statusCode == 200) {
      final json = jsonDecode(response.body);
      // print(json);
      ResponseKategori responseKategori = ResponseKategori.fromJson(json);
      // ResponsePost responsePost = ResponsePost.fromJson(json);
      responseKategori.data.records.forEach((value){
        records.add(value);  
      });

      // print(records.length);
      return records;
    } else {
      return [];
    }
  }


}
