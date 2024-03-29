import 'package:flutter_torrent_streamer_example/screens/home/nav_drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter_torrent_streamer_example/constant/api_constant.dart';
import 'package:flutter_torrent_streamer_example/constant/string_constant.dart';
import 'package:flutter_torrent_streamer_example/models/movie_model.dart';
import 'package:flutter_torrent_streamer_example/utils/widgethelper/widget_helper.dart';
import 'package:flutter_torrent_streamer_example/screens/login/login.dart';
import 'package:flutter_torrent_streamer_example/search/search_screen.dart';
import 'package:flutter_torrent_streamer_example/widgets/caraousel_view.dart';
import 'package:flutter_torrent_streamer_example/widgets/movie_cate.dart';
import 'package:flutter_torrent_streamer_example/widgets/movie_recommendations.dart';
import 'package:flutter_torrent_streamer_example/widgets/sifi_movie_row.dart';
import 'package:flutter_torrent_streamer_example/widgets/trending_movie_row.dart';
import 'package:flutter_torrent_streamer_example/widgets/trending_person.dart';
import 'package:flutter/services.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_torrent_streamer_example/models/movie.dart';
import 'package:flutter_torrent_streamer_example/shared/loading.dart';
import 'package:flutter_torrent_streamer_example/constant.dart';
import 'package:flutter_torrent_streamer_example/services/auth.dart';
import 'package:flutter_torrent_streamer_example/screens/wrapper.dart';

import '../../constant.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  MovieModel model;
  final AuthService _auth=AuthService();

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String searchText = "";

  TextEditingController controller = new TextEditingController();
  List<Movie> _movielist = new List<Movie>();
  bool isSearching = true;
  bool loading=false;

  BuildContext _context;
  // AppUpdateInfo _updateInfo;
  @override
  void initState() {
    super.initState();
    checkForUpdate();
    model = MovieModel();
    model.fetchNowPlaying();
    model.fetchTrandingPerson();
    callMovieApi(ApiConstant.POPULAR_MOVIES, model);
    callMovieApi(ApiConstant.GENRES_LIST, model);
    callMovieApi(ApiConstant.TRENDING_MOVIE_LIST, model);
    callMovieApi(ApiConstant.DISCOVER_MOVIE, model);
    callMovieApi(ApiConstant.UPCOMING_MOVIE, model);
    model.fetchTrandingPerson();
    callMovieApi(ApiConstant.TOP_RATED, model);
  }
  void _populateAllMovies() async {
    final result = await _fetchAllMovies();
    setState(() {
      _movielist = result;
      loading = false;
    });
  }
  Future<List<Movie>> _fetchAllMovies() async {
    String url = "https://www.omdbapi.com/?s=";
    String apiKey = "&apikey=8366faa1";
    final response = await http.get(Uri.parse(url+searchText+apiKey));
    if(response.statusCode == 200){
      final result = jsonDecode(response.body);
      Iterable list = result['Search'];
      return list.map((movie) => Movie.fromJson(movie)).toList();
    }
    else{
      throw Exception("Error Loading Movies");
    }
  }

  @override
  Widget build(BuildContext context) {
    _context = context;

    var homeIcon = IconButton(
        icon: Icon(
          Icons.sort, //menu
          color: kRealBlack,
        ),
        onPressed: () {
          _scaffoldKey.currentState.openDrawer();
        });

    return WillPopScope(
      onWillPop: () {
        return onWillPop(context);
      },

      child: Scaffold(
        backgroundColor: kBlack,
          key: _scaffoldKey,
            appBar: getAppBarWithBackBtn(
              ctx: context,
              title: StringConst.HOME_TITLE,
              bgColor: kBlack,
            actions: [
          IconButton(
          icon: Icon(Icons.search_rounded, color: kRealBlack,), onPressed: () => navigationPush(context, SearchScreen())
      ),
              IconButton(
                  onPressed: () async{
                    await _auth.signOut();
                    navigationPushReplacement(context, Login(screenHeight: MediaQuery.of(context).size.height));
                  },
                  icon: Icon(Icons.logout  ,color: kRealBlack,),
              ),
                      ],
              icon: homeIcon,
                  ),
          drawer: NavDrawer(),


          body: ScopedModel(model: model, child: _createUi())),



    );
  }

  Widget _createUi() {
    print(ApiConstant.DISCOVER_MOVIE);
    return SafeArea(
      child: Container(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 10),
              // SizedBox(height:450,child: ShimmerView.movieDetailsTag()),
              SizedBox(
                  height: 180,
                  width: double.infinity,
                  child: CarouselView()),
              //MovieRecommendations(),
              TrandingMovieRow(apiName: ApiConstant.TRENDING_MOVIE_LIST),
              MovieCate(),
              TrandingMovieRow(apiName: ApiConstant.POPULAR_MOVIES),
              SifiMovieRow(ApiConstant.UPCOMING_MOVIE),
              TrandingMovieRow(apiName: ApiConstant.DISCOVER_MOVIE),

              TrandingPerson(),
              TrandingMovieRow(apiName: ApiConstant.TOP_RATED),

            ],
          ),
        ),
      ),
    );
  }
  Future<void> checkForUpdate() async {

  }
}
Future<bool> onWillPop(BuildContext context) async {
  return showDialog<bool>(
      context: context,
      builder: (_) {
        return AlertDialog(
          content: getTxtColor(
              msg: "Are you sure you want to exit this app?", fontSize: 17, txtColor: kRealBlack),
          title: getTxtBlackColor(
              msg: "Warning!", fontSize: 18, fontWeight: FontWeight.bold),
          actions: <Widget>[
            FlatButton(
                child: getTxtColor(msg: "Yes",fontSize: 17,txtColor: kRealBlack),
                onPressed: () => SystemNavigator.pop()),
            FlatButton(
                child: getTxtColor(msg: "No",fontSize: 17,txtColor: kRealBlack),
                onPressed: ()
                => Navigator.pop(context)),
          ],
        );
      });
}
String getTitle(String apiName) {
  switch (apiName) {
    case ApiConstant.POPULAR_MOVIES:
      return 'Popular Movies';
    case ApiConstant.GENRES_LIST:
      return 'Genres';
    case ApiConstant.TRENDING_MOVIE_LIST:
      return 'Trending Movies';
    case ApiConstant.DISCOVER_MOVIE:
      return 'Discover Movie';
    case ApiConstant.UPCOMING_MOVIE:
      return 'Upcoming Movies';
    case ApiConstant.TOP_RATED:
      return 'Top Rated Movies';
    case ApiConstant.RECOMMENDATIONS_MOVIE:
      return 'Recommendations';
    case ApiConstant.SIMILAR_MOVIES:
      return 'Similar Movie';
    case ApiConstant.MOVIE_IMAGES:
    case StringConst.IMAGES:
      return StringConst.IMAGES;
    case StringConst.PERSON_MOVIE_CREW:
      return 'Movie As Crew';
    case StringConst.PERSON_MOVIE_CAST:
      return 'Movie As Cast';
    default:
      return apiName;
  }
}

callMovieApi(String apiName, MovieModel model, {int movieId, int page=1}) {
  switch (apiName) {
    case ApiConstant.POPULAR_MOVIES:
      return model.fetchPopularMovie(page);
    case ApiConstant.GENRES_LIST:
      return model.fetchMovieCat();
    case ApiConstant.TRENDING_MOVIE_LIST:
      return model.trandingMovie(page);
    case ApiConstant.DISCOVER_MOVIE:
      return model.discoverMovie(page);
    case ApiConstant.UPCOMING_MOVIE:
      return model.upcommingMovie(page);
    case ApiConstant.TOP_RATED:
      return model.topRatedMovie(page);
    case ApiConstant.RECOMMENDATIONS_MOVIE:
      return model.fetchRecommendMovie(movieId, page);
    case ApiConstant.SIMILAR_MOVIES:
      return model.fetchSimilarMovie(movieId, page);
    case ApiConstant.SIMILAR_MOVIES:
      return model.fetchSimilarMovie(movieId, page);
    case StringConst.MOVIE_CAST:
    case StringConst.MOVIE_CREW:
      return model.movieCrewCast(movieId);
    case StringConst.TRANDING_PERSON_OF_WEEK:
      return model.fetchTrandingPerson();
    case StringConst.PERSON_MOVIE_CAST:
    case StringConst.PERSON_MOVIE_CREW:
      return model.fetchPersonMovie(movieId);
    case StringConst.MOVIE_CATEGORY:
      return model.fetchCategoryMovie(movieId, page);
    case StringConst.MOVIES_KEYWORDS:
      return model.fetchKeywordMovieList(movieId,page);
  }
}

getData(String apiName, MovieModel model) {
  switch (apiName) {
    case ApiConstant.POPULAR_MOVIES:
      return model.popularMovieRespo;
    case ApiConstant.GENRES_LIST:
      return model.getMovieCat;
    case ApiConstant.TRENDING_MOVIE_LIST:
      return model.getTrandingMovie;
    case ApiConstant.DISCOVER_MOVIE:
      return model.getDiscoverMovie;
    case ApiConstant.UPCOMING_MOVIE:
      return model.getUpcommingMovie;
    case ApiConstant.TOP_RATED:
      return model.getTopRatedMovie;
    case ApiConstant.RECOMMENDATIONS_MOVIE:
      return model.recommendMovieRespo;
    case ApiConstant.SIMILAR_MOVIES:
      return model.similarMovieRespo;
    case StringConst.MOVIE_CAST:
    case StringConst.MOVIE_CREW:
      return model.getMovieCrew;
    case ApiConstant.MOVIE_IMAGES:
      return model.movieImgRespo;
    case StringConst.IMAGES:
      return model.personImageRespo;
    case StringConst.TRANDING_PERSON_OF_WEEK:
      return model.trandingPersonRespo;
    case StringConst.PERSON_MOVIE_CAST:
    case StringConst.PERSON_MOVIE_CREW:
      return model.personMovieRespo;
    case StringConst.MOVIE_CATEGORY:
      return model.catMovieRespo;
    case StringConst.MOVIES_KEYWORDS:
      return model.keywordMovieListRespo;
  }
}