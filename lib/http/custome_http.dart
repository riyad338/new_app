import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:news_app/model/news_model.dart';

class CustomeHttpRequest {
  static Future<NewsModel> fetchHomeData(
      int pageNo, String sortBy, String sports) async {
    String url =
        "https://newsapi.org/v2/everything?q=${sports}&sortBy=$sortBy&pageSize=12&page=${pageNo}&apiKey=b4af12d2892b476d8dcb0da5d5a0846a";
    NewsModel? newsModel;
    var responce = await http.get(Uri.parse(url));
    var data = jsonDecode(responce.body);
    newsModel = NewsModel.fromJson(data);
    return newsModel!;
  }

  static Future<NewsModel> fetchSearchData(String query) async {
    String url =
        "https://newsapi.org/v2/everything?q=${query}&pageSize=20&apiKey=b4af12d2892b476d8dcb0da5d5a0846a";

    NewsModel? newsModel;
    var responce = await http.get(Uri.parse(url));
    print("status code is ${responce.statusCode}");
    var data = jsonDecode(responce.body);
    newsModel = NewsModel.fromJson(data);
    return newsModel!;
  }
}
