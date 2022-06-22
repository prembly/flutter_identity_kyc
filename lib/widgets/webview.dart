import 'dart:async';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:convert';

class IdentityKYCWebView extends ModalRoute {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  final String merchantKey;

  final String email;

  final String firstName;

  final String lastName;

  final String userRef;

  final bool isTest;

  final Function onCancel;

  final Function onVerified;

  final Function onError;

  IdentityKYCWebView(
      {@required this.merchantKey,
      @required this.email,
      this.firstName,
      this.lastName,
      this.userRef,
      this.isTest,
      @required this.onCancel,
      @required this.onVerified,
      @required this.onError});

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return Material(
      type: MaterialType.transparency,
      child: SafeArea(
        child: WebView(
          initialUrl: Uri.dataFromString(
                  '<html lang="en"><head> \n\n' +
                      '                        <meta charset="UTF-8">\n' +
                      '<meta http-equiv="cache-control" content="max-age=0" /><meta http-equiv="cache-control" content="no-cache" />/n' +
                      '                        <meta http-equiv="X-UA-Compatible" content="ie=edge">\n' +
                      '                        <title>Identity Pass</title>\n' +
                      '                </head>\n' +
                      '                      <body  onload="verifyKYC()" style="background-color:#fff;height:100vh ">\n' +
                      '                        <script src="https://js.myidentitypay.com/v1/inline/kyc.js"></script>\n' +
                      '                        \n' +
                      '                          <script type="text/javascript">\n' +
                      '                                window.onload = verifyKYC;\n' +
                      '                                function verifyKYC(){\n' +
                      '\n' +
                      '                                    var paymentEngine =  IdentityKYC.verify({\n' +
                      '                                        merchant_key: "$merchantKey",\n' +
                      '                                        first_name: "$firstName}",\n' +
                      '                                        last_name: "$lastName}",\n' +
                      '                                        email: "$email",\n' +
                      '                                        user_ref: "$userRef",\n' +
                      '                                        is_test: $isTest,\n' +
                      '                                        callback: function (response) {\n' +
                      '                                           console.log("callback Response", response); \n' +
                      '                                           if(response.status =="success"){\n' +
                      '                                            var response_data = {event:"verified", data:response};\n' +
                      '                                            Print.postMessage(JSON.stringify(response_data))\n' +
                      '                                           }\n' +
                      '                                           else if(response.code == "E01"){\n' +
                      '                                            var response_data = {event:"closed"};\n' +
                      '                                            Print.postMessage(JSON.stringify(response_data))\n' +
                      '                                           }\n' +
                      '                                           else{\n' +
                      '                                            var response_data = {event:"error",message:response.message};\n' +
                      '                                            Print.postMessage(JSON.stringify(response_data))\n' +
                      '                                           }\n' +
                      '                                      },\n' +
                      '                                    })\n' +
                      '                                }\n' +
                      ' \n' +
                      '                        </script> \n' +
                      '                </body>\n' +
                      '        </html> ',
                  mimeType: 'text/html')
              .toString(),
          javascriptMode: JavascriptMode.unrestricted,
          javascriptChannels: Set.from([
            JavascriptChannel(
                name: 'Print',
                onMessageReceived: (JavascriptMessage message) {
                  //This is where you receive message from

                  var response = json.decode(message.message);
                  switch (response["event"]) {
                    case "closed":
                      onCancel({"status": "closed"});
                      Navigator.pop(context);
                      break;
                    case "error":
                      onError({"status": "error", "message": response.message});
                      Navigator.pop(context);
                      break;
                    case "verified":
                      onVerified({
                        "status": "success",
                        "data": response,
                      });
                      Navigator.pop(context);
                      break;
                    default:
                      break;
                  }
                })
          ]),
          onWebViewCreated: (WebViewController webViewController) {
            _controller.complete(webViewController);
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          gestureNavigationEnabled: true,
        ),
      ),
    );
  }

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => true;

  @override
  Color get barrierColor => Colors.black.withOpacity(0.5);

  @override
  String get barrierLabel => "test";

  @override
  bool get maintainState => true;

  @override
  Duration get transitionDuration => Duration(milliseconds: 500);
}
