// To parse this JSON data, do
//
//     final responseGetDataId = responseGetDataIdFromJson(jsonString);

import 'dart:convert';

ResponseGetDataId responseGetDataIdFromJson(String str) => ResponseGetDataId.fromJson(json.decode(str));

String responseGetDataIdToJson(ResponseGetDataId data) => json.encode(data.toJson());

class ResponseGetDataId {
    bool status;
    Data data;
    String message;

    ResponseGetDataId({
        this.status,
        this.data,
        this.message,
    });

    factory ResponseGetDataId.fromJson(Map<String, dynamic> json) => ResponseGetDataId(
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
