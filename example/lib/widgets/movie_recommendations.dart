import 'package:flutter/material.dart';
import 'package:flutter_torrent_streamer_example/services/auth.dart' as auth;
import 'package:http/http.dart' as http;
import 'dart:convert';

class MovieRecommendations extends StatefulWidget {
  @override
  _MovieRecommendationsState createState() => _MovieRecommendationsState();
}

class _MovieRecommendationsState extends State<MovieRecommendations> {
  List movieList = [];
  Future<Map> _fetchMovieData(String genreId) async {
    //https://api.themoviedb.org/3/discover/movie?api_key=dca0bd957ed11ea30e6dab348fda19e9&with_genres=36
    String url = "https://api.themoviedb.org/3/discover/movie?api_key=dca0bd957ed11ea30e6dab348fda19e9&with_genres=";
    String apiKey = "dca0bd957ed11ea30e6dab348fda19e9";
    final response = await http.get(Uri.parse(url+genreId));
    if(response.statusCode == 200){
      final result = jsonDecode(response.body);
      dynamic list = result;
      return list;
    }
    else{
      throw Exception("Error Loading Movies");
    }
  }
  void _fetchList(List genreIdList ) async {
    for(int i=0; i< genreIdList.length; i++) {
      movieList.add(_fetchMovieData(genreIdList[i].toString()));
    }
    //movieList = movieRecomList;
  }

  @override
  Widget build(BuildContext context) {
    print(auth.custom_user.genres);


    _fetchList(auth.custom_user.genres);
    print(movieList);
    print(movieList.length);
    return Container(
      child: Column(
        children: [
          Text("Recommendations"),

        ],
      ),
    );
  }
}
