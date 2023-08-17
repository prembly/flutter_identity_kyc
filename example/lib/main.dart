import 'package:flutter/material.dart';
import 'package:flutter_identity_kyc/flutter_identity_kyc.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(MaterialApp(home: MyApp()));
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
                child: ElevatedButton(
      style: null,
      onPressed: () {
        FlutterIdentityKyc.showWidget(InputParameters(
            context: context,
            merchantKey: "",
            firstName: "",
            lastName: "",
            email: "",
            userRef: "",
            config: "",
            onCancel: (response) {
              print(response);
            },
            onVerified: (response) {
              print(response);
            },
            onError: (error) => print(error)));
      },
      child: Text('Verify My Identity'),
    ))));
  }
}
