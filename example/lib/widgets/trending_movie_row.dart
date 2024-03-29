import 'package:flutter_torrent_streamer_example/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_torrent_streamer_example/constant/api_constant.dart';
import 'package:flutter_torrent_streamer_example/constant/string_constant.dart';
import 'package:flutter_torrent_streamer_example/data/home/now_playing_repo.dart';
import 'package:flutter_torrent_streamer_example/data/person/person_movie_repo.dart';
import 'package:flutter_torrent_streamer_example/models/movie_model.dart';
import 'package:flutter_torrent_streamer_example/utils/apiutils/api_response.dart';
import 'package:flutter_torrent_streamer_example/utils/widgethelper/widget_helper.dart';
import 'package:flutter_torrent_streamer_example/details/detail_movie.dart';
import 'package:flutter_torrent_streamer_example/screens/home/new_home.dart';
import 'package:flutter_torrent_streamer_example/listin/movie_list_screen.dart';
import 'package:flutter_torrent_streamer_example/widgets/rating_result.dart';
import 'package:flutter_torrent_streamer_example/widgets/shimmer_view.dart';
import 'package:scoped_model/scoped_model.dart';

class TrandingMovieRow extends StatelessWidget {
  final apiName;
  final movieId;

  TrandingMovieRow({@required this.apiName, this.movieId});

  @override
  Widget build(BuildContext context) {
    return Container(child: apiresponse(context)); //getTradingList(context);
  }

  Widget apiresponse(BuildContext context) {
    return ScopedModelDescendant<MovieModel>(
      builder: (context, _, model) {
        var jsonResult = getData(apiName, model);
        if (jsonResult.status == ApiStatus.COMPLETED)
          return getCount(jsonResult.data) > 0
              ? getMovieList(context, apiName, jsonResult.data)
              : Container();
        else
          return apiHandler(
              loading: ShimmerView(
                viewType: ShimmerView.VIEW_HORIZONTAL_MOVIE_LIST,
                parentHeight: 240,
                height: 185,
                width: 125,
              ),
              response: jsonResult);
      },
    );
  }

//  List<Result>
  Widget getMovieList(BuildContext context, String apiName, var jsonResult) {
    return Column(
      children: <Widget>[
        SizedBox(height: 10),
        getHeading(
            context: context,
            apiName: apiName,
            movieId: movieId,
            isShowViewAll: getCount(jsonResult) > 8 ? true : false),
        SizedBox(height: 10),
        SizedBox(
          height: 240.0,
          child: ListView.builder(
            physics: BouncingScrollPhysics(),
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: getCount(jsonResult), //results.length,
            itemBuilder: (context, index) {
//              Result item = jsonResult[index];
              return Padding(
                padding: const EdgeInsets.all(4.0),
                child: getView(context, apiName, jsonResult, index),
              );
            },
          ),
        ),
      ],
    );
  }

  int getCount(jsonResult) {
    if (jsonResult is NowPlayingRespo)
      return jsonResult.results.length;
    else if (apiName == StringConst.PERSON_MOVIE_CAST &&
        jsonResult is PersonMovieRespo)
      return jsonResult.cast.length;
    else if (apiName == StringConst.PERSON_MOVIE_CREW &&
        jsonResult is PersonMovieRespo) return jsonResult.crew.length;
    return 0;
  }



  Widget getView(BuildContext context, String apiName, jsonResult, int index) {
    if (jsonResult is NowPlayingRespo) {
      NowPlayResult item = jsonResult.results[index];
      return getMovieItemRow(
          context: context,
          apiName: apiName,
          index: index,
          height: 185,
          width: 125,
          id: item.id,
          img: item.poster_path == null ? "" : item.poster_path,
          name: item.title,
          vote: item.vote_average);
    } else if (apiName == StringConst.PERSON_MOVIE_CAST &&
        jsonResult is PersonMovieRespo) {
      PersonCast item = jsonResult.cast[index];
      return getMovieItemRow(
          context: context,
          apiName: apiName,
          index: index,
          height: 185,
          width: 125,
          id: item.id,
          img: item.posterPath == null ? "" : item.posterPath,
          name: item.title,
          vote: item.voteAverage);
    } else if (apiName == StringConst.PERSON_MOVIE_CREW &&
        jsonResult is PersonMovieRespo) {
      PersonCrew item = jsonResult.crew[index];
      return getMovieItemRow(
          context: context,
          apiName: apiName,
          index: index,
          height: 185,
          width: 125,
          id: item.id,
          img: item.posterPath == null ? "" : item.posterPath,
          name: item.title,
          vote: item.voteAverage);
    } else
      return Container();
  }
}

Widget getMovieItemRow(
    {BuildContext context,
      String apiName,
      int index,
      double height,
      double width,
      int id,
      String img,
      String name,
      var vote,
      Function onTap}) {
  String tag = getTitle(apiName) + img + index.toString();
  return  Hero(
    tag: tag,
    child: Container(
      width: width,
      child: Column(
        children: <Widget>[
          SizedBox(
            height: height,
            child: ClipRRect(
              child: Stack(
                children: [
                  getCacheImage(
                      url:ApiConstant.IMAGE_POSTER + img.toString(), height: height),
                  Positioned.fill(
                      child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                              splashColor: Colors.redAccent,
                              onTap: () {
                                if (onTap != null) {
                                  onTap();
                                } else
                                  navigationPush(
                                      context,
                                      DetailsMovieScreen(
                                          name, ApiConstant.IMAGE_POSTER+img,apiName, index, id, tag));
                              }))),
                ],
              ),
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          SizedBox(height:5),
          Align(
              alignment: Alignment.topLeft,
              child: getTxtAsliBlackColor(
                  msg: name,
                  maxLines: 1,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  textAlign: TextAlign.start)),
          SizedBox(height:5),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[

              RatingResult(vote, 12.0),
              SizedBox(width: 5),
              RatingBar.builder(
                itemSize: 12.0,
                initialRating: vote / 2,
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
          )
        ],
      ),
    ),
  );
}

Color getBackgrountRate(double rate) {
  if (rate < 5.0) {
    return Colors.red;
  } else if (rate < 6.8) {
    return Colors.yellow;
  } else if (rate < 7.3) {
    return Colors.blue;
  } else {
    return Colors.green;
  }
}

Widget getHeading(
    {BuildContext context,
      String apiName,
      int movieId,
      bool isShowViewAll = true}) {
  String titleTag = getTitle(apiName) + "_Heading_" + apiName;
  return Padding(
    padding: const EdgeInsets.only(left: 8, right: 8),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Hero(
          tag: titleTag,
          child: getTxtBlackColor(
              msg: getTitle(apiName),
              fontSize: 19,
              fontWeight: FontWeight.w700),
        ),
        if (isShowViewAll)
          GestureDetector(
            onTap: () {
              navigationPush(
                  context, MovieListScreen(apiName: apiName, movieId: movieId));
            },
            child: getTxtColor(
                msg: StringConst.VIEW_ALL,
                txtColor: kRed,
                fontWeight: FontWeight.w800),
          )
      ],
    ),
  );
}