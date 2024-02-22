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
  /*

      IdentityPass Main Flutter wrapper
      params:
          merchantKey:String
          email: String
          firstName: String?
          lastName: String?
          onCancel: Function
          onVerified: Function
          onError: Function

  */

  static Future<void> showWidget(InputParameters parameters) {
    /*
     show the verification widget

    merchantKet: your public key

    */

    Future<void> onCancelHandler(data) async {
      /*
       dismiss widget modal
    */
      Navigator.pop(parameters.context);
      //Navigator.of(parameters.context, rootNavigator: true).pop();
      parameters.onCancel(data);
    }

    Future<void> onSuccessHandler(data) async {
      /*
       on success verification on widget handler
    */
      Navigator.pop(parameters.context, data);
      parameters.onVerified(data);
    }

    Future<void> onErrorHandler(data) async {
      /*
       error on widget handler
    */
      Navigator.pop(parameters.context);
      //Navigator.of(parameters.context, rootNavigator: false).pop();
      parameters.onError(data);
    }

    return showDialog(
      context: parameters.context,
      builder: (context) {
        /*
        this show the verification widget
        */
        return Scaffold(
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
        ));
      },
    );
  }
}
