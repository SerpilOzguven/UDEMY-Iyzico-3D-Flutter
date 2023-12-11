import 'package:flutter/material.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';
import 'package:iyzico/pages/home_page.dart';

class WebViewPage extends StatelessWidget {
  final htmlCode;
  const WebViewPage({super.key, this.htmlCode});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (){
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const HomePage()),
                (route) => false);
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(title: Text('Payment Page'),backgroundColor: Colors.blue.shade900,),
        body: WebViewPlus(
          javascriptMode: JavascriptMode.unrestricted,
          //initialUrl: 'https://www.google.com/',
          onWebViewCreated: (controller) {
            var page = 'r"""$htmlCode"""';
            controller.loadString(page
            );
          },
        ),
      ),
    );
  }
}

//controller içinden
//r"""
//<html lang="en">
//<body>hello world</body>
//</html>
//"""