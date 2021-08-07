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
  final String firstName;

  //user last name - optional
  final String lastName;

  //on verification cancelled callback
  final Function onCancel;

  //on verification successfull calback
  final Function onVerified;

  // on error callback
  final Function onError;

  //text to appear on button
  final Text buttonText;

  ///custom button design
  final ElevatedButton customButton;

  FlutterIdentityKyc(
      {@required this.merchantKey,
      @required this.email,
      this.firstName,
      this.lastName,
      @required this.onCancel(response),
      @required this.onVerified(response),
      this.customButton,
      this.buttonText,
      @required this.onError(error)});

  @override
  FlutterIdentityKycState createState() => FlutterIdentityKycState();
}

class FlutterIdentityKycState extends State<FlutterIdentityKyc> {
  void showModal() {
    /*
       pass data to modal and display webview component
    */

    Navigator.of(context).push(IdentityKYCWebView(
        merchantKey: widget.merchantKey,
        firstName: widget.firstName,
        lastName: widget.lastName,
        email: widget.email,
        onCancel: widget.onCancel,
        onError: widget.onError,
        onVerified: widget.onVerified));
  }

  @override
  Widget build(BuildContext context) {
    // Identity KYC wrapper webview design
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          style: null,
          onPressed: showModal,
          child: widget.buttonText != null
              ? widget.buttonText
              : Text('Verify My Identity'),
        ),
      ),
    );
  }
}
