import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/detail_presensi_controller.dart';

class DetailPresensiView extends GetView<DetailPresensiController> {
  @override
  Widget build(BuildContext context) {
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
                          '${DateFormat.yMMMMEEEEd().format(DateTime.now())}')),
                  SizedBox(height: 20),
                  Text('Masuk'),
                  Text('Jam : ${DateFormat.jms().format(DateTime.now())}'),
                  Text(
                    'Posisi: -6, 32436',
                  ),
                  Text(
                    'Status: -6, 32436',
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text('Keluar'),
                  Text('Jam : ${DateFormat.jms().format(DateTime.now())}'),
                  Text(
                    'Posisi: -6, 32436',
                  ),
                  Text(
                    'Status: -6, 32436',
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
