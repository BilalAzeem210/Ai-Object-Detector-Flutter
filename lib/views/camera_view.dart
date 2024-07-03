import 'package:ai_object_detector/controller/scan_controller.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class CameraView extends StatelessWidget {
  const CameraView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<ScanController>(
        init: ScanController(),
        builder: (controller) {
          return controller.isCameraInitialized.value ?
          Column(
            children: [
              CameraPreview(controller.cameraController),
               const SizedBox(height: 20,),
               Center(child: Text(controller.label.toString(),style: const TextStyle(
                 color: Colors.black,
                 fontSize: 18,
                 fontWeight: FontWeight.w500
               ),),),
            ],
          ) :
           const Center(child: Text('Loading Preview...'));
        }
      ),
    );
  }
}
