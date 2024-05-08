import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:rive/rive.dart';

class LoginViewModel extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();

  RxBool isInitialized = false.obs;
  String animationLink = 'images/login-bear.riv';
  SMITrigger? failTrigger, successTrigger;
  SMIBool? isHandsUp, isChecking;
  SMINumber? lookNum;
  Artboard? artBoard;

  @override
  void onReady() {
    setArtBoard();
    super.onReady();
  }

  void setArtBoard() async {
    ByteData data = await rootBundle.load(animationLink);
    Artboard art = RiveFile.import(data).mainArtboard;
    StateMachineController? controller =
        StateMachineController.fromArtboard(art, "Login Machine");

    if (controller != null) {
      art.addController(controller);

      for (var element in controller.inputs) {
        if (element.name == "isChecking") {
          isChecking = element as SMIBool;
        } else if (element.name == "isHandsUp") {
          isHandsUp = element as SMIBool;
        } else if (element.name == "trigSuccess") {
          successTrigger = element as SMITrigger;
        } else if (element.name == "trigFail") {
          failTrigger = element as SMITrigger;
        } else if (element.name == "numLook") {
          lookNum = element as SMINumber;
        }
      }
    }

    artBoard = art;
     isInitialized.value = true;
  }

  @override
  void onClose() {
    emailController.dispose();
    passController.dispose();
    super.onClose();
  }

  void lookAround() {
    isChecking?.change(true);
    isHandsUp?.change(false);
    lookNum?.change(0);
  }

  onTapOutSide() {
    FocusScope.of(Get.context!).requestFocus(FocusNode());
    isChecking?.change(false);
    isHandsUp?.change(false);
    lookNum?.change(0);
  }

  void moveEyes(value) {
    lookNum?.change(value.length.toDouble() * 2.5);
  }

  void handsUpOnEyes() {
    isHandsUp?.change(true);
    isChecking?.change(false);
  }

  void loginClick() {
    isChecking?.change(false);
    isHandsUp?.change(false);
    lookNum?.change(0);
    if (emailController.text == "mohsin@gmail.com" &&
        passController.text == "123456") {
      successTrigger?.fire();
    } else {
      failTrigger?.fire();
    }
  }
}
