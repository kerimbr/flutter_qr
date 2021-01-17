import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_qr/common_widgets/Bounce.dart';
import 'package:flutter_qr/result_page.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  Barcode result;
  QRViewController controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  bool isOpenFlash = false;

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller.pauseCamera();
    } else if (Platform.isIOS) {
      controller.resumeCamera();
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          _buildQrView(),
          _buildSheet()
        ],
      ),
    );
  }

  Widget _buildSheet() {
    return Expanded(
          flex: 1,
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Bounce(
                      duration: Duration(milliseconds: 200),
                      onPress: (){
                        setState(() {
                          isOpenFlash = !isOpenFlash;
                        });
                        controller.toggleFlash();

                      },
                      child: Container(
                        width: 80,
                        height: 80,
                        child: Icon(
                          isOpenFlash?MaterialCommunityIcons.flash_off:MaterialCommunityIcons.flash_outline,
                          color: Colors.grey.shade200,
                          size: 40,
                        ),
                        decoration: BoxDecoration(
                          color: isOpenFlash?Colors.green:Colors.red,
                          borderRadius: BorderRadius.circular(100)
                        ),
                      ),
                    ),
                    Bounce(
                      onPress: (){
                        controller.flipCamera();
                      },
                      duration: Duration(milliseconds: 200),
                      child: Container(
                        width: 80,
                        height: 80,
                        child: Icon(
                          FlutterIcons.camera_retake_mco,
                          color: Colors.grey.shade200,
                          size: 40,
                        ),
                        decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(100)
                        ),
                      ),
                    )
                  ],
                )

              ],
            ),
          ),
        );
  }

  Widget _buildQrView() {
    var scanArea = (MediaQuery.of(context).size.width < 400 || MediaQuery.of(context).size.height < 400)
        ? 250.0
        : 400.0;
    return Expanded(
          flex: 3,
          child: Container(
            child: QRView(
              key: qrKey,
              cameraFacing: CameraFacing.front,
              onQRViewCreated: _onQRViewCreated,
              formatsAllowed: [BarcodeFormat.qrcode],

              overlay: QrScannerOverlayShape(
                borderColor: Colors.red,
                borderRadius: 10,
                borderLength: 30,
                borderWidth: 10,
                cutOutSize: scanArea,
              ),
            ),
          ),
        );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
      controller.pauseCamera();
      Route r = MaterialPageRoute(
          builder: (context)=>ResultPage(result),
          fullscreenDialog: false
      );
      Navigator.push(context, r).then((value) => controller.resumeCamera());
    });
  }


}
