import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

import '../constant/atamalar.dart';
import '../constant/color.dart';
import 'addmed.dart';
import 'searchmedicine.dart';

class HomePages extends StatefulWidget {
  const HomePages({super.key});

  @override
  State<HomePages> createState() => _HomePagesState();
}

class _HomePagesState extends State<HomePages> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: HexColor(backgroundColor),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 60),
                child: Center(
                  child: SizedBox(
                    width: 200.w,
                    height: 200.h,
                    child: const Image(
                      image: AssetImage("assets/Images/Header.png"),
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  SizedBox(
                    width: 180.w,
                    height: 200.h,
                    child: IconButton(
                      iconSize: 5,
                      onPressed: () {
                        name.text = "";
                        date.text = "";
                        number.text = "";
                        aciklama.text = "";
                        secilendosya = null;
                        dosyaSecildi(0);
                        Get.to(() => const AddmedicinePages());
                      },
                      icon: const Image(
                        image: AssetImage("assets/Images/Header2.png"),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 180.w,
                    height: 200.h,
                    child: IconButton(
                      iconSize: 5,
                      onPressed: () {
                        Get.to(() => const Searchmedicine());
                      },
                      icon: const Image(
                        image: AssetImage("assets/Images/Header4.png"),
                      ),
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
}
