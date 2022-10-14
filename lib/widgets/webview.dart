import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class IdentityKYCWebView extends ModalRoute {
  final String merchantKey;

  final String email;

  final String? firstName;

  final String? lastName;

  final String? userRef;

  final bool? isTest;

  final Function onCancel;

  final Function onVerified;

  final Function onError;

  IdentityKYCWebView(
      {required this.merchantKey,
      required this.email,
      this.firstName,
      this.lastName,
      this.userRef,
      this.isTest,
      required this.onCancel,
      required this.onVerified,
      required this.onError});

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    InAppWebViewController _webViewController;

    return new WillPopScope(
      onWillPop: () async => false,
      child: Material(
        type: MaterialType.transparency,
        child: SafeArea(
          child: InAppWebView(
            initialUrlRequest: URLRequest(
                url: Uri.parse(
                    "https://mobile-kyc.myidentitypass.com?merchantKey=" +
                        merchantKey +
                        "&firstName=" +
                        firstName! +
                        "&lastName=" +
                        lastName! +
                        "&email=" +
                        email +
                        "&user_ref=" +
                        userRef! +
                        "&isTest=" +
                        isTest.toString())),
            initialOptions: InAppWebViewGroupOptions(
              crossPlatform: InAppWebViewOptions(
                mediaPlaybackRequiresUserGesture: false,
              ),
              ios: IOSInAppWebViewOptions(allowsInlineMediaPlayback:true)
            ),
            onWebViewCreated: (InAppWebViewController controller) {
              _webViewController = controller;

              _webViewController.addJavaScriptHandler(
                handlerName: 'message',
                callback: (args) {
                  try {
                    Map response = json.decode(args[0]);
                    if (response.containsKey("event")) {
                      switch (response["event"]) {
                        case "closed":
                          onCancel({"status": "closed"});
                          Navigator.pop(context);
                          break;
                        case "error":
                          onError({
                            "status": "error",
                            "message": response['message']
                          });
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
                    }
                  } catch (e) {}
                },
              );
            },
            androidOnPermissionRequest: (InAppWebViewController controller,
                String origin, List<String> resources) async {
              return PermissionRequestResponse(
                  resources: resources,
                  action: PermissionRequestResponseAction.GRANT);
            },
            onLoadStop: (controller, url) async {
              await controller.evaluateJavascript(source: """
              window.addEventListener("message", (event) => {
                window.flutter_inappwebview
                      .callHandler('message',event.data);
              }, false);
            """);
            },
            onConsoleMessage: (InAppWebViewController controller,
                ConsoleMessage consoleMessage) {},
          ),
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
  String get barrierLabel => "identitypass";

  @override
  bool get maintainState => true;

  @override
  Duration get transitionDuration => Duration(milliseconds: 500);
}
