import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:presence_app/app/theme/theme.dart';

import '../controllers/forgot_password_controller.dart';

class ForgotPasswordView extends GetView<ForgotPasswordController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: Text(
          'RESET PASWWORD',
          style: whiteTextStyle.copyWith(
            fontWeight: semiBold,
          ),
        ),
        centerTitle: true,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: ListView(
          padding: EdgeInsets.all(20),
          children: [
            TextFormField(
              controller: controller.emailC,
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: kPrimaryColor, width: 2.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: kBackgroundColor, width: 2.0),
                ),
                labelText: "Email",
                labelStyle: greyTextStyle.copyWith(fontWeight: light),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Obx(() => ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: kPrimaryColor,
                  ),
                  onPressed: () {
                    if (controller.isLoading.isFalse) {
                      controller.sendEmail();
                    }
                  },
                  child: Text(
                    controller.isLoading.isFalse ? 'SEND EMAIL' : 'LOADING..',
                    style: whiteTextStyle.copyWith(fontWeight: semiBold),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
