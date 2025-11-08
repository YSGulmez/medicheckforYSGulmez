import 'dart:io';
import 'package:hexcolor/hexcolor.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../constant/atamalar.dart';
import '../constant/color.dart';
import '../helper/helper.dart';
import '../model/ilacmod.dart';
import 'edititem.dart';
import 'home.dart';


class AddmedicinePages extends StatefulWidget {
  const AddmedicinePages({super.key});

  @override
  State<AddmedicinePages> createState() => _AddmedicinePagesState();
}

RxInt dosyaSecildi = 0.obs;
File? secilendosya;

class _AddmedicinePagesState extends State<AddmedicinePages> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        name.text = "";
        number.text = "";
        date.text = "";
        aciklama.text = "";
        secilendosya = null;
      },
    );
  }

  final SQLiteHelper helper = SQLiteHelper();

  String htmsj = " ";
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: HexColor(backgroundColor),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                Row(
                  children: [
                    BackButton(
                      onPressed: () {
                        Get.to(() => const HomePages());
                        name.text = "";
                        date.text = "";
                        number.text = "";
                        aciklama.text = "";
                        secilendosya = null;
                        dosyaSecildi(0);
                      },
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 60),
                  child: Column(
                    children: [
                      const Image(
                        image: AssetImage("assets/Images/Header.png"),
                      ),
                      const Text(""),
                      const Text(""),
                      const Text(
                        "İlaç Fotoğrafını Seçiniz",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(""),
                      const Text(""),
                      Column(
                        children: [
                          const Text(""),
                          const Text(""),
                          TextFormField(
                            controller: name,
                            onChanged: (value) => name.text = value,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: "İlaç Adı",
                            ),
                          ),
                          const Text(""),
                          TextFormField(
                            controller: number,
                            onChanged: (value) => number.text = value,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: "Kapsül Sayısı",
                            ),
                          ),
                          const Text(""),
                          TextFormField(
                            onChanged: (value) => date.text = value,
                            controller: date,
                            keyboardType: TextInputType.datetime,
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              hintText: "Son Kullanım Tarihi",
                              suffixIcon: IconButton(
                                icon: const Icon(Icons.date_range),
                                onPressed: () async {
                                  DateTime? dateTime;
                                  await showDatePicker(
                                    context: Get.context!,
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime(2050, 1, 1),
                                    confirmText: "Onayla",
                                    cancelText: "İptal",
                                  ).then(
                                    (value) {
                                      if (value == null) {
                                        return;
                                      }
                                      dateTime = value;
                                      setState(() {});
                                      date.text =
                                          ("${dateTime!.day}/${dateTime!.month}/${dateTime!.year}");
                                      debugPrint(
                                          "dateTime.day: ${dateTime!.day} -- dateTime.year: ${dateTime!.year}");
                                    },
                                  );
                                },
                              ),
                            ),
                          ),
                          const Text(""),
                          TextField(
                            decoration: const InputDecoration(
                              hintText: "İlaçla ilgili kullanım detayı vb.",
                              border: OutlineInputBorder(),
                            ),
                            controller: aciklama,
                            maxLines: 3,
                            maxLength: 200,
                          ),
                          Text(htmsj),
                          ElevatedButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      ListTile(
                                        title: const Text(
                                            "Galeriden Fotoğraf Seç"),
                                        onTap: () async {
                                          await _pickImageFromGallery();
                                          kont = 1;

                                          Get.back();
                                        },
                                      ),
                                      ListTile(
                                        title: const Text(
                                            "Kameradan Fotoğraf Çek"),
                                        onTap: () async {
                                          //dosyaSecildi(1);
                                          await _pickImageFromCamera();
                                          kont = 1.obs.toInt();
                                          Get.back();
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            child: const Text(
                              "Fotoğraf Seç",
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                          const Text(""),
                          Obx(
                            () {
                              _updateDosyaSecildi();
                              if (dosyaSecildi.value == 0) {
                                return const Text("Görsel Dosyası Seçilmedi");
                              }
                              if (dosyaSecildi.value == 1) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              return SizedBox(
                                height: 200,
                                width: 200,
                                child: Image.file(
                                  File(gorsel!),
                                ),
                              );
                            },
                          ),
                          const Text(""),
                          ElevatedButton(
                            onPressed: () async {
                              if (GetUtils.isDateTime(date.text)) {
                                htmsj = "Hata";
                                setState(() {});
                              }
                              if (name.text == "" ||
                                  date.text == "" ||
                                  secilendosya == null ||
                                  // ignore: unnecessary_null_comparison
                                  number.toString() == null) {
                                htmsj = "Bilgiler Boş Olamaz";
                                setState(() {});
                                return;
                              }
                              await insterdata();
                              name.text = "";
                              date.text = "";
                              number.text = "";
                              dosyaSecildi(0);
                              gorsel = "";
                              aciklama.text = "";
                              secilendosya = null;
                              Get.to(() => const HomePages());
                            },
                            child: const Text(
                              "Kaydet",
                              style: TextStyle(color: Colors.green),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future _pickImageFromGallery() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile == null) return;
    final file = File(pickedFile.path);
    final directory = await getApplicationDocumentsDirectory();
    final String path =
        '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';
    final copiedFile = await file.copy(path);
    setState(() {
      secilendosya = copiedFile;
      gorsel = copiedFile.path;
      dosyaSecildi(1);
    });
  }

  Future _pickImageFromCamera() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
    );
    if (pickedFile == null) return;
    final file = File(pickedFile.path);
    final directory = await getApplicationDocumentsDirectory();
    final String path =
        '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';
    final copiedFile = await file.copy(path);
    setState(() {
      secilendosya = copiedFile;
      gorsel = copiedFile.path;
      dosyaSecildi(1);
    });
  }

  insterdata() async {
    await helper
        .insterdata(
      IlacModel(
        name: name.text,
        date: date.text,
        number: int.parse(number.text),
        gorsel: gorsel,
        aciklama: aciklama.text,
      ),
    )
        .then(
      (value) {
        if (value == -1) {
          debugPrint("sorun");
        } else {
          debugPrint("value: $value");
        }
      },
    );
  }

  void _updateDosyaSecildi() {
    if (dosyaSecildi.value == 1) {
      dosyaSecildi.value = 2;
    }
  }
}
