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
    await Permission.camera.request();

    await Permission.microphone.request();
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const Text('IdentityPass Checkout Test'),
          ),
          body: Center(
            child: FlutterIdentityKyc(
                merchantKey: "your public key here",
                email: "olayiwolakayode078@gmail.com",
                firstName: "kayode",
                lastName: "olayiwola",
                isTest: false,
                userRef: "your user reference",
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
