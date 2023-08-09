import 'dart:async';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaystackView extends StatefulWidget {

  static const String id = 'paystack_links_page';

  // String url of the giveaway
  final String authorizationUrl;
  
  const PaystackView({
    Key? key,
    required this.authorizationUrl,
  }) : super(key: key);
  
 

  @override
  _PaystackViewState createState() => _PaystackViewState();
}

class _PaystackViewState extends State<PaystackView> {

  final WebViewController controller = WebViewController()
  ..setJavaScriptMode(JavaScriptMode.unrestricted)
  ..setBackgroundColor(const Color(0x00000000))
  ..setNavigationDelegate(
    NavigationDelegate(
      onProgress: (int progress) {
        // Update loading bar.
      },
      onPageStarted: (String url) {},
      onPageFinished: (String url) {},
      onWebResourceError: (WebResourceError error) {},
      onNavigationRequest: (NavigationRequest request) {
        if (request.url.startsWith('https://www.youtube.com/')) {
          return NavigationDecision.prevent;
        }
        return NavigationDecision.navigate;
      },
    ),
  )
  ..loadRequest(Uri.parse('https://flutter.dev'));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0XFF060D25),
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            size: 20,
            color: Color(0XFF060D25),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Container(
          width: 90,
          child: Image.asset(
            'assets/images/awoof-blue.png',
            fit: BoxFit.contain,
          ),
        ),
        centerTitle: true,
      ),
      body: WebViewWidget(controller: controller,
          ),
      //WebViewWidget(
        // initialUrl: (widget.authorizationUrl != null && widget.authorizationUrl != '' && widget.authorizationUrl.isNotEmpty)
        //     ? widget.authorizationUrl
        //     : 'https://google.com',
        // javascriptMode: JavascriptMode.unrestricted,
        // navigationDelegate: (navigation){
        //   //Listen for callback URL
        //   if(navigation.url.contains("https://www.awoofapp.com/")){
        //     Navigator.pop(context, 'success'); //close webview
        //   }
        //   if(navigation.url.contains('https://standard.paystack.co/close')){
        //     Navigator.pop(context, 'success'); //close webview
        //   }
        //   return NavigationDecision.navigate;
        // },
        // onWebViewCreated: (WebViewController webViewController){
        //   _controller.complete(webViewController);
        // },
      //),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromRGBO(51, 210, 107, 1),
        tooltip: 'Contact us if you\'re having trouble paying',
        child: Image.asset(
          'assets/images/whatsapp.png',
          width: 32,
        ),
        onPressed: () {
          _launchWhatsapp();
        },
      ),
    );
  }

  /// Function to call a number using the [url_launcher] package
  _launchWhatsapp() async {
    const url = 'https://wa.me/message/DHLAOBH2RPOSD1';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch the url';
    }
  }

}
