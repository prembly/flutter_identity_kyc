import 'package:flutter/material.dart';
import 'package:flutter_identity_kyc/widgets/webview.dart';

class InputParameters {
  //context
  BuildContext context;

  //Merchant public key
  final String merchantKey;

  //user email
  final String email;

  final String config;

  //user first name - optional
  final String? firstName;

  //user last name - optional
  final String? lastName;

  //user reference - optional
  final String? userRef;

  //on verification cancelled callback
  final Function onCancel;

  //on verification successfull calback
  final Function onVerified;

  // on error callback
  final Function onError;

  InputParameters(
      {required this.context,
      required this.merchantKey,
      required this.email,
      required this.firstName,
      required this.lastName,
      required this.userRef,
      required this.config,
      required this.onCancel,
      required this.onVerified,
      required this.onError});
}

class FlutterIdentityKyc {
  // Add a GlobalKey to maintain a reference to the ScaffoldState
  static final GlobalKey<ScaffoldState> scaffoldKey =
      GlobalKey<ScaffoldState>();

  static Future<void> showWidget(InputParameters parameters) async {
    Future<void> onCancelHandler(data) async {
      // Dismiss widget modal by popping the Navigator
      Navigator.pop(scaffoldKey.currentContext!);
      parameters.onCancel(data);
    }

    Future<void> onSuccessHandler(data) async {
      // On success verification on widget handler
      Navigator.pop(scaffoldKey.currentContext!, data);
      parameters.onVerified(data);
    }

    Future<void> onErrorHandler(data) async {
      // Error on widget handler
      Navigator.pop(scaffoldKey.currentContext!);
      parameters.onError(data);
    }

    return showDialog(
      context: parameters.context,
      builder: (context) {
        // Assign the GlobalKey to the Scaffold
        return Scaffold(
          key: scaffoldKey,
          body: IdentityKYCWebView(
            merchantKey: parameters.merchantKey,
            firstName: parameters.firstName,
            lastName: parameters.lastName,
            userRef: parameters.userRef,
            email: parameters.email,
            config: parameters.config,
            onCancel: onCancelHandler,
            onError: onErrorHandler,
            onVerified: onSuccessHandler,
          ),
        );
      },
    );
  }
}
