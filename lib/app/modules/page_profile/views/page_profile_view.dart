import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/page_profile_controller.dart';

class PageProfileView extends GetView<PageProfileController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('PROFILE'),
          centerTitle: true,
        ),
        body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            stream: controller.streamUser(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.hasData) {
                //Map<String, dynamic> user = snapshot.data!.data()!;
                Map<String, dynamic> user = snapshot.data!.data()!;
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
                              "https://ui-avatars.com/api/?name=${user['name']}",
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Text(user['name'].toString().toUpperCase()),
                    Text('${user['email']}'),
                    Text('NIP : ${user['nip']}'),
                    Text('${user['']}'),
                    SizedBox(height: 20),
                    ListTile(
                      onTap: () {},
                      leading: Icon(Icons.person),
                      title: Text('Update Profile'),
                    ),
                    ListTile(
                      onTap: () {},
                      leading: Icon(Icons.key),
                      title: Text('Update Password'),
                    ),
                    if (user['role'] == 'admin')
                      ListTile(
                        onTap: () {},
                        leading: Icon(Icons.logout),
                        title: Text('Add Pegawai'),
                      ),
                    ListTile(
                      onTap: () {
                        controller.logout();
                      },
                      leading: Icon(Icons.logout),
                      title: Text('Logout'),
                    ),
                  ],
                );
              } else {
                return Center(
                  child: Text('Tidak Dapat memuat data user'),
                );
              }
            }));
  }
}
