import 'package:flutter/material.dart';
import 'package:news_app/model/news_model.dart';
import 'package:news_app/provider/news_provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewDetails extends StatefulWidget {
  WebViewDetails({Key? key, this.articles}) : super(key: key);

  Articles? articles;

  @override
  State<WebViewDetails> createState() => _WebViewDetailsState();
}

NewsProvider? newsProvider;

class _WebViewDetailsState extends State<WebViewDetails> {
  late WebViewController controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setBackgroundColor(const Color(0x00000000))
    ..loadRequest(Uri.parse(widget.articles!.url.toString()));

  double progress = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("${widget.articles!.source!.name}"),
        ),
        body: Container(
          width: double.infinity,
          padding: EdgeInsets.all(0),
          child: Column(
            children: [
              Expanded(
                  child: WebViewWidget(
                controller: controller,
              ))
            ],
          ),
        ));
  }
}
