import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_torrent_streamer_example/constant/api_constant.dart';
import 'package:flutter_torrent_streamer_example/data/home/now_playing_repo.dart';
import 'package:flutter_torrent_streamer_example/models/movie_model.dart';
import 'package:flutter_torrent_streamer_example/utils/apiutils/api_response.dart';
import 'package:flutter_torrent_streamer_example/utils/widgethelper/widget_helper.dart';
import 'package:flutter_torrent_streamer_example/details/detail_movie.dart';
import 'package:flutter_torrent_streamer_example/widgets/shimmer_view.dart';
import 'package:scoped_model/scoped_model.dart';

class CarouselView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(child: apiresponse());
  }

  Widget apiresponse() {
    return ScopedModelDescendant<MovieModel>(
      builder: (context, _, model) {
        var jsonResult = model.nowPlayingRespo;
        if (jsonResult.status == ApiStatus.COMPLETED)
          return CarouselSlider.builder(
            itemCount: jsonResult.data.results.length,
            itemBuilder: (BuildContext context, int itemIndex) => getSliderItem(
                context, itemIndex, jsonResult.data.results[itemIndex]),
            options: CarouselOptions(
              aspectRatio: 2.0,
//          enlargeCenterPage: true,
              scrollDirection: Axis.horizontal,
              autoPlay: true,
            ),
          );
        else
          return apiHandler(
              loading: ShimmerView(viewType: ShimmerView.VIEW_CASOSAL),
              response: jsonResult);
      },
    );
  }

  Widget getSliderItem(BuildContext context, int itemIndex, NowPlayResult result) {
    String tag = result.title + "Carosal" + itemIndex.toString();
    String img = ApiConstant.IMAGE_POSTER + result.poster_path;
    return fullListImage(
        name: result.title,
        image: img,
        tag: tag,
        onTap: () {
          navigationPush(
            context,
            DetailsMovieScreen(result.title, img,
                result.title, itemIndex, result.id, tag),
          );
        });
  }
}

Widget fullListImage({String name, String image, String tag, Function onTap}) {
  return SizedBox(
    height: 180,
    child: Container(
      height: 180,
      margin: EdgeInsets.all(5.0),
      child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          child: Stack(
            children: <Widget>[
              Hero(
                  tag: tag,
                  child: SizedBox(
                      height: 180,
                      width: double.infinity, child: getCacheImage(url:image, height: 180))),
              Positioned(
                bottom: 0.0,
                left: 0.0,
                right: 0.0,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color.fromARGB(200, 0, 0, 0),
                        Color.fromARGB(0, 0, 0, 0)
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                  child: Text(
                    name==null?"":name,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Positioned.fill(
                  child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                          splashColor: Colors.lightBlueAccent, onTap: () => onTap()))),
            ],
          )),
    ),
  );
}