import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:presence_app/app/routes/app_pages.dart';
import 'package:presence_app/app/theme/theme.dart';

import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: kPrimaryColor,
          title: Text(
            'LOGIN',
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
              Image.asset("assets/login.png"),
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
              TextFormField(
                controller: controller.passC,
                obscureText: true,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: kPrimaryColor, width: 2.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: kBackgroundColor, width: 2.0),
                  ),
                  labelText: "Password",
                  labelStyle: greyTextStyle.copyWith(fontWeight: light),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              //obx fungsinya spt set state
              Obx(() => ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: kPrimaryColor,
                    ),
                    onPressed: () async {
                      if (controller.isLoading.isFalse) {
                        await controller.login();
                      }
                    },
                    child: Text(
                      controller.isLoading.isFalse ? 'LOGIN' : 'LOADING',
                      style: whiteTextStyle.copyWith(
                        fontWeight: semiBold,
                      ),
                    ),
                  )),
              TextButton(
                onPressed: () {
                  Get.toNamed(Routes.FORGOT_PASSWORD);
                },
                child: Text(
                  'Lupa Password?',
                  style: blueTextStyle,
                ),
              )
            ],
          ),
        ));
  }
}
