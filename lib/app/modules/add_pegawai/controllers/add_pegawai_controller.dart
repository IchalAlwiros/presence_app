import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddPegawaiController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isLoadingAddPegawai = false.obs;
  TextEditingController nameC = TextEditingController();
  TextEditingController nipC = TextEditingController();
  TextEditingController emailC = TextEditingController();
  TextEditingController passAdminC = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> prosesAddPegawai() async {
    print("ADD PEGAWAI");
    //Menanyakan Passwordnya
    if (passAdminC.text.isNotEmpty) {
      isLoadingAddPegawai.value = true;
      try {
        String emailAdmin = auth.currentUser!.email!;

        UserCredential userCredentialAdmin =
            await auth.signInWithEmailAndPassword(
                email: emailAdmin, password: passAdminC.text);

        UserCredential pegawaiCredential =
            await auth.createUserWithEmailAndPassword(
          email: emailC.text,
          password: "userPW",
        );

        // Mengecek User Credential dan menambahakan user
        if (pegawaiCredential.user != null) {
          String uid = pegawaiCredential.user!.uid;
          await firestore.collection("pegawai").doc(uid).set({
            "nip": nipC.text,
            "name": nameC.text,
            "email": emailC.text,
            "uid": uid,
            "role": "pegawai",
            "createdAt": DateTime.now().toIso8601String(),
          });
          await pegawaiCredential.user!
              .sendEmailVerification(); //Mengirimkan email verifikasi

          await auth.signOut(); // sign out email

          //Melakukan Login Ulang
          UserCredential userCredentialAdmin =
              await auth.signInWithEmailAndPassword(
                  email: emailAdmin, password: passAdminC.text);

          Get.back(); //tutup dialong
          Get.back(); // back to home
          Get.snackbar('Berhasil', "Berhasil Menambahkan pegawai");
        }
        // print(pegawaiCredential);
      } on FirebaseAuthException catch (e) {
        // isLoadingAddPegawai.value = false;
        // print(e.code);
        if (e.code == 'weak-password') {
          // print('The password provided is too weak.');
          Get.snackbar(
              "Terjadi Kesalahan", "Password Anda Tidak Memenui Kreteria");
        } else if (e.code == 'email-already-in-use') {
          // print('The account already exists for that email.');
          Get.snackbar("Terjadi Kesalahan", "Pegawai Sudah Terdaftar");
        } else if (e.code == "wrong-password") {
          Get.snackbar(
              "Terjadi Kesalahan", "Admin tidak dapat login, Password Salah");
        } else {
          Get.snackbar('Terjadi Kesalahan', "${e.code}");
        }
      } catch (e) {
        // isLoadingAddPegawai.value = false;
        print(e);
        Get.snackbar("Terjadi Kesalahan", "Tidak dapat menambahkan pegawai");
      } finally {
        //finnaly ini akan selalu dijalan kan ditry juga catch
        isLoading.value = false;
        isLoadingAddPegawai.value = false;
      }
    } else {
      isLoading.value = false;
      Get.snackbar(
          "Terjadi Kesalahan", "Password Wajib Diisi untuk keperluan Validasi");
    }
  }

  Future<void> addPegawai() async {
    if (nameC.text.isNotEmpty &&
        nipC.text.isNotEmpty &&
        emailC.text.isNotEmpty) {
      isLoading.value = true;
      Get.defaultDialog(
          title: "Validasi Admin",
          content: Column(
            children: [
              Text("Masukan password untuk validasi admin"),
              SizedBox(height: 10),
              TextField(
                controller: passAdminC,
                autocorrect: false,
                decoration: InputDecoration(
                    labelText: "Password", border: OutlineInputBorder()),
              )
            ],
          ),
          actions: [
            OutlinedButton(
              onPressed: () {
                isLoading.value = false;
                Get.back();
              },
              child: Text('CANCEL'),
            ),
            Obx(() => ElevatedButton(
                  onPressed: () async {
                    if (isLoadingAddPegawai.isFalse) {
                      await prosesAddPegawai();
                    }
                    isLoading.value = false;
                  },
                  child: Text(isLoadingAddPegawai.isFalse
                      ? 'ADD PEGAWAI'
                      : 'Loading..'),
                )),
          ]);
    } else {
      Get.snackbar(
          "Terjadi Kesalahan", "NIP, Nama, dan email tidak boleh kosong");
    }
  }
}
