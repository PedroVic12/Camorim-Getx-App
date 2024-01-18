import 'dart:async';

import 'package:camorim_getx_app/widgets/customText.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoadingController extends GetxController {
  RxInt segundos = 0.obs;
  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    _startTimer();
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      segundos++;
      update();
    });
  }
}

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoadingController());

    //print(controller.segundos);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: Container(
          height: 120,
          width: 120,
          margin: const EdgeInsets.all(24),
          color: Colors.green,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Obx(() => CustomText(
                    text: 'Carregando... ${controller.segundos} s',
                    //text: 'Carregando...',
                    size: 12,
                    color: Colors.white,
                  )),
              CircularProgressIndicator(color: Colors.greenAccent),
              Icon(
                Icons.cloud_upload_rounded,
                color: Colors.white,
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
