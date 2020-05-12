// To parse this JSON data, do
//
//     final responsePost = responsePostFromJson(jsonString);

import 'dart:convert';

ResponsePost responsePostFromJson(String str) => ResponsePost.fromJson(json.decode(str));

String responsePostToJson(ResponsePost data) => json.encode(data.toJson());

class ResponsePost {
    bool status;
    Data data;
    String message;

    ResponsePost({
        this.status,
        this.data,
        this.message,
    });

    factory ResponsePost.fromJson(Map<String, dynamic> json) => ResponsePost(
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
    int totalRecord;
    int totalPage;
    List<Record> records;
    int offset;
    int limit;
    int page;
    int prevPage;
    int nextPage;

    Data({
        this.totalRecord,
        this.totalPage,
        this.records,
        this.offset,
        this.limit,
        this.page,
        this.prevPage,
        this.nextPage,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        totalRecord: json["total_record"],
        totalPage: json["total_page"],
        records: List<Record>.from(json["records"].map((x) => Record.fromJson(x))),
        offset: json["offset"],
        limit: json["limit"],
        page: json["page"],
        prevPage: json["prev_page"],
        nextPage: json["next_page"],
    );

    Map<String, dynamic> toJson() => {
        "total_record": totalRecord,
        "total_page": totalPage,
        "records": List<dynamic>.from(records.map((x) => x.toJson())),
        "offset": offset,
        "limit": limit,
        "page": page,
        "prev_page": prevPage,
        "next_page": nextPage,
    };
}

class Record {
    String bukuId;
    String nama;
    String pengarang;
    String penerbit;
    String tahun;
    DateTime tanggalDitambahkan;
    int stok;

    Record({
        this.bukuId,
        this.nama,
        this.pengarang,
        this.penerbit,
        this.tahun,
        this.tanggalDitambahkan,
        this.stok,
    });

    factory Record.fromJson(Map<String, dynamic> json) => Record(
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
