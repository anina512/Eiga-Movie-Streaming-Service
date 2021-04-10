import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_torrent_streamer_example/screens/movie_widgets/movie_list.dart';
import 'package:flutter_torrent_streamer_example/services/auth.dart';
import 'package:flutter_torrent_streamer_example/models/movie.dart';
import 'package:flutter_torrent_streamer_example/shared/loading.dart';
import 'package:http/http.dart' as http;


class Home extends StatefulWidget {

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //Variables
  String searchText = "";
  final AuthService _auth=AuthService();
  TextEditingController controller = new TextEditingController();
  List<Movie> _movielist = new List<Movie>();
  bool isSearching = true;
  bool loading=false;
  /*
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _populateAllMovies();
  }
  */
  //api key = http://www.omdbapi.com/?i=tt3896198&apikey=8366faa1

  void _populateAllMovies() async {
    final result = await _fetchAllMovies();
    if (result==null){
      String errorMessage='Movie not found';
      loading = false;
      this.isSearching = !this.isSearching;
      Navigator.pushNamed(context,'/error', arguments: {'errorMessage':errorMessage});
    }
    else{
      setState(() {
      _movielist = result;
      loading = false;
      });
    }

  }
  Future<List<Movie>> _fetchAllMovies() async {
    String url = "https://www.omdbapi.com/?s=";
    String apiKey = "&apikey=8366faa1";
    final response = await http.get(Uri.parse(url+searchText+apiKey));
    if(response.statusCode == 200){
      final result = jsonDecode(response.body);
      Iterable list = result['Search'];
      try
      {
        loading=false;
        return list.map((movie) => Movie.fromJson(movie)).toList();
      }
      catch(e){
        setState(() {
          return null;
        });
      }
    }
    else{
      throw Exception("Error Loading Movies");
    }
  }

  @override
  Widget build(BuildContext context) {
    return loading ? Loading(): Scaffold(

      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Eiga'),
        backgroundColor: Colors.blue,
        elevation: 0,
        actions: <Widget>[
          FlatButton.icon(
              onPressed: () async{
                await _auth.signOut();
              },
              icon: Icon(Icons.person),
              label: Text('Logout')),

        ],
      ),
      body: Column(
        children: <Widget>[
          SizedBox(height: 5.0),
          !isSearching ?
          FlatButton.icon(
          icon: Icon(Icons.cancel),
          label: Text("Showing Results: "),
          onPressed: () async{
            setState(() {
              this.isSearching = !this.isSearching;
              setState(() {
                _movielist = new List<Movie>();
              });
            });
          },
        ):
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                  icon:  IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () async{
                      setState(() {
                        loading = true;
                        this.searchText = controller.text;
                        this.isSearching = !this.isSearching;
                        if(controller.text.isNotEmpty) {
                            _populateAllMovies();
                          }
                      });
                    },
                  ),
                  hintText: "Enter a movie name. Example: Naruto",
              ),
            ),
          ),
          SizedBox(height: 10.0),

          Expanded(child: _movielist.isNotEmpty ? MovieList(movies: _movielist, searchText: searchText): Text("No results to show")),
        ],
      ),
    );
  }
}
