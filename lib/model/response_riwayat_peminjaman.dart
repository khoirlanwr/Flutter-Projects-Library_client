// To parse this JSON data, do
//
//     final responseRiwayatPeminjaman = responseRiwayatPeminjamanFromJson(jsonString);

import 'dart:convert';

ResponseRiwayatPeminjaman responseRiwayatPeminjamanFromJson(String str) => ResponseRiwayatPeminjaman.fromJson(json.decode(str));

String responseRiwayatPeminjamanToJson(ResponseRiwayatPeminjaman data) => json.encode(data.toJson());

class ResponseRiwayatPeminjaman {
    ResponseRiwayatPeminjaman({
        this.status,
        this.data,
        this.message,
    });

    bool status;
    Data data;
    String message;

    factory ResponseRiwayatPeminjaman.fromJson(Map<String, dynamic> json) => ResponseRiwayatPeminjaman(
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
    List<RecordRiwayatPeminjaman> records;
    int offset;
    int limit;
    int page;
    int prevPage;
    int nextPage;

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        totalRecord: json["total_record"],
        totalPage: json["total_page"],
        records: List<RecordRiwayatPeminjaman>.from(json["records"].map((x) => RecordRiwayatPeminjaman.fromJson(x))),
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

class RecordRiwayatPeminjaman {
    RecordRiwayatPeminjaman({
        this.dataPeminjaman,
        this.detailBuku,
    });

    DataPeminjaman dataPeminjaman;
    DetailBuku detailBuku;

    factory RecordRiwayatPeminjaman.fromJson(Map<String, dynamic> json) => RecordRiwayatPeminjaman(
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
        this.tanggalKembali,
    });

    String idPeminjaman;
    String idBuku;
    String idMhs;
    DateTime tanggalPeminjaman;
    DateTime tanggalPengembalian;
    DateTime tanggalKembali;

    factory DataPeminjaman.fromJson(Map<String, dynamic> json) => DataPeminjaman(
        idPeminjaman: json["id_peminjaman"],
        idBuku: json["id_buku"],
        idMhs: json["id_mhs"],
        tanggalPeminjaman: DateTime.parse(json["tanggal_peminjaman"]),
        tanggalPengembalian: DateTime.parse(json["tanggal_pengembalian"]),
        tanggalKembali: DateTime.parse(json["tanggal_kembali"]),
    );

    Map<String, dynamic> toJson() => {
        "id_peminjaman": idPeminjaman,
        "id_buku": idBuku,
        "id_mhs": idMhs,
        "tanggal_peminjaman": tanggalPeminjaman.toIso8601String(),
        "tanggal_pengembalian": tanggalPengembalian.toIso8601String(),
        "tanggal_kembali": tanggalKembali.toIso8601String(),
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
