import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:presence_app/app/routes/app_pages.dart';

class NewPasswordController extends GetxController {
  TextEditingController newPassC = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;

  void newPassword() async {
    if (newPassC.text.isNotEmpty) {
      if (newPassC.text != 'userPW') {
        try {
          await auth.currentUser!.updatePassword(newPassC.text);
          String email = auth.currentUser!.email!; //Untuk menyimpan emailnya
          await auth.signOut();

          await auth.signInWithEmailAndPassword(
              email: email,
              password:
                  newPassC.text); //untuk login kembali setelah ganti paswword
          Get.offAllNamed(Routes.HOME);
        } on FirebaseAuthException catch (e) {
          if (e.code == 'weak-password') {
            Get.snackbar('Terjadi Kesalahan', "Password Wajib 6 karakter");
          }
        } catch (e) {
          //Error secara general/error lain
          Get.snackbar(
              'Terjadi Kesalahan', "tidak dapat membuat password baru");
        }
      } else {
        Get.snackbar(
            'Terjdi Kesalahan', 'Password tidak boleh sama seperti sebelumnya');
      }
    } else {
      Get.snackbar('Terjdi Kesalahan', 'Password baru wajib diisi');
    }
  }
}
