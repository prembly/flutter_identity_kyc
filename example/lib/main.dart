import 'package:flutter/material.dart';
import 'package:flutter_identity_kyc/flutter_identity_kyc.dart';

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
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const Text('IdentityPass Checkout Test'),
          ),
          body: Center(
            child: FlutterIdentityKyc(
                merchantKey: "rvnn3i5HOQetA6HcLqKw",
                email: "olayiwolakayode078@gmail.com",
                firstName: "kayode",
                lastName: "olayiwola",
                onCancel: (response) => {print(response)},
                onVerified: (response) => {print(response)},
                onError: (error) => print(error)),
          )),
    );
  }
}
