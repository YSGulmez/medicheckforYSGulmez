import 'package:flutter/material.dart';
import 'package:get/get.dart';

TextEditingController date = TextEditingController();
TextEditingController name = TextEditingController();
TextEditingController number = TextEditingController();
TextEditingController searchController = TextEditingController();
TextEditingController aciklama = TextEditingController();
String? gorsel;
int? resultindex;

double deviceWidth = Get.width.obs.toDouble();
double deviceHeigth = Get.height.obs.toDouble();
