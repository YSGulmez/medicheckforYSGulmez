// To parse this JSON data, do
//
//     final ilacModel = ilacModelFromMap(jsonString);

import 'dart:convert';

List<IlacModel> ilacModelFromMap(String str) => List<IlacModel>.from(json.decode(str).map((x) => IlacModel.fromMap(x)));

String ilacModelToMap(List<IlacModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class IlacModel {
    final int? id;
    final String? name;
    final String? date;
    final int? number;
    final String? gorsel;
    final String? aciklama;

    IlacModel({
        this.id,
        this.name,
        this.date,
        this.number,
        this.gorsel,
        this.aciklama,
    });

    IlacModel copyWith({
        int? id,
        String? name,
        String? date,
        int? number,
        String? gorsel,
        String? aciklama,
    }) => 
        IlacModel(
            id: id ?? this.id,
            name: name ?? this.name,
            date: date ?? this.date,
            number: number ?? this.number,
            gorsel: gorsel ?? this.gorsel,
            aciklama: aciklama ?? this.aciklama,
        );

    factory IlacModel.fromMap(Map<String, dynamic> json) => IlacModel(
        id: json["id"],
        name: json["name"],
        date: json["date"],
        number: json["number"],
        gorsel: json["gorsel"],
        aciklama: json["aciklama"],
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "date": date,
        "number": number,
        "gorsel": gorsel,
        "aciklama": aciklama,
    };
}
