import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_torrent_streamer_example/data/details/video_repo.dart';
import 'package:flutter_torrent_streamer_example/models/movie_model.dart';
import 'package:flutter_torrent_streamer_example/utils/apiutils/api_response.dart';
import 'package:flutter_torrent_streamer_example/utils/widgethelper/widget_helper.dart';
import 'package:flutter_torrent_streamer_example/screens/home/new_home.dart';
import 'package:flutter_torrent_streamer_example/widgets/shimmer_view.dart';
import 'package:flutter_torrent_streamer_example/widgets/trending_movie_row.dart';
import 'package:flutter_torrent_streamer_example/widgets/video_player.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoView extends StatelessWidget {
  final apiName;

  VideoView(this.apiName);

  @override
  Widget build(BuildContext context) {
    return Container(child: apiresponse(context)); //getTradingList(context);
  }

  Widget apiresponse(BuildContext context) {
    return ScopedModelDescendant<MovieModel>(
      builder: (context, _, model) {
        var jsonResult = model.getMovieVideo;
        if (jsonResult.status == ApiStatus.COMPLETED)
          return jsonResult.data.results.length > 0
              ? getVideoTrailor(context, jsonResult.data.results)
              : Container();
        else
          return apiHandler(loading: ShimmerView(viewType: ShimmerView.VIEW_CASOSAL),response: jsonResult);
      },
    );
  }

  Widget getVideoTrailor(BuildContext context, List<Results> results) {
    final size = MediaQuery.of(context).size;
    return Column(
      children: <Widget>[
        SizedBox(height: 10),
        getHeading(context: context, apiName: apiName, isShowViewAll: false),
        SizedBox(height: 10),
        SizedBox(
          height: 190.0,
          child: ListView.builder(
            physics: BouncingScrollPhysics(),
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: results.length,
            itemBuilder: (context, index) {
              var item = results[index];
              return Container(
                width: size.width - 80,
                child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 4.0, vertical: 4.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Hero(
                          tag: getTitle(apiName) + index.toString(),
                          child: Stack(
                            children: [
                              Container(
                                height: 150,
                                width: size.width - 80,
                                child: ClipRRect(
                                  child: Image.network(
                                    'https://i.ytimg.com/vi/${item.key}/hqdefault.jpg',
                                    fit: BoxFit.cover,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              Positioned.fill(
                                child: Icon(
                                  Icons.play_circle_outline,
                                  color: Colors.white10,
                                  size: 50.0,
                                ),
                              ),
                              Positioned.fill(
                                  child: Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                          splashColor: Colors.white30,
                                          onTap: () {
                                            navigationPush(
                                                context,
                                                VideoPlayerScreen(
                                                  controller:
                                                  YoutubePlayerController(
                                                    initialVideoId: item.key,
                                                    flags: YoutubePlayerFlags(
                                                      autoPlay: true,
//                  mute: true,
                                                    ),
                                                  ),
                                                ));
                                          }))),
                            ],
                          ),
                        ),
                        SizedBox(height: 5),
                        Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: getTxtBlackColor(
                                msg: item.name,
                                fontSize: 15,
                                maxLines: 1,
                                fontWeight: FontWeight.w700)),
                      ],
                    )),

              );
            },
          ),
        ),
      ],
    );
  }
}