import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../constant/atamalar.dart';
import '../constant/color.dart';
import '../controller/ilacont.dart';
import '../helper/helper.dart';
import '../model/ilacmod.dart';
import 'searchmedicine.dart';

class ItemEdit extends StatefulWidget {
  const ItemEdit({super.key});

  @override
  State<ItemEdit> createState() => _ItemEditState();
}

final SQLiteHelper helper = SQLiteHelper();
final Ilaccont listController = Get.put(Ilaccont());
int kont = 0;
RxInt dosyaSecildi = 0.obs;
List<IlacModel> _searchResults = [];
List veri = [];
var vericekme = 0;
String htmsj = "";

class _ItemEditState extends State<ItemEdit> {
  @override
  void initState() {
    super.initState();
    name.text = "";
    number.text = "";
    date.text = "";
    aciklama.text = "";
    _secilendosya = null;
    debugPrint("init state başladı");
    _searchResults = listController.dataList;
    Future.delayed(
      Duration.zero,
      () async {
        await listController.getData();
        kont = 1;
        debugPrint(
            "List controller : ${listController.dataList.toJson().toString()}");
        name.text = listController.dataList[resultindex!].name!;
        number.text = listController.dataList[resultindex!].number.toString();
        date.text = listController.dataList[resultindex!].date.toString();
        gorsel = listController.dataList[resultindex!].gorsel;
        aciklama.text =
            listController.dataList[resultindex!].aciklama.toString();
      },
    );
  }

  File? _secilendosya;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: HexColor(backgroundColor),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const ListTile(
                title: Text(
                  "İlaç Düzenle",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              const Text(
                "Verilen Bilgiler Kayıtlı Verilerdir Değiştirmek \n İstediğiniz Veriler Üzerinde Değişiklik Yapabilirsiniz",
                style: TextStyle(fontSize: 15),
              ),
              const Text(""),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    TextFormField(
                      controller: name,
                      onChanged: (value) => name.text = value,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "İlaç Adını Değiştiriniz",
                      ),
                    ),
                    const Text(""),
                    TextFormField(
                      controller: number,
                      keyboardType: TextInputType.number,
                      onChanged: (value) => number.text = value,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "İlaç Kapsül Sayısını Değiştiriniz : ",
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
                              lastDate: DateTime(2060, 1, 1),
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
                  ],
                ),
              ),
              const Text(""),
              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog.adaptive(
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          ListTile(
                            title: const Text("Galeriden Fotoğraf Seç"),
                            onTap: () async {
                              dosyaSecildi(1);
                              await _pickImageFromGallery();
                              kont = 1;
                              setState(() {});
                              debugPrint("$gorsel");
                              Get.back();
                            },
                          ),
                          ListTile(
                            title: const Text("Kameradan Fotoğraf Çek"),
                            onTap: () async {
                              dosyaSecildi.value = 1;
                              await _pickImageFromCamera();
                              debugPrint(
                                  "********************************** 4");
                              kont = 1.obs.toInt();
                              debugPrint(
                                  "********************************** 5");
                              setState(() {});
                              Get.back();
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
                child: const Text("İlaç Fotoğrafı Seçiniz"),
              ),
              const Text(""),
              Obx(
                () {
                  if (dosyaSecildi.value == 0) {
                    Image.file(
                        File(listController.dataList[resultindex!].gorsel!));
                  }
                  return _secilendosya != null
                      ? SizedBox(
                          height: 300,
                          width: 300,
                          child: Image.file(_secilendosya!),
                        )
                      : SizedBox(
                          width: 300,
                          height: 300,
                          child: Image.file(
                            File(listController.dataList[resultindex!].gorsel!),
                          ),
                        );
                },
              ),
              Text(htmsj.obs.toString()),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      name.text = "";
                      date.text = "";
                      number.text = "";
                      gorsel = "";
                      Get.back();
                    },
                    child: const Text("İptal"),
                  ),
                  TextButton(
                    onPressed: () async {
                      if (name.text == "" ||
                          number.text == "" ||
                          date.text == "" ||
                          aciklama.text == "" ||
                          gorsel == null ||
                          name.text == " " ||
                          date.text == " ") {
                        htmsj = "Lütfen Boş Veri Girmeyiniz!";
                        setState(() {});
                        return;
                      }

                      debugPrint("${[date.text]}");
                      debugPrint("${[name.text]}");
                      debugPrint("${[number.text]}");
                      debugPrint("${[gorsel]}");
                      debugPrint("${[aciklama]}");
                      IlacModel updatedIlacModel = IlacModel(
                        id: _searchResults[resultindex!].id,
                        name: name.text,
                        date: date.text,
                        gorsel: gorsel,
                        number: int.parse(number.text),
                        aciklama: aciklama.text,
                      );

                      int rowsAffected =
                          await SQLiteHelper().updateIlacData(updatedIlacModel);
                      if (rowsAffected > 0) {
                        debugPrint('Item updated successfully!');
                      } else {
                        debugPrint('Error updating item!');
                      }
                      Get.to(() => const Searchmedicine());
                      name.text = "";
                      date.text = "";
                      number.text = "";
                      gorsel = "";
                      aciklama.text = "";
                    },
                    child: const Text(
                      "KAYDET",
                      style: TextStyle(color: Colors.green),
                    ),
                  ),
                ],
              ),
            ],
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
      _secilendosya = copiedFile;
      gorsel = copiedFile.path;
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
    debugPrint("****************************** 1");
    setState(() {
      _secilendosya = copiedFile;

      debugPrint("****************************** 2");
      gorsel = copiedFile.path;
    });
    debugPrint("****************************** 3");
  }
}
