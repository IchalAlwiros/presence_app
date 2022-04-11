import 'dart:js_util';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AllPresesensiController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot<Map<String, dynamic>>> streamAllPresence() async* {
    String uid = auth.currentUser!.uid;
    yield* firestore
        .collection('pegawai')
        .doc(uid)
        .collection("presence")
        .orderBy("date")
        .limitToLast(5)
        .snapshots();
  }
}
