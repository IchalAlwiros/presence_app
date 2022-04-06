import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddPegawaiController extends GetxController {
  TextEditingController nameC = TextEditingController();
  TextEditingController nipC = TextEditingController();
  TextEditingController emailC = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  void addPegawai() async {
    if (nameC.text.isNotEmpty &&
        nipC.text.isNotEmpty &&
        emailC.text.isNotEmpty) {
      try {
        UserCredential userCredential =
            await auth.createUserWithEmailAndPassword(
          email: emailC.text,
          password: "userPW",
        );

        // Mengecek User Credential dan menambahakan user
        if (userCredential.user != null) {
          String uid = userCredential.user!.uid;
          await firestore.collection("pegawai").doc(uid).set({
            "nip": nipC.text,
            "name": nameC.text,
            "email": emailC.text,
            "uid": uid,
            "createdAt": DateTime.now().toIso8601String(),
          });
          await userCredential.user!
              .sendEmailVerification(); //Mengirimkan email verifikasi
        }
        print(userCredential);
      } on FirebaseAuthException catch (e) {
        print(e.code);
        if (e.code == 'weak-password') {
          print('The password provided is too weak.');
          Get.snackbar(
              "Terjadi Kesalahan", "Password Anda Tidak Memenui Kreteria");
        } else if (e.code == 'email-already-in-use') {
          print('The account already exists for that email.');
          Get.snackbar("Terjadi Kesalahan", "Pegawai Sudah Terdaftar");
        }
      } catch (e) {
        print(e);
        Get.snackbar("Terjadi Kesalahan", "Tidak dapat menambahkan pegawai");
      }
    } else {
      Get.snackbar(
          "Terjadi Kesalahan", "NIP, Nama, dan email tidak boleh kosong");
    }
  }
}
