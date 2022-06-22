# flutter_identity_kyc

IdentityPass KYC Checkout flutter Wrapper

# Getting Started

Install package by adding  flutter_identity_kyc to your pubspec.yaml file


# KYC Widget
```dart
FlutterIdentityKyc(
    merchantKey: "jywkldnlwoidhlwdknlwo",
    email: "test@test.com",
    firstName: "",
    lastName: "",
    userRef:"unique user ref",
    isTest:false //should be true if you want to run a test
    onCancel: (response) => {print(response)},
    onVerified: (response) => {print(response)},
    onError: (error) => print(error)),
)
```



# Sample implementation
```dart
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
                merchantKey: "",
                email: ",
                firstName: "",
                lastName: "",
                userRef:"",
                isTest:false,
                onCancel: (response) => {print(response)},
                onVerified: (response) => {print(response)},
                onError: (error) => print(error)),
          )),
    );
  }
}
```
