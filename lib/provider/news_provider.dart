import 'package:flutter/material.dart';
import 'package:news_app/model/news_model.dart';
import 'package:provider/provider.dart';

import '../http/custome_http.dart';

class NewsProvider with ChangeNotifier {
  NewsModel? newsModel;
  Future<NewsModel> getHomeData(
      int pageNo, String sortBy, String sports) async {
    newsModel = await CustomeHttpRequest.fetchHomeData(pageNo, sortBy, sports);
    return newsModel!;
  }

  Future<NewsModel> getsearch(String query) async {
    newsModel = await CustomeHttpRequest.fetchSearchData(query);
    return newsModel!;
  }
}
