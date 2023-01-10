import 'package:flutter/material.dart';
import 'package:flutter_identity_kyc/flutter_identity_kyc.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    requestPermissions();
  }

  Future<void> Function() requestPermissions = () async {
    await Permission.camera.request().isGranted;

    await Permission.microphone.request();
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          body: Center(
        child: FlutterIdentityKyc(
            merchantKey: "Enter your merchant public key",
            email: "your user email address",
            firstName: "your user first name",
            lastName: "your user's lastname",
            userRef: "your user reference",
            showWidget: false, // this can be used to control widget visibility
            showButton:
                true, // this determines if the trigger button should show
            onCancel: (response) {
              print(response);
            },
            onVerified: (response) {
              print(response);
            },
            onError: (error) => print(error)),
      )),
    );
  }
}
