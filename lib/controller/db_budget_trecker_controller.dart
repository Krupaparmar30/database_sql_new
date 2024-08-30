
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/state_manager.dart';
import 'package:image_picker/image_picker.dart';

import '../helper/db_budget_trecker_helper.dart';

class HomeController extends GetxController {
  RxList data = [].obs;
  RxBool isIncome = false.obs;
  RxDouble totalIncome = 0.0.obs;
  RxDouble totalEX = 0.0.obs;
  // File? imagePath;
  Rx<File>? ImgPath;
  RxString exImage="https://www.google.com/url?sa=i&url=https%3A%2F%2Fsharechat.com%2Fitem%2FAr14e90&psig=AOvVaw0xI-57d3o4MkhAHCdMZDpb&ust=1724926249741000&source=images&cd=vfe&opi=89978449&ved=0CBQQjRxqFwoTCMC01sK5l4gDFQAAAAAdAAAAABAE".obs;


  TextEditingController amountController = TextEditingController();
  TextEditingController catController = TextEditingController();
  TextEditingController textEditingController=TextEditingController();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    initDb();
  }

  void setIncome(bool value) {
    isIncome.value = value;
  }

  Future initDb() async {
    await DbHelper.dbHelper.database;
    await getRecords();
  }

  Future insertRecord(double amount, int isIncome, String category,String img) async {
    await DbHelper.dbHelper.insertData(amount, isIncome, category,img);
    await getRecords();
  }
  Future readDataLive(String value) async {
   data.value= await DbHelper.dbHelper.readLiveData(value);

  }

  Future updateRecords(
      int id, double amount, int isIncome, String category,String img) async {
    await DbHelper.dbHelper.updateData(id, amount, isIncome, category,img);
    await getRecords();
  }

  Future getRecords() async {
    totalIncome.value = 0.0;
    totalEX.value = 0.0;
    data.value = await DbHelper.dbHelper.readData();
    for (var i in data) {
      if (i['isIncome'] == 1) {
        totalIncome.value = totalIncome.value + i['amount'];
      } else {
        totalEX.value = totalEX.value + i['amount'];
      }
    }
  }

  Future removeRecords(int id) async {
    await DbHelper.dbHelper.deleteData(id);
    await getRecords();
  }


  void getImages(File img)
  {
    ImgPath=img.obs;
  }
}


