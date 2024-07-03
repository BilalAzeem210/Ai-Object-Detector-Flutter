
import 'dart:developer';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_tflite/flutter_tflite.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class ScanController extends GetxController {

  @override
  void onInit(){
    super.onInit();
    initCamera();
    initTflite();
  }

  @override
  void dispose(){
    super.dispose();
    cameraController.dispose();
  }

  late CameraController cameraController;
  late List<CameraDescription> cameras;
  var isCameraInitialized = false.obs;
  var cameraCount = 0;
  var x, y, w, h = 0.0;
  var label = "";


  initCamera() async{
    if(await Permission.camera.request().isGranted){
      cameras = await availableCameras();

      cameraController = CameraController(
      cameras[0],
      ResolutionPreset.max
      );
      await cameraController.initialize().then((value){

          cameraController.startImageStream((image){
            cameraCount++;
            if(cameraCount % 10 == 0){
              cameraCount = 0;
              objectDetector(image);
            }
            update();
          });

      });
      isCameraInitialized(true);
      update();
    }
    else{
      if (kDebugMode) {
        print('Permission Is Denied');
      }
    }
  }

  initTflite() async{
    await Tflite.loadModel(
        model: "assets/model.tflite",
        labels: "assets/labels.txt",
        isAsset: true,
        numThreads: 1,
        useGpuDelegate: false
    );
  }

  objectDetector(CameraImage image) async{
    var detector = await Tflite.runModelOnFrame(bytesList: image.planes.map((e){
      return e.bytes;
    }).toList(),
    asynch: true,
    imageHeight: image.height,
    imageWidth: image.width,
    imageStd: 127.5,
    imageMean: 127.5,
    numResults: 1,
    rotation: 90,
    threshold: 0.4,
    );

    if(detector != null){
      var overDetectedObject = detector.first;
     /* if(overDetectedObject['confidenceInClass'] * 100 > 45){
       label = overDetectedObject['detectedClass'].toString();
       h = (overDetectedObject['rect']['h'] ?? 0.0).toDouble();
       w = (overDetectedObject['rect']['w'] ?? 0.0).toDouble();
       x = (overDetectedObject['rect']['x'] ?? 0.0).toDouble();
       y = (overDetectedObject['rect']['y'] ?? 0.0).toDouble();
      }*/
      if (kDebugMode) {
        print(overDetectedObject.toString());
      }
      label = detector.first['label'].toString();



    }

  }

}