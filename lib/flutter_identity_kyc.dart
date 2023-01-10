import 'package:flutter/material.dart';
import 'widgets/webview.dart';

class FlutterIdentityKyc extends StatefulWidget {
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
          buttonText: Text?
          customButton: ElevatedButton?

  */

  //Merchant public key
  final String merchantKey;

  //user email
  final String email;

  //user first name - optional
  final String? firstName;

  //user last name - optional
  final String? lastName;

  //user reference - optional
  final String? userRef;

  // show modal controller
  final bool showWidget;

  //show button controller
  final bool showButton;

  //on verification cancelled callback
  final Function onCancel;

  //on verification successfull calback
  final Function onVerified;

  // on error callback
  final Function onError;

  //text to appear on button
  final Text? buttonText;

  ///custom button design
  final ElevatedButton? customButton;

  FlutterIdentityKyc(
      {required this.merchantKey,
      required this.email,
      this.firstName,
      this.lastName,
      this.userRef,
      required this.showWidget,
      required this.showButton,
      required this.onCancel(response),
      required this.onVerified(response),
      this.customButton,
      this.buttonText,
      required this.onError(error)});

  @override
  FlutterIdentityKycState createState() => FlutterIdentityKycState();
}

class FlutterIdentityKycState extends State<FlutterIdentityKyc> {
  var triggerWidget = false;

  Future<void> onButtonPress() async {
    /*
       handle button press - this triggers modal
    */
    setState(() => {triggerWidget = !triggerWidget});
  }

  Future<void> dismissModal() async {
    /*
       dismiss widget modal
    */
    setState(() => {triggerWidget = false});
  }

  @override
  Widget build(BuildContext context) {
    // Identity KYC wrapper webview design
    return Scaffold(
        body: (widget.showWidget || triggerWidget)
            ? IdentityKYCWebView(
                merchantKey: widget.merchantKey,
                firstName: widget.firstName,
                lastName: widget.lastName,
                userRef: widget.userRef,
                email: widget.email,
                onCancel: widget.onCancel,
                onError: widget.onError,
                onVerified: widget.onVerified,
                dimissModal: dismissModal)
            // ignore: unnecessary_null_comparison
            : widget.showButton != null
                ? Center(
                    child: ElevatedButton(
                    style: null,
                    onPressed: onButtonPress,
                    child: widget.buttonText != null
                        ? widget.buttonText
                        : Text('Verify My Identity'),
                  ))
                : Container());
  }
}
