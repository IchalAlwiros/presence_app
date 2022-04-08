import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as stor;

class UpdateProfileController extends GetxController {
  RxBool isLoading = false.obs;
  TextEditingController nipC = TextEditingController();
  TextEditingController nameC = TextEditingController();
  TextEditingController emailC = TextEditingController();

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  stor.FirebaseStorage storages = stor.FirebaseStorage.instance;

  final ImagePicker imagePicker = ImagePicker();

  XFile? image;

  void pickImage() async {
    image = await imagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      print(image!.name);
      print(image!.name.split(".").last);
      print(image!.path);
      // update();
    } else {
      print(image);
    }
    update();
  }

  Future<void> updateProfile(String uid) async {
    if (nipC.text.isNotEmpty &&
        nameC.text.isNotEmpty &&
        emailC.text.isNotEmpty) {
      isLoading.value = true;
      try {
        Map<String, dynamic> data = {
          "name": nameC.text,
        };
        if (image != null) {
          //proses upload image ke firebase storage

          File file = File(image!.path);
          String extention = image!.name.split(".").last;
          await storages.ref('$uid/profile.$extention').putFile(file);

          String urlImage =
              await storages.ref('$uid/profile.$extention').getDownloadURL();

          data.addAll({"profile": urlImage});
        }
        await firestore.collection('pegawai').doc(uid).update(data);
        image =
            null; //berhasil update profile image dikembalikan ke null untuk reset
        Get.snackbar('Berhasil', 'Sukses update profile');
      } catch (e) {
        Get.snackbar('Terjadi Kesalahan', 'Tidak dapat update profile');
      } finally {
        isLoading.value = false;
      }
    }
  }

  void deleteProfile(String uid) async {
    try {
      firestore.collection('pegawai').doc(uid).update({
        "profile": FieldValue.delete(),
      });
      Get.back();
      Get.snackbar("Berhasil", "berhasil delete profile picture");
    } catch (e) {
      Get.snackbar("Terjadi Kesalahan", 'Tidak dapat delete profile');
    } finally {
      update();
    }
  }
}
