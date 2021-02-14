import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:webview_flutter/webview_flutter.dart';

BuildContext globalContext;

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    globalContext = context;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyApp(),
    );
  }
}

class MyApp extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<MyApp> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  WebViewController controllerGlobal;

  _exitApp(BuildContext context, Future<WebViewController> controller) async {
    controller.then((data) async {
      WebViewController controller = data;
      var goback = await controller.canGoBack();
      if (goback == true) {
        controller.goBack();
      } else {
        SystemNavigator.pop();
      }
    });
  }

  bool isLoading;
  @override
  void initState() {
    super.initState();
    isLoading = true;
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _exitApp(context, _controller.future),
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              WebView(
                initialUrl: 'https://davu.in',
                javascriptMode: JavascriptMode.unrestricted,
                onPageFinished: (_) {
                  setState(() {
                    isLoading = false;
                  });
                },
                onWebViewCreated: (WebViewController webviewController) {
                  _controller.complete(webviewController);
                },
              ),
              isLoading
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/logo.png',
                          width: 150,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          'దావు కి స్వాగతం',
                          style: TextStyle(
                            color: Colors.orange[900],
                            fontSize: 34,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Center(
                          child: CircularProgressIndicator(),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'App is loading...',
                          style: TextStyle(
                            color: Colors.blue[900],
                            fontSize: 20,
                          ),
                        ),
                      ],
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
