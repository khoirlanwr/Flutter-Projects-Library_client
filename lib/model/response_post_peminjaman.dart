// To parse this JSON data, do
//
//     final responsePostPeminjaman = responsePostPeminjamanFromJson(jsonString);

import 'dart:convert';

ResponsePostPeminjaman responsePostPeminjamanFromJson(String str) => ResponsePostPeminjaman.fromJson(json.decode(str));

String responsePostPeminjamanToJson(ResponsePostPeminjaman data) => json.encode(data.toJson());

class ResponsePostPeminjaman {
    ResponsePostPeminjaman({
        this.status,
        this.data,
        this.message,
    });

    bool status;
    Data data;
    String message;

    factory ResponsePostPeminjaman.fromJson(Map<String, dynamic> json) => ResponsePostPeminjaman(
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
        this.buku,
        this.mahasiswa,
        this.peminjaman,
    });

    Buku buku;
    Mahasiswa mahasiswa;
    Peminjaman peminjaman;

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        buku: Buku.fromJson(json["buku"]),
        mahasiswa: Mahasiswa.fromJson(json["mahasiswa"]),
        peminjaman: Peminjaman.fromJson(json["peminjaman"]),
    );

    Map<String, dynamic> toJson() => {
        "buku": buku.toJson(),
        "mahasiswa": mahasiswa.toJson(),
        "peminjaman": peminjaman.toJson(),
    };
}

class Buku {
    Buku({
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

    factory Buku.fromJson(Map<String, dynamic> json) => Buku(
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

class Mahasiswa {
    Mahasiswa({
        this.mhsId,
        this.password,
        this.nama,
        this.jurusan,
        this.tahunMasuk,
        this.tanggalDitambahkan,
    });

    String mhsId;
    String password;
    String nama;
    String jurusan;
    String tahunMasuk;
    DateTime tanggalDitambahkan;

    factory Mahasiswa.fromJson(Map<String, dynamic> json) => Mahasiswa(
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

class Peminjaman {
    Peminjaman({
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

    factory Peminjaman.fromJson(Map<String, dynamic> json) => Peminjaman(
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
