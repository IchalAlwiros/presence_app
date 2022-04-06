import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class ForgotPasswordController extends GetxController {
  RxBool isLoading = false.obs;
  TextEditingController emailC = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;

  void sendEmail() async {
    if (emailC.text.isNotEmpty) {
      isLoading.value = false;
      try {
        await auth.sendPasswordResetEmail(email: emailC.text);
        Get.snackbar('Berhasil', 'Kami telah mengirimkan email reset ke ');
        Get.back(); //Back to login
      } catch (e) {
        Get.snackbar('Terjadi Kesalahan', 'Tidak dapat mengirim email reset');
      } finally {
        //finnaly ini akan selalu dijalan kan ditry juga catch
        isLoading.value = false;
      }
    }
  }
}
