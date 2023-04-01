import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:news_app/model/news_model.dart';

class NewsDetails extends StatefulWidget {
  NewsDetails({Key? key, this.articles}) : super(key: key);
  Articles? articles;

  @override
  State<NewsDetails> createState() => _NewsDetailsState();
}

class _NewsDetailsState extends State<NewsDetails> {
  Future<void> share() async {
    await FlutterShare.share(
        title: 'Example share',
        linkUrl: '${widget.articles!.url}',
        chooserTitle: 'Example Chooser Title');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.articles!.author}"),
        actions: [
          IconButton(
              onPressed: () {
                share();
              },
              icon: Icon(Icons.share))
        ],
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              CachedNetworkImage(
                height: 300,
                imageUrl: "${widget.articles!.urlToImage}",
                width: double.infinity,
                fit: BoxFit.fill,
                placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => Image.network(
                  "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTOmYqa4Vpnd-FA25EGmYMiDSWOl9QV8UN1du_duZC9mQ&s",
                  width: double.infinity,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: ListView(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    Text("${widget.articles!.title}"),
                    Divider(),
                    Text("${widget.articles!.description}"),
                    Divider(),
                    Text("${widget.articles!.content}"),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
