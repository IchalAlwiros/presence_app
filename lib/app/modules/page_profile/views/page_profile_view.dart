import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:presence_app/app/controllers/page_index_controller.dart';
import 'package:presence_app/app/routes/app_pages.dart';

import '../../../theme/theme.dart';
import '../controllers/page_profile_controller.dart';

class PageProfileView extends GetView<PageProfileController> {
  final pageC = Get.find<PageIndexController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'PROFILE',
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
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasData) {
              //Untuk Mendapatkan data Map dari snapshot.data
              Map<String, dynamic> user = snapshot.data!.data()!;
              String defaultImage =
                  "https://ui-avatars.com/api/?name=${user['name']}";
              return ListView(
                padding: EdgeInsets.all(20),
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ClipOval(
                        child: Container(
                          height: 100,
                          width: 100,
                          child: Image.network(
                            user['profile'] != null
                                ? user['profile'] != ""
                                    ? user['profile']
                                    : defaultImage
                                : defaultImage,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      const SizedBox(height: 10),
                      Text(
                        user['name'].toString().toUpperCase(),
                        style: blackTextStyle.copyWith(
                          fontWeight: semiBold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        '${user['job'].toString().capitalizeFirst}',
                        style: blackTextStyle.copyWith(
                          fontWeight: medium,
                        ),
                      ),
                      Text(
                        '${user['email']}',
                        style: blackTextStyle.copyWith(
                          fontWeight: medium,
                        ),
                      ),
                      Text(
                        'NIP : ${user['nip']}',
                        style: blackTextStyle.copyWith(
                          fontWeight: medium,
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                  ListTile(
                    onTap: () {
                      Get.toNamed(
                        Routes.UPDATE_PROFILE,
                        arguments: user,
                      );
                    },
                    leading: Icon(Icons.person, color: kPrimaryColor),
                    title: Text(
                      'Update Profile',
                      style: blackTextStyle.copyWith(
                        fontWeight: medium,
                      ),
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      Get.toNamed(Routes.UPDATE_PASSWORD);
                    },
                    leading: Icon(Icons.key, color: kPrimaryColor),
                    title: Text(
                      'Update Password',
                      style: blackTextStyle.copyWith(
                        fontWeight: medium,
                      ),
                    ),
                  ),
                  if (user['role'] == 'admin')
                    ListTile(
                      onTap: () {
                        Get.toNamed(Routes.ADD_PEGAWAI);
                      },
                      leading: Icon(
                        Icons.person_add,
                        color: kPrimaryColor,
                      ),
                      title: Text(
                        'Add Pegawai',
                        style: blackTextStyle.copyWith(
                          fontWeight: medium,
                        ),
                      ),
                    ),
                  ListTile(
                    onTap: () {
                      controller.logout();
                    },
                    leading: Icon(Icons.logout, color: kPrimaryColor),
                    title: Text(
                      'Logout',
                      style: blackTextStyle.copyWith(
                        fontWeight: medium,
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return Center(
                child: Text('Tidak Dapat memuat data user'),
              );
            }
          }),
      bottomNavigationBar: ConvexAppBar(
        color: kTifanyColor,
        backgroundColor: kPrimaryColor,
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
