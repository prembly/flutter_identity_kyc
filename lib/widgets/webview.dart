import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:http/http.dart' as http; // Import for making HTTP requests

class IdentityKYCWebView extends StatefulWidget {
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
  _IdentityKYCWebViewState createState() => _IdentityKYCWebViewState();
}

class _IdentityKYCWebViewState extends State<IdentityKYCWebView> {
  InAppWebViewController? _webViewController; // Make it nullable
  String? _webViewUrl; // To store the dynamically generated URL
  bool _isLoading = true; // To show loader
  String? _errorMessage; // To show error messages if API call fails

  @override
  void initState() {
    super.initState();
    _initializePremblyWidget();
  }

  Future<void> _initializePremblyWidget() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null; // Clear previous errors
    });

    final String apiUrl =
        'https://api.prembly.com/identitypass/internal/checker/sdk/widget/initialize';

    // Prepare the request body
    final Map<String, dynamic> requestBody = {
      "first_name": widget.firstName ?? "", // Use null-aware operator
      "public_key": widget.merchantKey, // Your merchantKey is the public_key
      "last_name": widget.lastName ?? "", // Use null-aware operator
      "email": widget.email,
      "user_ref": widget.userRef ?? "", // Use null-aware operator
      "config_id": widget.config,
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'accept': '*/*',
          'accept-language': 'en-GB,en-US;q=0.9,en;q=0.8',
          'content-type': 'application/json'
        },
        body: json.encode(requestBody),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData['status'] == true &&
            responseData.containsKey('widget_id')) {
          final String widgetId = responseData['widget_id'];
          setState(() {
            _webViewUrl = "https://dev.d1gc80n5odr0sp.amplifyapp.com/$widgetId";
            _isLoading = false;
          });
        } else {
          // API call successful but response indicates an error or missing widget_id
          setState(() {
            _errorMessage =
                responseData['detail'] ?? 'Failed to get widget ID from API.';
            _isLoading = false;
          });
          widget.onError({"status": "api_error", "message": _errorMessage});
        }
      } else {
        // API call failed with a non-200 status code
        setState(() {
          _errorMessage =
              'API call failed with status: ${response.statusCode}. Response: ${response.body}';
          _isLoading = false;
        });
        widget.onError({"status": "api_error", "message": _errorMessage});
      }
    } catch (e) {
      // Network error or JSON decoding error
      setState(() {
        _errorMessage = 'Network error or data parsing error: $e';
        _isLoading = false;
      });
      widget.onError({"status": "network_error", "message": _errorMessage});
    }
  }

  @override
  Widget build(BuildContext context) {
    // Note: GlobalKey<NavigatorState> is not needed here as we are not pushing/popping routes
    // within this widget's Navigator. The MaterialPageRoute handles it.

    return WillPopScope(
      onWillPop: () async => false, // Prevents popping the route
      child: Material(
        type: MaterialType.transparency,
        child: SafeArea(
          child: _isLoading
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text("Initializing secure session..."),
                    ],
                  ),
                )
              : _errorMessage != null
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.error_outline,
                                color: Colors.red, size: 50),
                            const SizedBox(height: 16),
                            Text(
                              "Error: $_errorMessage",
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  color: Colors.red, fontSize: 16),
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: _initializePremblyWidget,
                              child: const Text("Retry"),
                            ),
                            TextButton(
                              onPressed: () => widget
                                  .onCancel({"status": "error_display_closed"}),
                              child: const Text("Cancel"),
                            ),
                          ],
                        ),
                      ),
                    )
                  : InAppWebView(
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
                        url: WebUri(_webViewUrl!), // Use the generated URL
                      ),
                      initialSettings: InAppWebViewSettings(
                        mediaPlaybackRequiresUserGesture: false,
                        allowsInlineMediaPlayback: true,
                      ),
                      onWebViewCreated: (InAppWebViewController controller) {
                        _webViewController = controller;
                        _webViewController!.addJavaScriptHandler(
                          // Use nullable accessor
                          handlerName: 'message',
                          callback: (args) {
                            try {
                              // Ensure args is not empty and the first element is a String
                              if (args.isNotEmpty && args[0] is String) {
                                Map response = json.decode(args[0]);
                                if (response.containsKey("event")) {
                                  switch (response["event"]) {
                                    case "closed":
                                      widget.onCancel({"status": "closed"});
                                      break;
                                    case "error":
                                      widget.onError({
                                        "status": "error",
                                        "message": response['message'],
                                      });
                                      break;
                                    case "verified":
                                      widget.onVerified({
                                        "status": "success",
                                        "data": response,
                                      });
                                      break;
                                    default:
                                      // Handle unknown events gracefully
                                      print(
                                          "Received unknown event from WebView: ${response['event']}");
                                      break;
                                  }
                                }
                              } else {
                                // Handle cases where args[0] is not a String or args is empty
                                print(
                                    "Received non-string data from JavaScript handler: ${args}");
                                // Optionally, call onError or log a specific message for this case
                                widget.onError({
                                  "status": "error",
                                  "message":
                                      "Received unexpected data type from WebView: $args",
                                });
                              }
                            } catch (e) {
                              print("Error decoding JSON from WebView: $e");
                              // Log the raw args[0] for debugging
                              if (args.isNotEmpty) {
                                print("Raw data from WebView: ${args[0]}");
                              }
                              widget.onError({
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
                        // This JavaScript is for the web page to send messages back to Flutter.
                        // It does NOT initiate camera access. The web page itself must do that.
                        await controller.evaluateJavascript(
                          source: """
                            window.addEventListener("message", (event) => {
                              window.flutter_inappwebview
                                  .callHandler('message', event.data);
                            }, false);
                          """,
                        );

                        // Optional: Add a check for camera access from the web page for debugging
                        // This is just a test to see if the browser API works, not to start the camera itself
                        await controller.evaluateJavascript(
                          source: """
                            navigator.mediaDevices.getUserMedia({ video: true, audio: true })
                              .then(function(stream) {
                                console.log('Camera and microphone access granted to web content!');
                                stream.getTracks().forEach(track => track.stop()); // Stop tracks immediately after testing
                              })
                              .catch(function(err) {
                                console.error('Error accessing camera/microphone in web content via getUserMedia test: ' + err.name + ': ' + err.message);
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
                      // Removed gestureRecognizers as it's typically not needed and can cause issues
                    ),
        ),
      ),
    );
  }
}
