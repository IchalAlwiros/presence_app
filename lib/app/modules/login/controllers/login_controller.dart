import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presence_app/app/routes/app_pages.dart';

class LoginController extends GetxController {
  TextEditingController emailC = TextEditingController();
  TextEditingController passC = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;

  void login() async {
    if (emailC.text.isNotEmpty && passC.text.isNotEmpty) {
      try {
        UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: emailC.text,
          password: passC.text,
        );
        print(userCredential);

        //Melakukan pengecekan/verifikasi email yang benar
        if (userCredential.user != null) {
          if (userCredential.user!.emailVerified == true) {
            if (passC.text == 'userPW') {
              Get.offAllNamed(Routes.NEW_PASSWORD);
            } else {
              Get.offAllNamed(Routes.HOME);
            }
          } else {
            Get.defaultDialog(
              title: 'Belum Verifikasi',
              middleText: "Anda belum melakukan verifikasi email",
              actions: [
                OutlinedButton(
                  onPressed: () => Get.back(),
                  child: Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    try {
                      await userCredential.user!.sendEmailVerification();
                      Get.back();
                      Get.snackbar(
                          'Kami telah mengirimkan verifikasi ke email anda',
                          'Cek email');
                    } catch (e) {
                      Get.snackbar('Terjadi Kesalagan',
                          'Tidak dapat melakukan Verifikasi Hubungi admin');
                    }
                  },
                  child: Text('Kirim Ulang'),
                )
              ],
            );
          }
        }
        // Get.offAllNamed(Routes.HOME);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          Get.snackbar('Terjadi Kesalahan', "Email Tidak terdaftar");
        } else if (e.code == 'wrong-password') {
          Get.snackbar('Terjadi Kesalahan', "Password Salah");
        }
      } catch (e) {
        // catch general / kesalahan diluar kondisi diatas
        Get.snackbar('Terjadi Kesalahan', "Tidak Dapat Login");
      }
    } else {
      Get.snackbar('Terjadi Kesalahan', "Email dan Password wajib diisi");
    }
  }
}
