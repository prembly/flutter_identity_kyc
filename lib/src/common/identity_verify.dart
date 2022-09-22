part of '../../flutter_identity_kyc.dart';

class IdentityVerify {

  @visibleForTesting
  static VerificationPlatform? delegateInitializerProperty;

  String? get key => delegateInitializerProperty?.key;

  static IdentityVerify get instance {
    return IdentityVerify._();
  }

  static VerificationPlatform get _delegate {
    return delegateInitializerProperty ??= VerificationPlatform.instance;
  }

  static Future<dynamic> initializeInterface({
    String? name,
    String? publicKey
  }) async {
    VerificationPlatform _app = await _delegate.initializeInterface(
      name: name,
      publicKey: publicKey
    );

    return IdentityVerify._(app: _app);
  }

  /// Call [verifyIdentity] function and supply the neccessary data for verification
  ///
  /// All fields are required except for testing feld which is set as false initially
  ///
  Future<dynamic> verifyIdentity(
      BuildContext context,
      {
        required String email,
        required String firstName,
        required String lastName,
        required String userRef,
        bool? testing = false,
        required Function onCancel,
        required Function onVerify,
        required Function onError,
  }) async {

    _checkInitialization();

    _checkEmailValidation(email);

    bool _permission = await _checkCameraPermission();

    if(!_permission) return throw VerificationException('Camera permission not allowed');

    Widget _nextScreen = IdentityKYCWebView(
      merchantKey: (delegateInitializerProperty?.publicKey)!,
      firstName: firstName,
      lastName: lastName,
      userRef: userRef,
      isTest: testing,
      email: email,
      onCancel: onCancel,
      onError: onError,
      onVerified: onVerify,
    );

    (Platform.isIOS) ?
    showCupertinoModalBottomSheet(
      context: context,
      bounce: true,
      enableDrag: true,
      duration: Duration(microseconds: 500),
      topRadius: Radius.circular(20),
      builder: (context) => _nextScreen,
    ) : showMaterialModalBottomSheet(
      context: context,
      bounce: true,
      enableDrag: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      duration: Duration(microseconds: 500),
      builder: (context) => _nextScreen,
    );
  }

  void callKey() {  }

  _checkEmailValidation(String email) {
    RegExp myReg = RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
    if (email.trim().isEmpty) return throw VerificationException('Email Address cannot be empty');
    if (email.trim().length < 5) return throw VerificationException('Email Address cannot be this short');
    if (!myReg.hasMatch(email.trim())) return throw VerificationException('The email supplied is invalid');
  }


  _checkInitialization() {
    if(delegateInitializerProperty?.publicKey == null) throw NotInitializeException('Sdk has not been initialized');
  }

  Future<bool> _checkCameraPermission() async {
    if (await Permission.camera.request().isGranted) {
      debugPrint('CAMERA PERMISSION GRANTEDDD');
      return true;
    } else {
      PermissionStatus _request = await Permission.camera.request();
      if (await Permission.camera.isPermanentlyDenied) {
        openAppSettings();
      }

      return _request.isGranted;
    }
  }

  IdentityVerify._({VerificationPlatform? app});
}