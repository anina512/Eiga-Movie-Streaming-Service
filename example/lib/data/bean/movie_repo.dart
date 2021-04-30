import 'package:flutter_torrent_streamer_example/data/home/now_playing_repo.dart';

class MovieRespo {
  int page;
  int totalResults;
  int totalPages;
  List<NowPlayResult> results;

  MovieRespo({this.page, this.totalResults, this.totalPages, this.results});

  MovieRespo.fromJson(Map<String, dynamic> json) {
    page = json['page'];
    totalResults = json['total_results'];
    totalPages = json['total_pages'];
    if (json['results'] != null) {
      results = new List<NowPlayResult>();
      json['results'].forEach((v) {
        results.add(new NowPlayResult.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['page'] = this.page;
    data['total_results'] = this.totalResults;
    data['total_pages'] = this.totalPages;
    if (this.results != null) {
      data['results'] = this.results.map((v) => v.toJson()).toList();
    }
    return data;
  }
}