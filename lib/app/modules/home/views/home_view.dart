import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:presence_app/app/controllers/page_index_controller.dart';
import 'package:presence_app/app/routes/app_pages.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  final pageC = Get.find<PageIndexController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HomeView'),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () => Get.toNamed(Routes.PAGE_PROFILE),
              icon: Icon(Icons.person))

          // StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          //     stream: controller.streamRole(), //untuk memantau role
          //     builder: (context, snapshot) {
          //       if (snapshot.connectionState == ConnectionState.waiting) {
          //         return SizedBox();
          //       }
          //       String role = snapshot.data!.data()!["role"];
          //       return IconButton(onPressed: () =>  Get.toNamed((role == 'admin') ? Routes.ADD_PEGAWAI) :, icon: icon)
          //       // if (role == "admin") {
          //       //   //Ini admin
          //       //   return IconButton(
          //       //     onPressed: () => Get.toNamed(Routes.ADD_PEGAWAI),
          //       //     icon: Icon(Icons.person),
          //       //   );
          //       // } else {
          //       //   return SizedBox();
          //       // }
          //     }),
        ],
      ),
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: controller.streamUser(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.hasData) {
              Map<String, dynamic> user = snapshot.data!.data()!;
              String defaultImage =
                  "https://ui-avatars.com/api/?name=${user["name"]}";
              return ListView(
                padding: EdgeInsets.all(20),
                children: [
                  Row(
                    children: [
                      ClipOval(
                        child: Container(
                          width: 75,
                          height: 75,
                          color: Colors.grey[200],
                          child: Image.network(
                            user['profile'] != null
                                ? user['profile']
                                : defaultImage,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Welcome, '),
                          Container(
                            width: 200,
                            child: Text(
                              user['address'] != null
                                  ? '${user['address']}'
                                  : "Belum Ada Posisi",
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.red[200],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${user["job"]}'),
                        SizedBox(height: 20),
                        Text('${user["nip"]}'),
                        SizedBox(height: 10),
                        Text('${user["name"]}'),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.grey[200],
                    ),
                    child:
                        StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                            stream: controller.streamTodayPresence(),
                            builder: (context, snapToday) {
                              if (snapToday.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              }

                              Map<String, dynamic>? dataToday =
                                  snapToday.data?.data();

                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Column(
                                    children: [
                                      Text('Masuk'),
                                      Text(dataToday?['masuk'] == null
                                          ? '--:--'
                                          : "${DateFormat.jms().format(DateTime.parse(dataToday!['masuk']['date']))}"),
                                    ],
                                  ),
                                  Container(
                                    width: 2,
                                    height: 20,
                                    color: Colors.grey,
                                  ),
                                  Column(
                                    children: [
                                      Text("Keluar"),
                                      Text(dataToday?['keluar'] == null
                                          ? '--:--'
                                          : "${DateFormat.jms().format(DateTime.parse(dataToday!['keluar']['date']))}"),
                                    ],
                                  )
                                ],
                              );
                            }),
                  ),
                  SizedBox(height: 20),
                  Divider(
                    color: Colors.grey[300],
                    thickness: 2,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Last 5 days'),
                      TextButton(
                          onPressed: () {
                            Get.toNamed(Routes.ALL_PRESESENSI);
                          },
                          child: Text('See more')),
                    ],
                  ),
                  SizedBox(height: 10),
                  StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                      stream: controller.streamLastPresence(),
                      builder: (context, snapshotPresence) {
                        if (snapshotPresence.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }
                        if (snapshotPresence.data?.docs.length == 0 ||
                            snapshotPresence.data == null) {
                          return SizedBox(
                            height: 150,
                            child: Center(
                              child: Text('Belum ada history presensi'),
                            ),
                          );
                        }
                        print(snapshotPresence.data!.docs);
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: snapshotPresence.data!.docs.length,
                          itemBuilder: (context, index) {
                            print(snapshotPresence);
                            Map<String, dynamic> data =
                                // snapshotPresence.data!.docs[index].data();
                                //reversed disini digunakan untuk memunculkan data yang terbaru dipaling atas
                                snapshotPresence.data!.docs
                                    .toList()[index]
                                    .data();

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: Material(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.grey[200],
                                child: InkWell(
                                  onTap: () {
                                    Get.toNamed(Routes.DETAIL_PRESENSI);
                                  },
                                  borderRadius: BorderRadius.circular(20),
                                  child: Container(
                                    padding: EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text('Masuk'),
                                            Text(
                                                '${DateFormat.yMMMEd().format(DateTime.parse(data['date']))}'),
                                          ],
                                        ),
                                        Text(
                                            '${data['masuk']?['date'] == null ? '--:--' : DateFormat.jms().format(DateTime.parse(data['masuk']!['date']))}'),
                                        SizedBox(height: 10),
                                        Text('Keluar'),
                                        Text(
                                          // '${DateFormat.jms().format(DateTime.parse(data['masuk']?['date']))}'

                                          '${data['keluar']?['date'] == null ? '--:--' : DateFormat.jms().format(DateTime.parse(data['keluar']!['date']))}',
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      })
                ],
              );
            } else {
              return Center(
                child: Text('Tidak dapat memuat data user'),
              );
            }
          }),
      bottomNavigationBar: ConvexAppBar(
        style: TabStyle.fixedCircle,
        items: [
          TabItem(icon: Icons.home, title: 'Home'),
          TabItem(icon: Icons.add, title: 'Add'),
          TabItem(icon: Icons.people, title: 'Profile'),
        ],
        initialActiveIndex: pageC.pageIndex.value, //optional, default as 0
        onTap: (int i) => pageC.changePage(i),
      ),
    );
  }
}
