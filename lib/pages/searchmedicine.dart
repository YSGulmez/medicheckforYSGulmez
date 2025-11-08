import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

import '../constant/atamalar.dart';
import '../constant/color.dart';
import '../controller/ilacont.dart';
import '../helper/helper.dart';
import '../model/ilacmod.dart';
import 'addmed.dart';
import 'edititem.dart';
import 'home.dart';

class Searchmedicine extends StatefulWidget {
  const Searchmedicine({super.key});

  @override
  State<Searchmedicine> createState() => _SearchmedicineState();
}

final SQLiteHelper helper = SQLiteHelper();
final Ilaccont listController = Get.put(Ilaccont());
int kont = 0;
List<IlacModel> _searchResults = [];
List veri = [];
var vericekme = 0;

class _SearchmedicineState extends State<Searchmedicine> {
  // ignore: unused_field
  File? _secilendosya;
  @override
  void initState() {
    super.initState();
    debugPrint("init state başladı");
    _searchResults = listController.dataList;
    Future.delayed(
      Duration.zero,
      () async {
        await listController.getData();
        kont = 1;
        debugPrint(
            "List controller : ${listController.dataList.toJson().toString()}");
      },
    );
  }

  File? ilacFoto;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: HexColor(backgroundColor),
        body: SingleChildScrollView(
          child: Obx(
            () {
              for (var item in listController.dataList) {
                if (item.gorsel == null) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              }
              if (kont == 0) {
                const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return Column(
                children: [
                  Row(
                    children: [
                      BackButton(
                        onPressed: () {
                          Get.to(() => const HomePages());
                        },
                      ),
                    ],
                  ),
                  Center(
                    child: Image.asset("assets/Images/Header.png"),
                  ),
                  const Text(""),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          onPressed: () {
                            showModalBottomSheet(
                              isScrollControlled: true,
                              context: context,
                              builder: (context) {
                                return SizedBox(
                                  height: deviceHeigth,
                                  width: deviceWidth,
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        const Text(""),
                                        const Text(""),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20),
                                          child: TextField(
                                            controller: searchController,
                                            onChanged: (query) {
                                              _searchIlac(query);
                                              setState(() {});
                                            },
                                            decoration: const InputDecoration(
                                              border: OutlineInputBorder(),
                                              hintText: "İlaç Arama",
                                              suffixIcon: Icon(Icons.search),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: deviceWidth,
                                          height: deviceHeigth - 85,
                                          child: GridView.builder(
                                            itemCount: _searchResults.length,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 10),
                                            gridDelegate:
                                                const SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 2,
                                            ),
                                            itemBuilder: (
                                              BuildContext context,
                                              int index,
                                            ) {
                                              return SingleChildScrollView(
                                                child: MaterialButton(
                                                  child: Column(
                                                    children: [
                                                      SizedBox(
                                                        height: 150,
                                                        width: 150,
                                                        child: Image.file(
                                                          File(_searchResults[
                                                                  index]
                                                              .gorsel!),
                                                        ),
                                                      ),
                                                      Text(
                                                          "${_searchResults[index].name}"),
                                                      const Text(""),
                                                    ],
                                                  ),
                                                  onPressed: () {
                                                    bilgi(index);
                                                  },
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          icon: const Icon(Icons.search),
                        ),
                      ],
                    ),
                  ),
                  const Text(""),
                  const Text(""),
                  SizedBox(
                    height: deviceHeigth - 380,
                    width: deviceWidth,
                    child: listController.dataList.isEmpty
                        ? Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text("Henüz İlaç Kaydetmediniz"),
                                TextButton(
                                    style: const ButtonStyle(
                                        foregroundColor: WidgetStatePropertyAll(
                                            Colors.black)),
                                    onPressed: () {
                                      Get.to(() => const AddmedicinePages());
                                    },
                                    child: const Text("Şimdi İlaç Kaydedin"))
                              ],
                            ),
                          )
                        : gridview(),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  GridView gridview() {
    return GridView.builder(
      itemCount: listController.dataList.length,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      itemBuilder: (BuildContext context, int index) {
        return SingleChildScrollView(
          child: MaterialButton(
            child: Column(
              children: [
                SizedBox(
                    height: 150,
                    width: 150,
                    child: Image.file(
                        File(listController.dataList[index].gorsel!))),
                Text("${listController.dataList[index].name}"),
                const Text(""),
              ],
            ),
            onPressed: () {
              bilgi(index);
            },
          ),
        );
      },
    );
  }

  void _searchIlac(String query) {
    final List<IlacModel> results = [];
    for (var ilac in listController.dataList) {
      if (ilac.name!.toLowerCase().contains(query.toLowerCase())) {
        results.add(ilac);
      }
    }
    setState(() {
      _searchResults = results;
    });
  }

  void bilgi(index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                child: Column(
                  children: [
                    const ListTile(
                      title: Text("İlaç Bilgileri"),
                    ),
                    SizedBox(
                        width: 200,
                        height: 200,
                        child: Image.file(
                            File(listController.dataList[index].gorsel!))),
                    ListTile(
                      title: Text(
                          "İlaç Adı : \n ${listController.dataList[index].name}"),
                    ),
                    ListTile(
                      title: Text(
                          "İlaç Kapsül Sayısı : \n ${listController.dataList[index].number}"),
                    ),
                    ListTile(
                      title: Text(
                          "İlaç Son Kullanım Tarihi : \n ${listController.dataList[index].date}"),
                    ),
                    ListTile(
                      title: Text(
                          "Açıklama : \n ${listController.dataList[index].aciklama ?? "Açıklama Verilmedi"}"),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const ListTile(
                                      title: Text(
                                          "Silmek İstediğinizi Onaylıyormusunuz (Bu İşlem Geri Alınamaz!)"),
                                    ),
                                    OverflowBar(
                                      children: [
                                        TextButton(
                                          onPressed: () {
                                            Get.back();
                                          },
                                          child: const Text(
                                            "İptal",
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () async {
                                            int id = listController
                                                .dataList[index].id!;
                                            int rowsAffected =
                                                await SQLiteHelper()
                                                    .deleteIlacData(id);
                                            if (rowsAffected > 0) {
                                              debugPrint(
                                                  "Item deleted successfully");
                                              listController.dataList
                                                  .removeAt(index);
                                            } else {
                                              debugPrint("Error deleting item");
                                            }
                                            Get.to(() => const HomePages());
                                          },
                                          child: const Text(
                                            "SİL",
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                          child: const Text(
                            "Sil",
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            gorsel = "";
                            name.text = "";
                            number.text = "";
                            date.text = "";
                            aciklama.text = "";
                            resultindex = index;
                            Get.to(() => const ItemEdit());
                          },
                          child: const Text("Düzenle"),
                        ),
                        TextButton(
                          onPressed: () {
                            Get.back();
                          },
                          child: const Text("İptal"),
                        )
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
