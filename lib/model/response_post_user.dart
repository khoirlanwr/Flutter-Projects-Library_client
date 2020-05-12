// To parse this JSON data, do
//
//     final responseGetDataUser = responseGetDataUserFromJson(jsonString);

import 'dart:convert';

ResponseGetDataUser responseGetDataUserFromJson(String str) => ResponseGetDataUser.fromJson(json.decode(str));

String responseGetDataUserToJson(ResponseGetDataUser data) => json.encode(data.toJson());

class ResponseGetDataUser {
    bool status;
    Data data;
    String message;

    ResponseGetDataUser({
        this.status,
        this.data,
        this.message,
    });

    factory ResponseGetDataUser.fromJson(Map<String, dynamic> json) => ResponseGetDataUser(
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
    List<RecordMhs> records;
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
        records: List<RecordMhs>.from(json["records"].map((x) => RecordMhs.fromJson(x))),
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

class RecordMhs {
    String mhsId;
    String password;
    String nama;
    String jurusan;
    String tahunMasuk;
    DateTime tanggalDitambahkan;

    RecordMhs({
        this.mhsId,
        this.password,
        this.nama,
        this.jurusan,
        this.tahunMasuk,
        this.tanggalDitambahkan,
    });

    factory RecordMhs.fromJson(Map<String, dynamic> json) => RecordMhs(
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
