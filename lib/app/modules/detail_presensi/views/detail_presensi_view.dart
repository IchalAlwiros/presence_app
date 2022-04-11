import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/detail_presensi_controller.dart';

class DetailPresensiView extends GetView<DetailPresensiController> {
  final Map<String, dynamic> data = Get.arguments;
  @override
  Widget build(BuildContext context) {
    print(data);
    return Scaffold(
        appBar: AppBar(
          title: Text('DetailPresensiView'),
          centerTitle: true,
        ),
        body: ListView(
          padding: EdgeInsets.all(20),
          children: [
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.grey[200],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                      child: Text(
                          '${DateFormat.yMMMMEEEEd().format(DateTime.parse(data['date']))}')),
                  const SizedBox(height: 20),
                  Text('Masuk'),
                  Text(
                      'Jam : ${DateFormat.jms().format(DateTime.parse(data['masuk']!['date']))}'),
                  Text(
                    data['masuk']?['lat'] == null &&
                            data['masuk']?['long'] == null
                        ? "--:--"
                        : 'Posisi: ${data['masuk']!['lat']}, ${data['masuk']!['long']}',
                  ),
                  Text(
                    data['masuk']?['status'] == null
                        ? "--:--"
                        : 'Status: ${data['masuk']!['status']}',
                  ),
                  Text(
                    data['masuk']?['distance'] == null
                        ? "--:--"
                        : 'Jarak: ${data['masuk']!['distance'].toString().split(".").first} meter',
                  ),
                  Text(
                    data['masuk']?['address'] == null
                        ? "--:--"
                        : 'Address: ${data['masuk']!['address']}',
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text('Keluar'),
                  Text(data['keluar']?['date'] == null
                      ? "--:--"
                      : 'Jam : ${DateFormat.jms().format(DateTime.parse(data['keluar']['date']))}'),
                  Text(
                    data['keluar']?['lat'] == null &&
                            data['keluar']?['long'] == null
                        ? "--:--"
                        : 'Posisi: ${data['keluar']!['lat']}, ${data['keluar']!['long']}',
                  ),
                  Text(
                    data['keluar']?['status'] == null
                        ? "--:--"
                        : 'Status: ${data['keluar']!['lat']}',
                  ),
                  Text(
                    data['keluar']?['distance'] == null
                        ? "--:--"
                        : 'Jarak: ${data['masuk']!['distance'].toString().split(".").first} meter',
                  ),
                  Text(
                    data['keluar']?['address'] == null
                        ? "--:--"
                        : 'Address: ${data['masuk']!['address']}',
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
