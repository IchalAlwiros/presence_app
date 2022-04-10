import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:presence_app/app/routes/app_pages.dart';
import 'package:geolocator/geolocator.dart';

class PageIndexController extends GetxController {
  RxInt pageIndex = 0.obs;

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  void changePage(int i) async {
    switch (i) {
      case 1:
        // print('Absesnsi');
        Map<String, dynamic> dataResponse = await _determinePosition();
        if (dataResponse['error'] != true) {
          Position position = dataResponse['position'];

          List<Placemark> placemarks = await placemarkFromCoordinates(
              position.latitude, position.longitude);

          // print('${position.latitude}, ${position.longitude}');
          String address =
              '${placemarks[0].street}, ${placemarks[0].subLocality}, ${placemarks[0].locality}';
          await updatePosition(position, address);
          // Get.snackbar("${dataResponse['message']} ", '${address}');

          //cek distance between 2 position
          double distance = Geolocator.distanceBetween(
              -6.340033, 106.791409, position.latitude, position.longitude);

          //Presensi
          await presensi(position, address, distance);
          Get.snackbar("Berhasil", 'Anda telah present');
        } else {
          Get.snackbar("Terjadi Kesalagan", dataResponse['message']);
        }
        break;
      case 2:
        pageIndex.value = i;
        Get.offAllNamed(Routes.PAGE_PROFILE);
        break;

      default:
        pageIndex.value = i;
        Get.offAllNamed(Routes.HOME);
    }
  }

  Future<void> presensi(
      Position position, String address, double distance) async {
    String uid = await auth.currentUser!.uid;

    CollectionReference<Map<String, dynamic>> colPresence =
        await firestore.collection("pegawai").doc(uid).collection("presence");

    QuerySnapshot<Map<String, dynamic>> snapshotPresence =
        await colPresence.get();

    print(snapshotPresence.docs.length);

    DateTime now = DateTime.now();
    DateFormat.yMd().format(now);
    String todayDocId = DateFormat.yMd().format(now).replaceAll("/", "-");

    String status = "Di luar area";

    if (distance <= 200) {
      //menegecek jaraknya
      //didalam area
      status = 'Di dalam area';
    }

    if (snapshotPresence.docs.length == 0) {
      //belum pernah absen & set absent masuk
      await colPresence.doc(todayDocId).set({
        "date": now.toIso8601String(),
        "masuk": {
          "date": now.toIso8601String(),
          "lat": position.latitude,
          "long": position.longitude,
          "address": address,
          "status": "didalam area"
        }
      });
    } else {
      //Sudah pernah absen -> cek hari ini sudah absen atau belum
      DocumentSnapshot<Map<String, dynamic>> todayDoc =
          await colPresence.doc(todayDocId).get();

      print(todayDoc.exists);

      if (todayDoc.exists == true) {
        //tinggal absen keluar atau sudah absent masuk & keluar
        Map<String, dynamic>? dataPresenceToday = todayDoc.data();
        if (dataPresenceToday?["keluar"] != null) {
          //sudah absen masuk dan keluar

          Get.snackbar("Sukses", "anda telah absen masuk & keluar");
        } else {
          //absent keluar
          await colPresence.doc(todayDocId).update({
            "keluar": {
              "date": now.toIso8601String(),
              "lat": position.latitude,
              "long": position.longitude,
              "address": address,
              "status": status,
              "distance": distance,
            }
          });
        }
      } else {
        //absent masuk
        print("dijalankan");
        await colPresence.doc(todayDocId).set({
          "date": now.toIso8601String(), //untuk mengurutkan data masuk
          "masuk": {
            "date": now.toIso8601String(),
            "lat": position.latitude,
            "long": position.longitude,
            "address": address,
            "status": status,
            "distance": distance,
          }
        });
      }
    }
  }

  Future<void> updatePosition(Position position, String address) async {
    String uid = auth.currentUser!.uid;

    firestore.collection("pegawai").doc(uid).update({
      "position": {
        "lat": position.latitude,
        "long": position.longitude,
      },
      "address": address
    });
  }

  Future<Map<String, dynamic>> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return {
        "message": "tidak dapat mengambil gps dari gps ",
        "error": true,
      };
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return {
          "message": "Izin menggunakan gps ditolak ",
          "error": true,
        };
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return {
        "message": "Setting location anda belum diberi izin ",
        "error": true,
      };
      // return Future.error(
      //     'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    Position position = await Geolocator.getCurrentPosition();
    return {
      "position": position,
      "message": "Berhasil mendapat posisi",
      "error": false,
    };
  }
}
