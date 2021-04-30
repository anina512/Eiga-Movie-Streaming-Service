import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_torrent_streamer_example/constant/api_constant.dart';
import 'package:flutter_torrent_streamer_example/constant.dart';
import 'package:flutter_torrent_streamer_example/constant/string_constant.dart';
import 'package:flutter_torrent_streamer_example/data/home/movie_cat_repo.dart';
import 'package:flutter_torrent_streamer_example/models/movie_model.dart';
import 'package:flutter_torrent_streamer_example/utils/apiutils/api_response.dart';
import 'package:flutter_torrent_streamer_example/utils/global_utility.dart';
import 'package:flutter_torrent_streamer_example/utils/widgethelper/widget_helper.dart';
import 'package:flutter_torrent_streamer_example/listin/movie_list_screen.dart';
import 'package:flutter_torrent_streamer_example/widgets/shimmer_view.dart';
import 'package:flutter_torrent_streamer_example/widgets/trending_movie_row.dart';
import 'package:scoped_model/scoped_model.dart';

class MovieCate extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(child: apiresponse(context));
  }

  Widget apiresponse(BuildContext context) {
    return ScopedModelDescendant<MovieModel>(
      builder: (context, _, model) {
        var jsonResult = model.getMovieCat;
        if (jsonResult.status == ApiStatus.COMPLETED)
          return getCate(context, jsonResult.data.genres);
        else
          return apiHandler(loading: ShimmerView(viewType: ShimmerView.VIEW_HORI_PERSON, parentHeight:150,height: 100,width: 110 ,),response: jsonResult);
      },
    );
  }

  Widget getCate(BuildContext context, List<Genres> genres) {
    return Column(
      children: <Widget>[
        SizedBox(height: 10),
        getHeading(context: context, apiName: ApiConstant.GENRES_LIST),
        SizedBox(height: 10),
        SizedBox(
          height: 150,
          child: Container(
            child: ListView.builder(
                physics: BouncingScrollPhysics(),
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: genres.length,
                itemBuilder: (BuildContext context, int index) {
                  return getCatRow(context,index, genres[index]);
                }),
          ),
        ),
      ],
    );
  }

  Widget getCatRow(BuildContext context,int index, Genres item) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        child: Column(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(100.0)),
              child: Stack(
                children: [
                  loadCircleCacheImg(getCategoryMovie()[index], 100),
                  Positioned.fill(
                      child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                              splashColor: Colors.red,
                              onTap: () {
                                navigationPush(
                                    context,
                                    MovieListScreen(
                                        apiName: StringConst.MOVIE_CATEGORY,
                                        dynamicList: item.name,
                                        movieId: item.id));
                              }))),
                ],
              ),
            ),
            getTxtBlackColor(msg: item.name, fontWeight: FontWeight.w700)
          ],
        ),
      ),
    );
  }
}