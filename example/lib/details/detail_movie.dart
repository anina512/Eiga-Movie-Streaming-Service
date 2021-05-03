import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_torrent_streamer_example/constant/api_constant.dart';
import 'package:flutter_torrent_streamer_example/constant/string_constant.dart';
import 'package:flutter_torrent_streamer_example/data/details/movie_details_repo.dart';
import 'package:flutter_torrent_streamer_example/models/movie_model.dart';
import 'package:flutter_torrent_streamer_example/utils/apiutils/api_response.dart';
import 'package:flutter_torrent_streamer_example/utils/widgethelper/widget_helper.dart';
import 'package:flutter_torrent_streamer_example/widgets/movie_tag.dart';
import 'package:flutter_torrent_streamer_example/widgets/movie_cast_crew.dart';
import 'package:flutter_torrent_streamer_example/widgets/movie_keyword.dart';
import 'package:flutter_torrent_streamer_example/widgets/rating_result.dart';
import 'package:flutter_torrent_streamer_example/widgets/shimmer_view.dart';
import 'package:flutter_torrent_streamer_example/widgets/sifi_movie_row.dart';
import 'package:flutter_torrent_streamer_example/widgets/trending_movie_row.dart';
import 'package:flutter_torrent_streamer_example/widgets/video_view.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_torrent_streamer_example/constant.dart';
import 'package:shimmer/shimmer.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:diacritic/diacritic.dart';
import 'package:http/http.dart' as http;

class DetailsMovieScreen extends StatefulWidget {
  final apiName;
  final tag;
  final index;
  final movieId;
  final image, movieName;


  DetailsMovieScreen(this.movieName, this.image, this.apiName, this.index,
      this.movieId, this.tag);

  @override
  _DetailsMovieScreenState createState() =>
      _DetailsMovieScreenState(movieName, image, apiName, index, movieId, tag);
}

class _DetailsMovieScreenState extends State<DetailsMovieScreen> {
  final apiName;
  final tag;
  final index;
  final movieId;
  MovieModel model;
  final double expandedHeight = 350.0;
  final image, movieName;

  _DetailsMovieScreenState(this.movieName, this.image, this.apiName, this.index,
      this.movieId, this.tag);

  @override
  void initState() {
    super.initState();
    model = MovieModel();
    model.movieDetails(movieId);
    model.movieCrewCast(movieId);
    model.fetchRecommendMovie(movieId,1);
    model.fetchSimilarMovie(movieId,1);
    model.keywordList(movieId);
    model.movieVideo(movieId);
    model.movieImg(movieId);
  }
  //Magnet Link
 bool loading=false;
  List magnetLinkList = [];
  Future<List> _fetchMagnetLinks(String movieTitle) async {
    String url = "https://apibay.org/q.php?q=";
    movieTitle = removeDiacritics(movieTitle);
    movieTitle = movieTitle.replaceAll(new RegExp(r'[^\w\s]+'),'');
    print(movieTitle);
    final response = await http.get(Uri.parse(url+movieTitle));
    print(response.body);
    print('not stuck');
    if(response.statusCode == 200){
      final result = jsonDecode(response.body);
      dynamic list = result.toList();
      return list;
    }
    else{
      throw Exception("Error Loading Magnet Links");
    }
  }
  List _generateMagnetLinksFromInfoHash(List torrentList){
    List allMagnetLinks = [];
    int maxEntries = torrentList.length<10 ? torrentList.length : 10;
    for (int i= 0; i<maxEntries; i++)
    {
      Map magnetLinkList = {};
      Map torrentEntry = torrentList[i];
      String name = torrentEntry["name"];
      String info_hash = torrentEntry["info_hash"];
      name = name.replaceAll(" ", "%");
      //Magnet Link Format
      String magnetLink = ("magnet:?xt=urn:btih:"+ info_hash + "&dn="+ name + "&tr=http%3A%2F%2F125.227.35.196%3A6969%2Fannounce&tr=http%3A%2F%2F210.244.71.25%3A6969%2Fannounce&tr=http%3A%2F%2F210.244.71.26%3A6969%2Fannounce&tr=http%3A%2F%2F213.159.215.198%3A6970%2Fannounce&tr=http%3A%2F%2F37.19.5.139%3A6969%2Fannounce&tr=http%3A%2F%2F37.19.5.155%3A6881%2Fannounce&tr=http%3A%2F%2F46.4.109.148%3A6969%2Fannounce&tr=http%3A%2F%2F87.248.186.252%3A8080%2Fannounce&tr=http%3A%2F%2Fasmlocator.ru%3A34000%2F1hfZS1k4jh%2Fannounce&tr=http%3A%2F%2Fbt.evrl.to%2Fannounce&tr=http%3A%2F%2Fbt.rutracker.org%2Fann&tr=https%3A%2F%2Fwww.artikelplanet.nl&tr=http%3A%2F%2Fmgtracker.org%3A6969%2Fannounce&tr=http%3A%2F%2Fpubt.net%3A2710%2Fannounce&tr=http%3A%2F%2Ftracker.baravik.org%3A6970%2Fannounce&tr=http%3A%2F%2Ftracker.dler.org%3A6969%2Fannounce&tr=http%3A%2F%2Ftracker.filetracker.pl%3A8089%2Fannounce&tr=http%3A%2F%2Ftracker.grepler.com%3A6969%2Fannounce&tr=http%3A%2F%2Ftracker.mg64.net%3A6881%2Fannounce&tr=http%3A%2F%2Ftracker.tiny-vps.com%3A6969%2Fannounce&tr=http%3A%2F%2Ftracker.torrentyorg.pl%2Fannounce&tr=https%3A%2F%2Finternet.sitelio.me%2F&tr=https%3A%2F%2Fcomputer1.sitelio.me%2F&tr=udp%3A%2F%2F168.235.67.63%3A6969&tr=udp%3A%2F%2F182.176.139.129%3A6969&tr=udp%3A%2F%2F37.19.5.155%3A2710&tr=udp%3A%2F%2F46.148.18.250%3A2710&tr=udp%3A%2F%2F46.4.109.148%3A6969&tr=udp%3A%2F%2Fcomputerbedrijven.bestelinks.nl%2F&tr=udp%3A%2F%2Fcomputerbedrijven.startsuper.nl%2F&tr=udp%3A%2F%2Fcomputershop.goedbegin.nl%2F&tr=udp%3A%2F%2Fc3t.org&tr=udp%3A%2F%2Fallerhandelenlaag.nl&tr=udp%3A%2F%2Ftracker.openbittorrent.com%3A80&tr=udp%3A%2F%2Ftracker.opentrackr.org%3A1337&tr=udp%3A%2F%2Ftracker.publicbt.com%3A80&tr=udp%3A%2F%2Ftracker.tiny-vps.com%3A6969");
      magnetLinkList["name"] = torrentEntry["name"];
      magnetLinkList["leechers"] = torrentEntry["leechers"];
      magnetLinkList["seeders"] = torrentEntry["seeders"];
      magnetLinkList["num_of_files"] = torrentEntry["num_files"];
      magnetLinkList["magnet_link"] = magnetLink;
      allMagnetLinks.add(magnetLinkList);
    }
    return allMagnetLinks;
  }
//Magnet Link Code End
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ScopedModel(model: model, child: apiresponse(context)));
  }

  Widget apiresponse(BuildContext context) {
    return ScopedModelDescendant<MovieModel>(
      builder: (context, _, model) {
        var jsonResult = model.getMovieDetails;
        if (jsonResult.status == ApiStatus.COMPLETED)
          return _createUi(data: jsonResult.data);
        else
          return apiHandler(loading: _createUi(), response: jsonResult);
      },
    );
  }

  Widget _createUi({MovieDetailsRespo data}) {
//    print(' obj   :  ' + data.releaseDate);
    final size = MediaQuery.of(context).size;
    return Stack(
      children: <Widget>[
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: _helperImage(data),
        ),
        CustomScrollView(
          slivers: <Widget>[
            _appBarView(),
            _contentSection(data),
          ],
        ),
      ],
    );
  }

  Widget _helperImage(MovieDetailsRespo data) {
    return Container(
      height: expandedHeight + 250,
      width: double.infinity,
      child: Hero(
          tag: tag,
          child: Container(child: getCacheImage(url:image, height: expandedHeight+50)
            // ApiConstant.IMAGE_ORIG_POSTER + data.posterPath.toString()),
          )),
    );
  }

  Widget _appBarView() {
    return SliverAppBar(
      leading: Container(
        child: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onPressed: () {

            Navigator.pop(context);
          },
        ),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      expandedHeight: expandedHeight - 50,
      snap: false,
      pinned: false,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(color: Colors.transparent),
        ),
      ),
    );
  }

  Widget _contentSection(MovieDetailsRespo data) {
    return SliverList(
      delegate: SliverChildListDelegate(
        [getContai(data)],
      ),
    );
  }

  Widget getContai(MovieDetailsRespo data) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Color.fromARGB(125, 255, 255, 255),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(35),
          topRight: Radius.circular(25),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _contentTitle(data),
          SifiMovieRow(ApiConstant.MOVIE_IMAGES),
          MovieCastCrew(castCrew: StringConst.MOVIE_CAST, movieId: movieId),
          MovieCastCrew(castCrew: StringConst.MOVIE_CREW, movieId: movieId),
          VideoView('Trailer'),
          MovieKeyword('Keyword'),
          TrandingMovieRow(
              apiName: ApiConstant.RECOMMENDATIONS_MOVIE, movieId: movieId),
          TrandingMovieRow(
              apiName: ApiConstant.SIMILAR_MOVIES, movieId: movieId),
        ],
      ),
    );
  }

  Widget _contentTitle(MovieDetailsRespo movie) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: 15,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: getTxtTitleColor(
                    msg: movieName, fontSize: 24, fontWeight: FontWeight.bold),
              ),
              RatingResult(movie == null ? 0 : movie.voteAverage, 12.0),
              SizedBox(width: 5),
              RatingBar.builder(
                itemSize: 12.0,
                initialRating: movie == null ? 0 : movie.voteAverage / 2,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (rating) {
                  print(rating);
                },
              )
            ],
          ),
          SizedBox(height: 7),
          MovieTag(items: movie == null ? null : movie.genres),
          SizedBox(height: 10),
          _contentAbout(movie),
          SizedBox(height: 10),
          MaterialButton(
            minWidth: double.infinity,
            height: 50,
            onPressed:  () async
            {
              setState(() {
                loading=true;
              });
              if (loading){Navigator.pushNamed(context, '/loading');}
              final links = await _fetchMagnetLinks(movieName);
              print('fetched links');
              magnetLinkList = _generateMagnetLinksFromInfoHash(links);
              print(magnetLinkList);
              Navigator.pop(context);
              Navigator.pushNamed(context, '/movie-magnet-links', arguments: {
                'magnetLinkList': magnetLinkList,
                'movieTitle': movieName,
              });
              setState(() {
                loading=false;
              });
            },
            color:kRed,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40)
            ),
            child: Text("GET LINKS",style:TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: kWhite,

            ),),



          ),
          SizedBox(height: 10),
          getTxtBlackColor(
              msg: 'Overview', fontSize: 18, fontWeight: FontWeight.bold),
          SizedBox(height: 10),

          if (movie != null)
            getTxtOverviewColor(
                msg: movie.overview != null ? movie.overview : '',
                fontSize: 15,
                fontWeight: FontWeight.w400)
          else
            ShimmerView.getOverView(context)
        ],
      ),
    );
  }

  Widget _contentAbout(MovieDetailsRespo _dataMovie) {
    var relDate;
    var budget,revenue;
    try {
      var inputFormat = DateFormat("yyyy-MM-dd");
      DateTime date1 = inputFormat.parse(_dataMovie.releaseDate);
      relDate = '${date1.day}/${date1.month}/${date1.year}';
      budget = NumberFormat.simpleCurrency().format( _dataMovie.budget);
      revenue = NumberFormat.simpleCurrency().format( _dataMovie.revenue);

    }catch(exp){

    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _contentDescriptionAbout(
                  'Status', _dataMovie != null ? _dataMovie.status : null),
              _contentDescriptionAbout('Duration',
                  '${_dataMovie != null ? _dataMovie.runtime : null} min'),
              _contentDescriptionAbout('Release Date',
                  _dataMovie != null ? relDate : null),
              _contentDescriptionAbout('Budget',
                  '${_dataMovie != null ? _dataMovie.budget==0?' N/A':'${budget}' : null}'),
              _contentDescriptionAbout('Revenue',
                  '${_dataMovie != null ? _dataMovie.revenue==0?' N/A':'${revenue}' : null}'),

            ],
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Container(
                width: 80,
                height: 125,
                child: getCacheImage(url:_dataMovie == null
                    ? image
                    : ApiConstant.IMAGE_POSTER +
                    _dataMovie.backdropPath.toString(), height: 125, width: 80)),
          ),
        ],
      ),
    );
  }

  Widget _contentDescriptionAbout(String title, String value) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            getTxtBlackColor(
                msg: title != null ? title : '',
                fontSize: 12,
                fontWeight: FontWeight.w600,
                textAlign: TextAlign.start),
            Text(' : '),
            if (value == null)
              Shimmer.fromColors(
                  baseColor: Colors.grey[300],
                  highlightColor: Colors.grey[100],
                  enabled: true,
                  child: Container(
                    width: 150,
                    height: 10,
                    color: Colors.white,
                  ))
            else
              getTxtAppColor(
                  msg: value != null ? value : '',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  textAlign: TextAlign.start),
          ],
        ),
        SizedBox(
          height: 10,
        )
      ],
    );
  }
}