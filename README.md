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


# Requirement
# Android

Add the following permission to your android "AndroidManifest.xml" file
```xml
  <uses-permission android:name="android.permission.CAMERA" />
  <uses-permission android:name="android.permission.RECORD_AUDIO" />
  <uses-permission android:name="android.permission.VIDEO_CAPTURE" />
```

# IOS

Add the following permission to your android "info.plist" file
```plist
    <key>NSPhotoLibraryUsageDescription</key>
    <string>App needs access to photo lib for profile images</string>
    <key>NSCameraUsageDescription</key>
    <string>To capture profile photo please grant camera access</string>
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
