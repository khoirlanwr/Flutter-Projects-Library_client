// To parse this JSON data, do
//
//     final responseGetDataId = responseGetDataIdFromJson(jsonString);

import 'dart:convert';

ResponseGetDataId responseGetDataIdFromJson(String str) => ResponseGetDataId.fromJson(json.decode(str));

String responseGetDataIdToJson(ResponseGetDataId data) => json.encode(data.toJson());

class ResponseGetDataId {
    ResponseGetDataId({
        this.status,
        this.data,
        this.message,
    });

    bool status;
    Data data;
    String message;

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
    Data({
        this.bukuId,
        this.judul,
        this.edisi,
        this.pengarang,
        this.kotaTerbit,
        this.penerbit,
        this.tahunTerbit,
        this.isbn,
        this.klasifikasi,
        this.kategori,
        this.umumRes,
        this.bahasa,
        this.deskripsi,
        this.lokasi,
        this.gambar,
        this.tanggalDitambahkan,
        this.stok,
    });

    String bukuId;
    String judul;
    String edisi;
    String pengarang;
    String kotaTerbit;
    String penerbit;
    String tahunTerbit;
    String isbn;
    String klasifikasi;
    String kategori;
    String umumRes;
    String bahasa;
    String deskripsi;
    String lokasi;
    String gambar;
    DateTime tanggalDitambahkan;
    int stok;

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        bukuId: json["buku_id"],
        judul: json["judul"],
        edisi: json["edisi"],
        pengarang: json["pengarang"],
        kotaTerbit: json["kota_terbit"],
        penerbit: json["penerbit"],
        tahunTerbit: json["tahun_terbit"],
        isbn: json["isbn"],
        klasifikasi: json["klasifikasi"],
        kategori: json["kategori"],
        umumRes: json["umum_res"],
        bahasa: json["bahasa"],
        deskripsi: json["deskripsi"],
        lokasi: json["lokasi"],
        gambar: json["gambar"],
        tanggalDitambahkan: DateTime.parse(json["tanggal_ditambahkan"]),
        stok: json["stok"],
    );

    Map<String, dynamic> toJson() => {
        "buku_id": bukuId,
        "judul": judul,
        "edisi": edisi,
        "pengarang": pengarang,
        "kota_terbit": kotaTerbit,
        "penerbit": penerbit,
        "tahun_terbit": tahunTerbit,
        "isbn": isbn,
        "klasifikasi": klasifikasi,
        "kategori": kategori,
        "umum_res": umumRes,
        "bahasa": bahasa,
        "deskripsi": deskripsi,
        "lokasi": lokasi,
        "gambar": gambar,
        "tanggal_ditambahkan": "${tanggalDitambahkan.year.toString().padLeft(4, '0')}-${tanggalDitambahkan.month.toString().padLeft(2, '0')}-${tanggalDitambahkan.day.toString().padLeft(2, '0')}",
        "stok": stok,
    };
}
