import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/update_profile_controller.dart';

class UpdateProfileView extends GetView<UpdateProfileController> {
  final Map<String, dynamic> user = Get.arguments;
  @override
  Widget build(BuildContext context) {
    controller.nipC.text = user['nip'];
    controller.nameC.text = user['name'];
    controller.emailC.text = user['email'];
    return Scaffold(
        appBar: AppBar(
          title: Text('UPDATE PROFILE'),
          centerTitle: true,
        ),
        body: ListView(
          padding: EdgeInsets.all(20),
          children: [
            TextFormField(
              readOnly: true,
              autocorrect: false,
              controller: controller.nipC,
              decoration: InputDecoration(
                labelText: "NIP",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              autocorrect: false,
              controller: controller.nameC,
              decoration: InputDecoration(
                labelText: "Name",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              readOnly: true,
              autocorrect: false,
              controller: controller.emailC,
              decoration: InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            Text('Photo Profile'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // user["profile"] != null && user["profile"] != ""
                //     ? Text('foto profile')
                //     : Text('no choosen'),
                // Text('no choosen'),
                GetBuilder<UpdateProfileController>(builder: (controller) {
                  if (controller.image != null) {
                    return Column(
                      children: [
                        ClipOval(
                          child: Container(
                            height: 100,
                            width: 100,
                            child: Image.file(
                              File(controller.image!.path),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            controller.deleteProfile(user['uid']);
                          },
                          child: Text('delete'),
                        )
                      ],
                    );
                  } else {
                    if (user['profile'] != null) {
                      return ClipOval(
                        child: Container(
                          height: 100,
                          width: 100,
                          child: Image.network(
                            user['profile'],
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    } else {
                      return Text('no image');
                    }
                  }
                }),
                TextButton(
                    onPressed: () {
                      controller.pickImage();
                    },
                    child: Text(
                      'choose',
                    ))
              ],
            ),
            SizedBox(height: 30),
            Obx(() => ElevatedButton(
                  onPressed: () async {
                    if (controller.isLoading.isFalse) {
                      await controller.updateProfile(user['uid']);
                    }
                  },
                  child: controller.isLoading.isFalse
                      ? Text('Update Profile')
                      : CircularProgressIndicator(),
                ))
          ],
        ));
  }
}
