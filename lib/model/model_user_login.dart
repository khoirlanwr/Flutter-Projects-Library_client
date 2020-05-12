// To parse this JSON data, do
//
//     final responseUserLogin = responseUserLoginFromJson(jsonString);

import 'dart:convert';

ResponseUserLogin responseUserLoginFromJson(String str) => ResponseUserLogin.fromJson(json.decode(str));

String responseUserLoginToJson(ResponseUserLogin data) => json.encode(data.toJson());

class ResponseUserLogin {
    bool status;
    Data data;
    String message;

    ResponseUserLogin({
        this.status,
        this.data,
        this.message,
    });

    factory ResponseUserLogin.fromJson(Map<String, dynamic> json) => ResponseUserLogin(
        status: json["status"],
        data: Data.fromJson(json["data"]),
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "data": data.toJson(),
        "message": message,
    };
}

class Data {
    String mhsId;
    String password;
    String nama;
    String jurusan;
    String tahunMasuk;
    DateTime tanggalDitambahkan;

    Data({
        this.mhsId,
        this.password,
        this.nama,
        this.jurusan,
        this.tahunMasuk,
        this.tanggalDitambahkan,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        mhsId: json["mhs_id"],
        password: json["password"],
        nama: json["nama"],
        jurusan: json["jurusan"],
        tahunMasuk: json["tahun_masuk"],
        tanggalDitambahkan: DateTime.parse(json["tanggal_ditambahkan"]),
    );

    Map<String, dynamic> toJson() => {
        "mhs_id": mhsId,
        "password": password,
        "nama": nama,
        "jurusan": jurusan,
        "tahun_masuk": tahunMasuk,
        "tanggal_ditambahkan": tanggalDitambahkan.toIso8601String(),
    };
}
