import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:library_client/model/model_user_login.dart';
import 'package:library_client/model/response_post.dart';
import 'package:library_client/model/response_create_viewId.dart';
import 'package:library_client/model/response_get_data_id.dart';
import 'package:library_client/model/response_post_user.dart';

class ApiService {

  static final String _url = 'http://192.168.43.119:6996/perpustakaan/api/v1/data_buku';
  static final String _userURI = 'http://192.168.43.119:6996/perpustakaan/api/v1/data_mhs';

  static Future<List<Record>> getDataBuku(int pageNumber, int bookSize) async {    
    List<Record> records = []; 
    final response = await http.post('$_url/list', body: {
      'page': pageNumber.toString(),
      'size': bookSize.toString()
    });


    if(response.statusCode == 200) {
      // print('response.statusCode is 200');
      // get pure json
      final json = jsonDecode(response.body);
      // print(json);
      // convert to model
      ResponsePost responsePost = ResponsePost.fromJson(json);
      // add to records
      responsePost.data.records.forEach((value){
        records.add(value);  
      });

      return records;
    } else {
      return [];
    }
  }

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

      // print(responseGetDataId.data.nama);

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

  Future<ResponseUserLogin> loginUser(String username, String password) async {
    Map data = {
      'mhs_id': username,
      'password': password,
    };

    String bodyJson = json.encode(data);
    final response = await http.post('$_userURI/login', body: bodyJson);
    
    if(response.statusCode == 200) {
      final json = jsonDecode(response.body);      
      ResponseUserLogin responseUserLogin = ResponseUserLogin.fromJson(json);      
      // print(responseUserLogin.status);
      return responseUserLogin;
    } else {
      return null;
    }
  }
}
