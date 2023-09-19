import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:opencv_4/factory/pathfrom.dart';
import 'package:opencv_4/opencv_4.dart';

class ImageToPdfController extends GetxController {
  final picker = ImagePicker();
  var image = <Uint8List>[].obs;
  File? _image;
  Uint8List? _byte;

  @override
  void onInit() {
    super.onInit();
    _getOpenCVVersion();
  }

  Future<void> _getOpenCVVersion() async {
    String? versionOpenCV = await Cv2.version();
    print('OpenCV: ' + versionOpenCV!);
  }

  Future<void> getImageFromSource(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      _image = File(pickedFile.path);
      await applyOpenCVThreshold();
    } else {
      print('No image selected');
    }
  }

  Future<void> applyOpenCVThreshold() async {
    try {
      _byte = await Cv2.threshold(
        pathFrom: CVPathFrom.GALLERY_CAMERA,
        pathString: _image!.path,
        maxThresholdValue: 200,
        thresholdType: Cv2.THRESH_BINARY,
        thresholdValue: 130,
      );
      image.add(_byte!);
    } on PlatformException catch (e) {
      print(e.message);
    }
  }
}
