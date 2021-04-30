
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_torrent_streamer_example/constant/string_constant.dart';
import 'package:flutter_torrent_streamer_example/data/details/keyboard_repo.dart';
import 'package:flutter_torrent_streamer_example/models/movie_model.dart';
import 'package:flutter_torrent_streamer_example/utils/apiutils/api_response.dart';
import 'package:flutter_torrent_streamer_example/utils/widgethelper/widget_helper.dart';
import 'package:flutter_torrent_streamer_example/listin/movie_list_screen.dart';
import 'package:flutter_torrent_streamer_example/widgets/shimmer_view.dart';
import 'package:flutter_torrent_streamer_example/widgets/trending_movie_row.dart';
import 'package:scoped_model/scoped_model.dart';

class MovieKeyword extends StatelessWidget {
  String castCrew;

  MovieKeyword(this.castCrew);

  @override
  Widget build(BuildContext context) {
    return Container(child: apiresponse(context));
  }

  Widget apiresponse(BuildContext context) {
    return ScopedModelDescendant<MovieModel>(
      builder: (context, _, model) {
        var jsonResult = model.getMovieKeyword;
        if (jsonResult.status == ApiStatus.COMPLETED)
          return jsonResult.data.keywords.length > 0
              ? movieKeyword(context, jsonResult.data)
              : Container();
        else
          return apiHandler(loading: ShimmerView.movieDetailsTag(),response: jsonResult);
      },
    );
  }

  Widget movieKeyword(BuildContext context, KeywordRespo data) {
    return Column(
      children: <Widget>[
        SizedBox(height: 10),
        getHeading(context: context, apiName: castCrew, isShowViewAll: false),
        SizedBox(height: 8),
        getKeywordItem(context, data)
      ],
    );
  }

  Widget getKeywordItem(BuildContext context, KeywordRespo data) {
    return SizedBox(
      child:  Wrap(
        direction: Axis.horizontal,
        children: getKeywordListings(context, data.keywords),
      ),
    );
  }

  List<Widget> getKeywordListings(
      BuildContext context, List<Keywords> keywords) {
    List listings = List<Widget>();
    for (int i = 0; i < keywords.length; i++) {
      listings.add(
        Container(
          margin: EdgeInsets.only(left: 5, right: 5),
          child: InkWell(
            onTap: () => navigationPush(
                context,
                MovieListScreen(
                    apiName: StringConst.MOVIES_KEYWORDS,
                    dynamicList: keywords[i].name,
                    movieId: keywords[i].id)),
            child: Chip(
              elevation: 3.0,
              backgroundColor: Colors.black54,
              label: Text(keywords[i].name),
            ),
          ),
        ),
      );
    }
    return listings;
  }
}