import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presence_app/app/routes/app_pages.dart';

class LoginController extends GetxController {
  RxBool isLoading = false.obs;
  TextEditingController emailC = TextEditingController();
  TextEditingController passC = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> login() async {
    if (emailC.text.isNotEmpty && passC.text.isNotEmpty) {
      isLoading.value = true;
      try {
        UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: emailC.text,
          password: passC.text,
        );
        print(userCredential);

        //Melakukan pengecekan/verifikasi email yang benar
        if (userCredential.user != null) {
          if (userCredential.user!.emailVerified == true) {
            // isLoading.value = false;
            if (passC.text == 'userPW') {
              Get.offAllNamed(Routes.NEW_PASSWORD);
            } else {
              Get.offAllNamed(Routes.HOME);
            }
          } else {
            isLoading.value = true;
            Get.defaultDialog(
              title: 'Belum Verifikasi',
              middleText: "Anda belum melakukan verifikasi email",
              actions: [
                OutlinedButton(
                  onPressed: () {
                    isLoading.value = false;
                    Get.back();
                  },
                  child: Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    try {
                      //Proses kirim email verification
                      await userCredential.user!.sendEmailVerification();
                      Get.back();
                      Get.snackbar(
                          'Kami telah mengirimkan verifikasi ke email anda',
                          'Cek email');
                      // isLoading.value = false;
                    } catch (e) {
                      // isLoading.value = false;
                      Get.snackbar('Terjadi Kesalagan',
                          'Tidak dapat melakukan Verifikasi Hubungi admin');
                    } finally {
                      //finnaly ini akan selalu dijalan kan ditry juga catch
                      isLoading.value = false;
                    }
                  },
                  child: Text('Kirim Ulang'),
                )
              ],
            );
          }
        }
        // Get.offAllNamed(Routes.HOME);
        // isLoading.value = false;
      } on FirebaseAuthException catch (e) {
        // isLoading.value = false;

        if (e.code == 'user-not-found') {
          Get.snackbar('Terjadi Kesalahan', "Email Tidak terdaftar");
        } else if (e.code == 'wrong-password') {
          Get.snackbar('Terjadi Kesalahan', "Password Salah");
        }
      } catch (e) {
        // isLoading.value = false;
        // catch general / kesalahan diluar kondisi diatas
        Get.snackbar('Terjadi Kesalahan', "Tidak Dapat Login");
      } finally {
        //finnaly ini akan selalu dijalan kan ditry juga catch
        isLoading.value = false;
      }
    } else {
      Get.snackbar('Terjadi Kesalahan', "Email dan Password wajib diisi");
    }
  }
}
