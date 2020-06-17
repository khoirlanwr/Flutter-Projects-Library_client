// To parse this JSON data, do
//
//     final responsePeminjamanOnGoing = responsePeminjamanOnGoingFromJson(jsonString);

import 'dart:convert';

ResponsePeminjamanOnGoing responsePeminjamanOnGoingFromJson(String str) => ResponsePeminjamanOnGoing.fromJson(json.decode(str));

String responsePeminjamanOnGoingToJson(ResponsePeminjamanOnGoing data) => json.encode(data.toJson());

class ResponsePeminjamanOnGoing {
    ResponsePeminjamanOnGoing({
        this.status,
        this.data,
        this.message,
    });

    bool status;
    Data data;
    String message;

    factory ResponsePeminjamanOnGoing.fromJson(Map<String, dynamic> json) => ResponsePeminjamanOnGoing(
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
    List<RecordOnGoing> records;
    int offset;
    int limit;
    int page;
    int prevPage;
    int nextPage;

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        totalRecord: json["total_record"],
        totalPage: json["total_page"],
        records: List<RecordOnGoing>.from(json["records"].map((x) => RecordOnGoing.fromJson(x))),
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

class RecordOnGoing {
    RecordOnGoing({
        this.dataPeminjaman,
        this.detailBuku,
    });

    DataPeminjaman dataPeminjaman;
    DetailBuku detailBuku;

    factory RecordOnGoing.fromJson(Map<String, dynamic> json) => RecordOnGoing(
        dataPeminjaman: DataPeminjaman.fromJson(json["data_peminjaman"]),
        detailBuku: DetailBuku.fromJson(json["detail_buku"]),
    );

    Map<String, dynamic> toJson() => {
        "data_peminjaman": dataPeminjaman.toJson(),
        "detail_buku": detailBuku.toJson(),
    };
}

class DataPeminjaman {
    DataPeminjaman({
        this.idPeminjaman,
        this.idBuku,
        this.idMhs,
        this.tanggalPeminjaman,
        this.tanggalPengembalian,
    });

    String idPeminjaman;
    String idBuku;
    String idMhs;
    DateTime tanggalPeminjaman;
    DateTime tanggalPengembalian;

    factory DataPeminjaman.fromJson(Map<String, dynamic> json) => DataPeminjaman(
        idPeminjaman: json["id_peminjaman"],
        idBuku: json["id_buku"],
        idMhs: json["id_mhs"],
        tanggalPeminjaman: DateTime.parse(json["tanggal_peminjaman"]),
        tanggalPengembalian: DateTime.parse(json["tanggal_pengembalian"]),
    );

    Map<String, dynamic> toJson() => {
        "id_peminjaman": idPeminjaman,
        "id_buku": idBuku,
        "id_mhs": idMhs,
        "tanggal_peminjaman": tanggalPeminjaman.toIso8601String(),
        "tanggal_pengembalian": tanggalPengembalian.toIso8601String(),
    };
}

class DetailBuku {
    DetailBuku({
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

    factory DetailBuku.fromJson(Map<String, dynamic> json) => DetailBuku(
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
