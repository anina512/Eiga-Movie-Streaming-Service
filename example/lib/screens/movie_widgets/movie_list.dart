import 'package:flutter/material.dart';
import 'package:flutter_torrent_streamer_example/models/movie.dart';
import 'dart:convert';
import 'package:diacritic/diacritic.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_torrent_streamer_example/screens/movie_widgets/movie_detail.dart';
import 'package:flutter_torrent_streamer_example/shared/loading.dart';

class MovieList extends StatefulWidget {
  final List<Movie> movies;
  final String searchText;
  MovieList({this.movies, this.searchText});

  @override
  _MovieListState createState() => _MovieListState();
}

class _MovieListState extends State<MovieList> {

  bool loading=false;

  Future<Map> _fetchMovieData(String imdbId) async {
    String url = "https://www.omdbapi.com/?i=";
    String apiKey = "&plot=full&apikey=8366faa1";
    final response = await http.get(Uri.parse(url+imdbId+apiKey));
    if(response.statusCode == 200){
      final result = jsonDecode(response.body);
      dynamic list = result;
      return list;
    }
    else{
      throw Exception("Error Loading Movies");
    }
  }

  Future<List> _fetchMagnetLinks(String movieTitle) async {
    String url = "https://apibay.org/q.php?q=";
    movieTitle = removeDiacritics(movieTitle);
    movieTitle = movieTitle.replaceAll(new RegExp(r'[^\w\s]+'),'');
    print(movieTitle);
    final response = await http.get(Uri.parse(url+movieTitle));
    if(response.statusCode == 200){
      final result = jsonDecode(response.body);
      dynamic list = result.toList();
      return list;
    }
    else{
      throw Exception("Error Loading Magnet Links");
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: widget.movies.length,
        itemBuilder: (context, index){
          final movie = widget.movies[index];
          return FlatButton(
            onPressed: () async{
              setState(() {
                loading=true;
              });
              if (loading){Navigator.pushNamed(context, '/loading');}

              final result = await _fetchMovieData(movie.imdbID);
              //print(result);
              final links = await _fetchMagnetLinks(result["Title"]);
              Navigator.pop(context);
              setState(() {
                loading=false;
              });
              //print(result);
              Navigator.pushNamed(context,'/movie-detail', arguments: {
                'title': result["Title"],
                'year': result["Year"],
                'poster': result["Poster"],
                'plot': result["Plot"],
                'releaseDate': result["Released"],
                'runTime': result['Runtime'],
                'genre': result['Genre'],
                'actors': result["Actors"],
                'imdbRating': result["Ratings"],
                'magnetLinks': links,
              } );
            },
            child: ListTile(
              title: Row(
                children: [
                  SizedBox(
                    width: 100,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.network(movie.poster),
                    ),
                  ),
                  Flexible(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Text(movie.movieTitle),
                            Text(movie.yearOfRelease),
                          ],
                        ),
                      ),
                  ),
                ],
              ),
            ),
          );
        }
    );
  }
}
