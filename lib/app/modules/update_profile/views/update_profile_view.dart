import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../theme/theme.dart';
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
          backgroundColor: kPrimaryColor,
          title: Text(
            'UPDATE PROFILE',
            style: whiteTextStyle.copyWith(
              fontWeight: semiBold,
            ),
          ),
          centerTitle: true,
        ),
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: ListView(
            padding: EdgeInsets.all(20),
            children: [
              TextFormField(
                readOnly: true,
                autocorrect: false,
                controller: controller.nipC,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: kPrimaryColor, width: 2.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: kBackgroundColor, width: 2.0),
                  ),
                  labelText: "NIP",
                  labelStyle: greyTextStyle.copyWith(fontWeight: light),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                autocorrect: false,
                controller: controller.nameC,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: kPrimaryColor, width: 2.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: kBackgroundColor, width: 2.0),
                  ),
                  labelText: "Name",
                  labelStyle: greyTextStyle.copyWith(fontWeight: light),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                readOnly: true,
                autocorrect: false,
                controller: controller.emailC,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: kPrimaryColor, width: 2.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: kBackgroundColor, width: 2.0),
                  ),
                  labelText: "Email",
                  labelStyle: greyTextStyle.copyWith(fontWeight: light),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Photo Profile',
                style:
                    blackTextStyle.copyWith(fontWeight: semiBold, fontSize: 16),
              ),
              const SizedBox(height: 10),
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
                              height: 80,
                              width: 80,
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
                            child: Text(
                              'delete',
                              style: blueTextStyle.copyWith(),
                            ),
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
                        return Text(
                          'no image',
                          style: blueTextStyle,
                        );
                      }
                    }
                  }),
                  TextButton(
                      onPressed: () {
                        controller.pickImage();
                      },
                      child: Text(
                        'choose',
                        style: blueTextStyle,
                      ))
                ],
              ),
              const SizedBox(height: 30),
              Obx(() => ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: kPrimaryColor,
                    ),
                    onPressed: () async {
                      if (controller.isLoading.isFalse) {
                        await controller.updateProfile(user['uid']);
                      }
                    },
                    child: controller.isLoading.isFalse
                        ? Text(
                            'Update Profile',
                            style: whiteTextStyle.copyWith(
                              fontWeight: medium,
                            ),
                          )
                        : SizedBox(
                            height: 15,
                            width: 15,
                            child: CircularProgressIndicator(
                              strokeWidth: 3.0,
                              color: kBackgroundColor,
                            ),
                          ),
                  ))
            ],
          ),
        ));
  }
}
