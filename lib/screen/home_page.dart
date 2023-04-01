import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:news_app/http/custome_http.dart';
import 'package:news_app/model/news_model.dart';
import 'package:news_app/provider/news_provider.dart';
import 'package:news_app/screen/news_details.dart';
import 'package:news_app/screen/search_screen.dart';
import 'package:news_app/screen/web_view_details.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  NewsProvider? newsProvider;
  NewsModel? newsModel;
  String sortBy = "publishedAt";
  String sports = "football";
  int pageNo = 1;
  var item1 = ["relevancy", "popularity", "publishedAt"];
  var item2 = ["football", "cricket", "volleyball"];
  Articles? art;
  var conection;
  @override
  void didChangeDependencies() {
    newsProvider = Provider.of<NewsProvider>(context);
    setState(() {});
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("Amar News Portal"),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SearchPage()));
              },
              icon: Icon(Icons.search))
        ],
      ),
      body: Container(
          padding: EdgeInsets.all(12),
          width: double.infinity,
          child: ListView(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  DropdownButton(
                    value: sortBy,
                    items: item1.map((String items) {
                      return DropdownMenuItem(
                        value: items,
                        child: Text(items),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      setState(() {
                        sortBy = value!;
                      });
                    },
                  ),
                  DropdownButton(
                    value: sports,
                    items: item2.map((String items) {
                      return DropdownMenuItem(
                        value: items,
                        child: Text(items),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      setState(() {
                        sports = value!;
                      });
                    },
                  ),
                ],
              ),
              FutureBuilder<NewsModel>(
                future: newsProvider!.getHomeData(pageNo, sortBy, sports),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    conection = ConnectionState.waiting;
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Text("Something is wrong");
                  } else if (snapshot.data == null) {
                    return Text("snapshot data are null");
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data!.articles!.length,
                    itemBuilder: (context, index) {
                      final data = snapshot.data!.articles![index];

                      art = data;
                      return InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => NewsDetails(
                                    articles: data,
                                  )));
                        },
                        child: Container(
                          height: 300,
                          width: double.infinity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 10,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(6),
                                  child: CachedNetworkImage(
                                    imageUrl: "${data.urlToImage}",
                                    width: double.infinity,
                                    fit: BoxFit.fill,
                                    placeholder: (context, url) =>
                                        CircularProgressIndicator(),
                                    errorWidget: (context, url, error) =>
                                        Image.network(
                                      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTOmYqa4Vpnd-FA25EGmYMiDSWOl9QV8UN1du_duZC9mQ&s",
                                      width: double.infinity,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Expanded(
                                  flex: 4,
                                  child: Column(
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Expanded(
                                            flex: 6,
                                            child: Text(
                                              "${data.title}",
                                              maxLines: 2,
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: IconButton(
                                                onPressed: () {
                                                  Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              WebViewDetails(
                                                                articles: data,
                                                              )));
                                                },
                                                icon: Icon(
                                                  Icons.web,
                                                  color: Colors.black,
                                                )),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ))
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
              Container(
                height: 35,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green),
                        onPressed: () {
                          if (pageNo == 1) {
                            return null;
                          } else {
                            setState(() {
                              pageNo -= 1;
                            });
                          }
                        },
                        child: Icon(Icons.arrow_back_ios)),
                    Flexible(
                      flex: 2,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 7,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return InkWell(
                              onTap: () {
                                setState(() {
                                  pageNo = index + 1;
                                });
                              },
                              child: Container(
                                color: pageNo == index + 1
                                    ? Colors.red
                                    : Colors.green,
                                margin: EdgeInsets.only(right: 6),
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                  "${index + 1}",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ));
                        },
                      ),
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green),
                        onPressed: () {
                          if (pageNo < 7) {
                            setState(() {
                              pageNo += 1;
                            });
                          }
                        },
                        child: Icon(Icons.arrow_forward_ios)),
                  ],
                ),
              )
            ],
          )),
    );
  }
}
