
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../helper/helper.dart';
import '../model/ilacmod.dart';


class Ilaccont extends GetxController {
  final SQLiteHelper helper = SQLiteHelper();

  var isLoading = 0.obs;
  var dataList = <IlacModel>[].obs;

  Future getData() async {
    dataList.value = await helper.getIlacdata();
    for (var item in dataList) {
      debugPrint(
          "item.id ${item.id}---item.name ${item.name}------ item.date ${item.date}------- item.number${item.number}------ item.gorsel${item.gorsel} ----------------item.acıklama${item.aciklama}");
    }
    try {
      debugPrint("Veri çekmeye başlandı");
      isLoading(0);

      dataList.value = await helper.getIlacdata();
      for (var item in dataList) {
        debugPrint(
            "item.id ${item.id}---item.name ${item.name}------ item.date ${item.date}------- item.number${item.number}------ item.gorsel${item.gorsel} ------------ item.aciklama${item.aciklama}");
      }
      isLoading(1);
    } catch (e) {
      isLoading(2);
      debugPrint("hata mesajı e: $e");
    } finally{
      debugPrint("veri çekme işlemi tamamlandı");
    }
  }
}
