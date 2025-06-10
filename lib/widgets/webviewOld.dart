import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class IdentityKYCWebView extends StatelessWidget {
  final String merchantKey;
  final String email;
  final String? firstName;
  final String? lastName;
  final String? userRef;
  final String config;
  final Function onCancel;
  final Function onVerified;
  final Function onError;

  IdentityKYCWebView({
    required this.merchantKey,
    required this.email,
    required this.config,
    this.firstName,
    this.lastName,
    this.userRef,
    required this.onCancel,
    required this.onVerified,
    required this.onError,
  });

  @override
  Widget build(BuildContext context) {
    InAppWebViewController _webViewController;
    final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

    return new WillPopScope(
      onWillPop: () async => false,
      child: Material(
        type: MaterialType.transparency,
        child: SafeArea(
          child: Navigator(
            key: navigatorKey,
            onGenerateRoute: (settings) {
              return MaterialPageRoute(
                builder: (context) => InAppWebView(
                  onPermissionRequest: (controller, request) async {
                    try {
                      return PermissionResponse(
                          action: PermissionResponseAction.GRANT,
                          resources: [
                            PermissionResourceType.CAMERA_AND_MICROPHONE,
                          ]);
                    } catch (e) {
                      return PermissionResponse(
                          action: PermissionResponseAction.PROMPT,
                          resources: [
                            PermissionResourceType.CAMERA_AND_MICROPHONE,
                          ]);
                    }
                  },
                  initialUrlRequest: URLRequest(
                    url: WebUri(
                      "https://dev.d1gc80n5odr0sp.amplifyapp.com/39a5c5cc-eaa5-4577-9093-3c2acfa1807f",
                    ),
                  ),

                  initialSettings: InAppWebViewSettings(
                    mediaPlaybackRequiresUserGesture: false,
                    allowsInlineMediaPlayback: true,
                  ),

                  onWebViewCreated: (InAppWebViewController controller) {
                    _webViewController = controller;
                    _webViewController.addJavaScriptHandler(
                      handlerName: 'message',
                      callback: (args) {
                        try {
                          // Ensure args is not empty and the first element is a String
                          if (args.isNotEmpty && args[0] is String) {
                            Map response = json.decode(args[0]);
                            if (response.containsKey("event")) {
                              switch (response["event"]) {
                                case "closed":
                                  onCancel({"status": "closed"});
                                  break;
                                case "error":
                                  onError({
                                    "status": "error",
                                    "message": response['message'],
                                  });
                                  break;
                                case "verified":
                                  onVerified({
                                    "status": "success",
                                    "data": response,
                                  });
                                  break;
                                default:
                                  break;
                              }
                            }
                          } else {
                            // Handle cases where args[0] is not a String or args is empty
                            print(
                                "Received non-string data from JavaScript handler: ${args}");
                            // Optionally, call onError or log a specific message for this case
                          }
                        } catch (e) {
                          print("Error decoding JSON from WebView: $e");
                          // Log the raw args[0] for debugging
                          if (args.isNotEmpty) {
                            print("Raw data from WebView: ${args[0]}");
                          }
                          onError({
                            "status": "error",
                            "message":
                                "Failed to process message from WebView: $e",
                          });
                        }
                      },
                    );
                  },
                  onConsoleMessage: (
                    InAppWebViewController controller,
                    ConsoleMessage consoleMessage,
                  ) {
                    print("WEB CONSOLE: ${consoleMessage.message}");
                    print(
                        "WEB CONSOLE SOURCE ID: ${consoleMessage.messageLevel}");
                  },
                  onLoadStop: (controller, url) async {
                    await controller.evaluateJavascript(
                      source: """
      window.addEventListener("message", (event) => {
        window.flutter_inappwebview
            .callHandler('message',event.data);
      }, false);

      // Add this for debugging camera access
      navigator.mediaDevices.getUserMedia({ video: true, audio: true })
        .then(function(stream) {
          console.log('Camera and microphone access granted to web content!');
          // You could even try to display the stream in a video element here for testing
        })
        .catch(function(err) {
          console.error('Error accessing camera/microphone in web content: ' + err.name + ': ' + err.message);
        });
    """,
                    );
                  },
                  androidOnPermissionRequest: (
                    InAppWebViewController controller,
                    String origin,
                    List<String> resources,
                  ) async {
                    return PermissionRequestResponse(
                      resources: resources,
                      action: PermissionRequestResponseAction.GRANT,
                    );
                  },
                  // onLoadStop: (controller, url) async {
                  //   await controller.evaluateJavascript(
                  //     source: """
                  //       window.addEventListener("message", (event) => {
                  //         window.flutter_inappwebview
                  //             .callHandler('message',event.data);
                  //       }, false);
                  //     """,
                  //   );
                  // },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
