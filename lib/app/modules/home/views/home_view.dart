import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:presence_app/app/controllers/page_index_controller.dart';
import 'package:presence_app/app/routes/app_pages.dart';
import 'package:presence_app/app/theme/theme.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  final pageC = Get.find<PageIndexController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'PT KARYA SEJAHTERA',
          style: whiteTextStyle.copyWith(
            fontWeight: semiBold,
          ),
        ),
        backgroundColor: kPrimaryColor,
        centerTitle: true,
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
                  const SizedBox(height: 15),
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
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Welcome',
                            style: blackTextStyle.copyWith(
                              fontSize: 18,
                              fontWeight: semiBold,
                            ),
                          ),
                          Container(
                            width: 200,
                            child: Text(
                              user['address'] != null
                                  ? '${user['address']}'
                                  : "Belum Ada Posisi",
                              textAlign: TextAlign.left,
                              style: blackTextStyle.copyWith(
                                fontWeight: light,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      const Icon(
                        Icons.qr_code_scanner,
                        size: 30.0,
                      ),
                      const SizedBox(width: 30)
                    ],
                  ),
                  const SizedBox(height: 20),
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    height: 130,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          kInactiveColor,
                          kPrimaryColor,
                        ],
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    child: Stack(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Icon(Icons.person, color: kWhiteColor),
                                  const SizedBox(width: 5),
                                  Text(
                                    '${user["name"]}',
                                    style: whiteTextStyle.copyWith(
                                      fontSize: 16,
                                      fontWeight: medium,
                                    ),
                                  )
                                ],
                              ),
                              Text(
                                '${user["job"].toString().capitalize}',
                                style: whiteTextStyle.copyWith(
                                  fontSize: 18,
                                  fontWeight: medium,
                                ),
                              ),
                              Text(
                                '${user["nip"]}',
                                style: whiteTextStyle.copyWith(
                                  fontSize: 14,
                                ),
                              )
                            ],
                          ),
                        ),
                        Positioned(
                          top: 10,
                          left: 90,
                          height: 150,
                          width: MediaQuery.of(context).size.width,
                          child: Image.asset('assets/goal.png'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
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
                                      Text(
                                        'Masuk',
                                        style: blackTextStyle.copyWith(
                                          fontWeight: semiBold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        dataToday?['masuk'] == null
                                            ? '--:--'
                                            : "${DateFormat.jms().format(DateTime.parse(dataToday!['masuk']['date']))}",
                                        style: blackTextStyle.copyWith(
                                          fontWeight: medium,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    width: 2,
                                    height: 20,
                                    color: Colors.grey,
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        "Keluar",
                                        style: blackTextStyle.copyWith(
                                          fontWeight: semiBold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        dataToday?['keluar'] == null
                                            ? '--:--'
                                            : "${DateFormat.jms().format(DateTime.parse(dataToday!['keluar']['date']))}",
                                        style: blackTextStyle.copyWith(
                                          fontWeight: medium,
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              );
                            }),
                  ),
                  const SizedBox(height: 20),
                  Divider(
                    color: Colors.grey[300],
                    thickness: 2,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Last 5 days',
                        style: blackTextStyle.copyWith(
                          fontWeight: semiBold,
                          fontSize: 16,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Get.toNamed(Routes.ALL_PRESESENSI);
                        },
                        child: Text(
                          'See more',
                          style: blueTextStyle.copyWith(
                            fontWeight: medium,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                      stream: controller.streamLastPresence(),
                      builder: (context, snapshotPresence) {
                        if (snapshotPresence.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }
                        if (snapshotPresence.data?.docs.length == 0 ||
                            snapshotPresence.data == null) {
                          return const SizedBox(
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
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.grey[200],
                                child: InkWell(
                                  onTap: () {
                                    Get.toNamed(
                                      Routes.DETAIL_PRESENSI,
                                      arguments: data,
                                    );
                                  },
                                  borderRadius: BorderRadius.circular(10),
                                  child: Container(
                                    padding: EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Masuk',
                                              style: blackTextStyle.copyWith(
                                                  fontWeight: semiBold),
                                            ),
                                            Text(
                                              '${DateFormat.yMMMEd().format(DateTime.parse(data['date']))}',
                                              style: blackTextStyle,
                                            ),
                                          ],
                                        ),
                                        Text(
                                          '${data['masuk']?['date'] == null ? '--:--' : DateFormat.jms().format(DateTime.parse(data['masuk']!['date']))}',
                                          style: blackTextStyle,
                                        ),
                                        const SizedBox(height: 10),
                                        Text('Keluar',
                                            style: blackTextStyle.copyWith(
                                                fontWeight: semiBold)),
                                        Text(
                                          // '${DateFormat.jms().format(DateTime.parse(data['masuk']?['date']))}'

                                          '${data['keluar']?['date'] == null ? '--:--' : DateFormat.jms().format(DateTime.parse(data['keluar']!['date']))}',
                                          style: blackTextStyle,
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
        color: kTifanyColor,
        backgroundColor: kPrimaryColor,
        style: TabStyle.fixedCircle,
        items: [
          TabItem(icon: Icons.home, title: 'Home'),
          TabItem(icon: Icons.qr_code_scanner, title: 'Add'),
          TabItem(icon: Icons.people, title: 'Profile'),
        ],
        initialActiveIndex: pageC.pageIndex.value, //optional, default as 0
        onTap: (int i) => pageC.changePage(i),
      ),
    );
  }
}
