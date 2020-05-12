// To parse this JSON data, do
//
//     final responseCreateViewId = responseCreateViewIdFromJson(jsonString);

import 'dart:convert';

ResponseCreateViewId responseCreateViewIdFromJson(String str) => ResponseCreateViewId.fromJson(json.decode(str));

String responseCreateViewIdToJson(ResponseCreateViewId data) => json.encode(data.toJson());

class ResponseCreateViewId {
    bool status;
    Data data;
    String message;

    ResponseCreateViewId({
        this.status,
        this.data,
        this.message,
    });

    factory ResponseCreateViewId.fromJson(Map<String, dynamic> json) => ResponseCreateViewId(
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
    String bukuId;
    String nama;
    String pengarang;
    String penerbit;
    String tahun;
    DateTime tanggalDitambahkan;
    int stok;

    Data({
        this.bukuId,
        this.nama,
        this.pengarang,
        this.penerbit,
        this.tahun,
        this.tanggalDitambahkan,
        this.stok,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        bukuId: json["buku_id"],
        nama: json["nama"],
        pengarang: json["pengarang"],
        penerbit: json["penerbit"],
        tahun: json["tahun"],
        tanggalDitambahkan: DateTime.parse(json["tanggal_ditambahkan"]),
        stok: json["stok"],
    );

    Map<String, dynamic> toJson() => {
        "buku_id": bukuId,
        "nama": nama,
        "pengarang": pengarang,
        "penerbit": penerbit,
        "tahun": tahun,
        "tanggal_ditambahkan": tanggalDitambahkan.toIso8601String(),
        "stok": stok,
    };
}
