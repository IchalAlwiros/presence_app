import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class UpdatePasswordController extends GetxController {
  RxBool isLoading = false.obs;
  TextEditingController currC = TextEditingController();
  TextEditingController newC = TextEditingController();
  TextEditingController confrimC = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;

  void updatePass() async {
    if (currC.text.isNotEmpty &&
        newC.text.isNotEmpty &&
        confrimC.text.isNotEmpty) {
      if (newC.text == confrimC.text) {
        isLoading.value = true;
        try {
          String emailUser = auth.currentUser!
              .email!; //Menyimpan user yang telah login dan akan mengubah password

          await auth.signInWithEmailAndPassword(
              email: emailUser,
              password: currC
                  .text); //Mencoba login dulu, untuk mengecek orang yang login sedang mengubah password

          await auth.currentUser!
              .updatePassword(newC.text); //mengupdate password nya

          // await auth.signOut();

          // await auth.signInWithEmailAndPassword(
          //     email: emailUser, password: currC.text);
          Get.back();

          Get.snackbar("Berhasil", 'Passwod Anda Sukses diubah');
        } on FirebaseAuthException catch (e) {
          if (e.code == 'wrong-password') {
            Get.snackbar("Terjadi Kesalahan", "Current Password Salah");
          } else {
            Get.snackbar("Terjadi Kesalahan", "${e.code.toLowerCase()}");
          }
        } catch (e) {
          Get.snackbar("Terjadi Kesalahan", "Tidak dapat update paswword");
        } finally {
          isLoading.value = false;
        }
      } else {
        Get.snackbar("Terjadi Kesalahn", "Confirm Password tidak cocok");
      }
    } else {
      Get.snackbar("Terjadi Kesalahan", "Semua input harus diisi");
    }
  }
}
