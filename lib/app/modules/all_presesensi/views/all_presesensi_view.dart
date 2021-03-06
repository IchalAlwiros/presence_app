import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../../routes/app_pages.dart';
import '../../../theme/theme.dart';
import '../controllers/all_presesensi_controller.dart';

class AllPresesensiView extends GetView<AllPresesensiController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: Text(
          'All PRESENSI',
          style: whiteTextStyle.copyWith(
            fontWeight: semiBold,
          ),
        ),
        centerTitle: true,
      ),
      body: GetBuilder<AllPresesensiController>(
        builder: (c) => FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
            future: controller.getAllPresence(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (snapshot.data?.docs.length == 0 || snapshot.data == null) {
                return SizedBox(
                  height: 150,
                  child: Center(
                    child: Text('Belum ada history presesnsi'),
                  ),
                );
              }

              return ListView.builder(
                  padding: EdgeInsets.all(20),
                  physics: BouncingScrollPhysics(),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    Map<String, dynamic> data =
                        snapshot.data!.docs[index].data();
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
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                  });
            }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //sycnfuntion Datepicker
          Get.dialog(Dialog(
            child: Container(
              padding: EdgeInsets.all(20),
              height: 400,
              child: SfDateRangePicker(
                monthViewSettings:
                    DateRangePickerMonthViewSettings(firstDayOfWeek: 1),
                selectionMode: DateRangePickerSelectionMode.range,
                showActionButtons: true,
                onCancel: () => Get.back(),
                onSubmit: (obj) {
                  if (obj != null) {
                    //proses
                    // print(obj);
                    if ((obj as PickerDateRange).endDate != null) {
                      controller.picDate((obj as PickerDateRange).startDate!,
                          (obj as PickerDateRange).endDate!);
                    }
                  }
                },
              ),
            ),
          ));
        },
        child: Icon(Icons.format_list_bulleted_rounded),
      ),
    );
  }
}
