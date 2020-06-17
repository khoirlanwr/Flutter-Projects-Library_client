// To parse this JSON data, do
//
//     final responseKategori = responseKategoriFromJson(jsonString);

import 'dart:convert';

ResponseKategori responseKategoriFromJson(String str) => ResponseKategori.fromJson(json.decode(str));

String responseKategoriToJson(ResponseKategori data) => json.encode(data.toJson());

class ResponseKategori {
    ResponseKategori({
        this.status,
        this.data,
        this.message,
    });

    bool status;
    Data data;
    String message;

    factory ResponseKategori.fromJson(Map<String, dynamic> json) => ResponseKategori(
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

    int totalRecord;
    int totalPage;
    List<RecordKategori> records;
    int offset;
    int limit;
    int page;
    int prevPage;
    int nextPage;

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        totalRecord: json["total_record"],
        totalPage: json["total_page"],
        records: List<RecordKategori>.from(json["records"].map((x) => RecordKategori.fromJson(x))),
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

class RecordKategori {
    RecordKategori({
        this.bukuId,
        this.judul,
        this.penulis,
        this.penerbit,
        this.jumlahEksemplar,
        this.kategori,
        this.letakBuku,
        this.gambar,
        this.tanggalDitambahkan,
        this.stok,
    });

    String bukuId;
    String judul;
    String penulis;
    String penerbit;
    String jumlahEksemplar;
    String kategori;
    String letakBuku;
    String gambar;
    DateTime tanggalDitambahkan;
    int stok;

    factory RecordKategori.fromJson(Map<String, dynamic> json) => RecordKategori(
        bukuId: json["buku_id"],
        judul: json["judul"],
        penulis: json["penulis"],
        penerbit: json["penerbit"],
        jumlahEksemplar: json["jumlah_eksemplar"],
        kategori: json["kategori"],
        letakBuku: json["letak_buku"],
        gambar: json["gambar"],
        tanggalDitambahkan: DateTime.parse(json["tanggal_ditambahkan"]),
        stok: json["stok"],
    );

    Map<String, dynamic> toJson() => {
        "buku_id": bukuId,
        "judul": judul,
        "penulis": penulis,
        "penerbit": penerbit,
        "jumlah_eksemplar": jumlahEksemplar,
        "kategori": kategori,
        "letak_buku": letakBuku,
        "gambar": gambar,
        "tanggal_ditambahkan": tanggalDitambahkan.toIso8601String(),
        "stok": stok,
    };
}
