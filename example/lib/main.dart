import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_identity_kyc/flutter_identity_kyc.dart';
import 'package:permission_handler/permission_handler.dart';

final IdentityVerify identityVerify = IdentityVerify.instance;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) async {
        // TODO: Fetch and put your identitypass public api key here
        await IdentityVerify.initializeInterface(publicKey: '<Merchant Public Api Key Here>');
        runApp(new MyApp());
      },
  );
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
      title: 'Identitypass Test App',
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('IdentityPass Checkout Test'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => identityVerify.verifyIdentity(
                  context,
                  email: 'example@gmail.com',
                  firstName: 'Test',
                  lastName: 'Test 1',
                  userRef: 'userGeneratedRef',
                  onCancel: (response) {
                    print(response);
                  },
                  onVerify: (response) {
                    print(response);
                  },
                  onError: (error) => print(error),
                ),
                child: Text('Verify Identity'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

