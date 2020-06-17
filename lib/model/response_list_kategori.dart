// To parse this JSON data, do
//
//     final responseListKategori = responseListKategoriFromJson(jsonString);

import 'dart:convert';

ResponseListKategori responseListKategoriFromJson(String str) => ResponseListKategori.fromJson(json.decode(str));

String responseListKategoriToJson(ResponseListKategori data) => json.encode(data.toJson());

class ResponseListKategori {
    ResponseListKategori({
        this.status,
        this.data,
        this.message,
    });

    bool status;
    List<Datum> data;
    String message;

    factory ResponseListKategori.fromJson(Map<String, dynamic> json) => ResponseListKategori(
        status: json["status"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "message": message,
    };
}

class Datum {
    Datum({
        this.id,
        this.kategori,
    });

    String id;
    String kategori;

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        kategori: json["kategori"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "kategori": kategori,
    };
}
