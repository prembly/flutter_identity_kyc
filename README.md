# flutter_identity_kyc

IdentityPass KYC Checkout flutter Wrapper

# Getting Started

Install package by adding flutter_identity_kyc to your pubspec.yaml file

## Setup

## Android

To setup this project for android follow these steps:

#### 1. Add the following to your "gradle.properties" file:

```dart
    android.useAndroidX=true
    android.enableJetifier=true
```

#### 2. Make sure you set the compileSdkVersion in your "android/app/build.gradle" file to 31:

```dart
    android {
      compileSdkVersion 31

      ...
    }
```

#### 3. Add the following permission to your android "AndroidManifest.xml" file

```xml
     <uses-permission android:name="android.permission.CAMERA" />
     <uses-permission android:name="android.permission.RECORD_AUDIO" />
     <uses-permission android:name="android.permission.VIDEO_CAPTURE" />
```

## iOS

<!-- 1. To setup this project for iOS follow add the following to the `Info.plist`: -->

<!-- ```plist -->
<!--     <key>NSPhotoLibraryUsageDescription</key> -->
<!--     <string>App needs access to photo lib for profile images</string> -->
<!--     <key>NSCameraUsageDescription</key> -->
<!--     <string>To capture profile photo please grant camera access</string> -->
<!-- ``` -->

#### 1. Add the following to your Podfile file:

```dart
    post_install do |installer|
      installer.pods_project.targets.each do |target|
        flutter_additional_ios_build_settings(target)

         target.build_configurations.each do |config|
          # ## dart: PermissionGroup.camera
          # 'PERMISSION_CAMERA=1'
          #
          #  Preprocessor definitions can be found in: https://github.com/Baseflow/flutter-permission-handler/blob/master/permission_handler_apple/ios/Classes/PermissionHandlerEnums.h
          config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] ||= [
            '$(inherited)',
            ## dart: PermissionGroup.camera
            'PERMISSION_CAMERA=1',

            ## dart: PermissionGroup.photos
            'PERMISSION_PHOTOS=1',
          ]

        end
        # End of the permission_handler configuration
      end
    end
```


## Dart/Flutter

#### 1. To initiate the plugin, call the plugin instance in your main.dart


```dart
    final IdentityVerify identityVerify = IdentityVerify.instance;

    Future<void> main() async {
      WidgetsFlutterBinding.ensureInitialized();
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
          .then((_) async {
            // TODO: Fetch and put your identitypass public api key here
            await IdentityVerify.initializeInterface(publicKey: '<MERCHANT PUBLIC KEY HERE>');
            runApp(new MyApp());
          },
      );
    }

    ...

```

#### 2. Call the identitypass kyc verification method and pass the necessary data to it

```dart
    identityVerify.verifyIdentity(
      context,
      email: 'email@example.com',
      firstName: 'John',
      lastName: 'Doe',
      // TODO: Fetch and add a unique user generated reference here
      userRef: '<USER GENERATED REF HERE>',
      onCancel: (response) => print(response),
      onVerify: (response) => print(response),
      onError: (error) => print(error),
    ),
```


## Usage on sample button
Just call the verifyIdentity method from your any of your favorite button widget

```dart
   ElevatedButton(
      onPressed: () => identityVerify.verifyIdentity(
          context,
          email: 'email@example.com',
          firstName: 'John',
          lastName: 'Doe',
          userRef: 'XPxvDi0wRwtf092v',
          onCancel: (response) => print(response),
          onVerify: (response) => print(response),
          onError: (error) => print(error),
      ),
      child: Text('Verify Identity'),
   ),
```