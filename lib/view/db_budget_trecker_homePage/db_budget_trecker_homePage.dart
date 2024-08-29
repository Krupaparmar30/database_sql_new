

import 'dart:ffi';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../controller/db_budget_trecker_controller.dart';

class homePage extends StatelessWidget {
  const homePage({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(HomeController());

    return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text('Budget trecker'),

          ),
          body: Obx(
                () => Column(
              children: [

                TextFormField(
                  controller: controller.textEditingController,
                  onChanged: (value) {
                    controller. readDataLive(value);
                  },
                ),
                Card(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(controller.totalIncome.value.toString()),
                      Text(controller.totalEX.value.toString())
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: controller.data.length,
                    itemBuilder: (context, index) => Card(
                      color: controller.data[index]['isIncome'] == 1
                          ? Colors.green.shade100
                          : Colors.red.shade100,
                      child: ListTile(
                          leading:CircleAvatar(
                            radius: 30,
                            backgroundImage: FileImage(File(controller.data[index]['img'])),
                          ),
                          title: Text(controller.data[index]['amount'].toString()),
                          subtitle:
                          Text(controller.data[index]['category'].toString()),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () {
                                  controller.removeRecords(int.parse(
                                      controller.data[index]['id'].toString()));
                                },
                                icon: Icon(Icons.delete),
                              ),
                              IconButton(
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: Text('Upadate the details'),
                                        content: SizedBox(
                                          height: 250,
                                          child: Column(
                                            children: [
                                              GestureDetector(
                                                onDoubleTap: () async {
                                                  ImagePicker imagePicker = ImagePicker();
                                                  XFile? xFile = await imagePicker.pickImage(
                                                      source: ImageSource.gallery);
                                                  String path = xFile!.path;
                                                  File fileImages = File(path);
                                                  controller.getImages(fileImages);
                                                },
                                                child: CircleAvatar(
                                                  radius: 30,
                                                  backgroundImage: (controller.ImgPath != null)
                                                      ? FileImage(controller.ImgPath!.value)
                                                      : NetworkImage(controller.exImage.value),
                                                ),
                                              ),
                                              TextField(
                                                decoration: InputDecoration(
                                                    labelText:
                                                    "Enter your amount"),
                                                controller:
                                                controller.amountController,
                                              ),
                                              TextField(
                                                controller:
                                                controller.catController,
                                                decoration: InputDecoration(
                                                    labelText:
                                                    "Enter catagroy"),
                                              ),
                                              Obx(
                                                    () => SwitchListTile(
                                                  activeColor: Colors.green,
                                                  title: Text(
                                                    controller.isIncome.value
                                                        ? 'Income'
                                                        : 'Expense',
                                                    style: TextStyle(
                                                        color: controller
                                                            .isIncome.value
                                                            ? Colors.green
                                                            : Colors.red),
                                                  ),
                                                  value:
                                                  controller.isIncome.value,
                                                  onChanged: (value) {
                                                    controller.setIncome(value);
                                                  },
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                              onPressed: () {
                                                Get.back();
                                              },
                                              child: const Text('Cancel')),
                                          TextButton(
                                              onPressed: () {
                                                controller.updateRecords(
                                                    controller.data[index]
                                                    ['id'],
                                                    double.parse(controller
                                                        .amountController.text
                                                        .toString()),
                                                    controller.isIncome.value
                                                        ? 1
                                                        : 0,
                                                    controller
                                                        .catController.text,
                                                    controller.ImgPath!.value.path);
                                              },
                                              child: Text('Save'))
                                        ],
                                      ));
                                },
                                icon: Icon(Icons.edit),
                              ),
                            ],
                          )),
                    ),
                  ),
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Enter the details'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onDoubleTap: () async {
                          ImagePicker imagePicker = ImagePicker();
                          XFile? xFile = await imagePicker.pickImage(
                              source: ImageSource.gallery);
                          String path = xFile!.path;
                          File fileImages = File(path);
                          controller.getImages(fileImages);
                        },
                        child: CircleAvatar(
                          radius: 30,
                          backgroundImage: (controller.ImgPath != null)
                              ? FileImage(controller.ImgPath!.value)
                              : NetworkImage(controller.exImage.value),
                        ),
                      ),
                      TextField(
                        controller: controller.amountController,
                        decoration: InputDecoration(labelText: "Enter your amount"),
                      ),
                      TextField(
                        controller: controller.catController,
                        decoration: InputDecoration(labelText: "Enter catagroy"),
                      ),
                      Obx(
                            () => SwitchListTile(
                          title: Text("Income/Expense"),
                          value: controller.isIncome.value,
                          onChanged: (value) {
                            controller.setIncome(value);
                          },
                        ),
                      )
                    ],
                  ),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Get.back();
                        },
                        child: const Text('Cancel')),
                    TextButton(
                        onPressed: () {
                          double amount =
                          double.parse(controller.amountController.text);
                          int isIncome = controller.isIncome.value ? 1 : 0;
                          String category = controller.catController.text;
                          controller.insertRecord(amount, isIncome, category,controller.ImgPath!.value.path);

                          controller.amountController.clear();
                          controller.catController.clear();
                          controller.setIncome(false);
                          Get.back();
                        },
                        child: Text('Save'))
                  ],
                ),
              );
            },
            child: Icon(Icons.add),
          ),
        ));
  }
}

