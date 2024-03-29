import 'package:flutter_torrent_streamer_example/constant/api_constant.dart';
import 'package:flutter_torrent_streamer_example/constant/string_constant.dart';
import 'package:flutter_torrent_streamer_example/data/details/credits_crew_repo.dart';
import 'package:flutter_torrent_streamer_example/data/home/movie_cat_repo.dart';
import 'package:flutter_torrent_streamer_example/data/home/now_playing_repo.dart';
import 'package:flutter_torrent_streamer_example/data/person/person_movie_repo.dart';
import 'package:flutter_torrent_streamer_example/data/person/trending_person.dart';
import 'package:flutter_torrent_streamer_example/models/movie_model.dart';
import 'package:flutter_torrent_streamer_example/utils/apiutils/api_response.dart';
import 'package:flutter_torrent_streamer_example/utils/global_utility.dart';
import 'package:flutter_torrent_streamer_example/utils/widgethelper/widget_helper.dart';
import 'package:flutter_torrent_streamer_example/screens/home/new_home.dart';
import 'package:flutter_torrent_streamer_example/person/person_detail.dart';
import 'package:flutter_torrent_streamer_example/widgets/caraousel_view.dart';
import 'package:flutter_torrent_streamer_example/widgets/movie_cast_crew.dart';
import 'package:flutter_torrent_streamer_example/widgets/shimmer_view.dart';
import 'package:flutter_torrent_streamer_example/widgets/trending_movie_row.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:scoped_model/scoped_model.dart';

class MovieListScreen extends StatefulWidget {
  String apiName, dynamicList, titleTag;
  int movieId;

  MovieListScreen(
      {this.apiName, this.dynamicList, this.movieId, this.titleTag});

  @override
  _MovieListScreenState createState() =>
      _MovieListScreenState(apiName, dynamicList, movieId, titleTag);
}

class _MovieListScreenState extends State<MovieListScreen> {
  _MovieListScreenState(
      this.apiName, this.dynamicList, this.movieId, this.titleTag);

  int movieId;
  String castCrewTitle, titleTag;
  MovieModel model;
  String apiName, dynamicList;
  List<NowPlayResult> dataResult = new List();
  ScrollController _scrollController = new ScrollController();
  int total_pages = 1;
  int pageSize = 1;

  @override
  void initState() {
    super.initState();
    model = MovieModel();
    callMovieApi(apiName, model, movieId: movieId, page: pageSize);
    _scrollController.addListener(() {
      // debugPrint(
      //     "pixels : ${_scrollController.position
      //         .pixels}  \n maxScrollExtent : ${_scrollController.position
      //         .maxScrollExtent}");
      if (_scrollController.position.pixels > 0 &&
          _scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent) {
        if (pageSize <= total_pages)
          callMovieApi(apiName, model, movieId: movieId, page: pageSize);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var homeIcon = IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          color: Colors.black54,
        ),
        onPressed: () => Navigator.pop(context));
    return Scaffold(
        appBar: getAppBarWithBackBtn(
            ctx: context,
            title: getTitle(dynamicList != null ? dynamicList : apiName),
            bgColor: Colors.white,
            titleTag: titleTag,
            icon: homeIcon),
        body: OrientationBuilder(
            builder: (context, orientation) =>
                ScopedModel(model: model, child: apiresponse(orientation))));
  }

  Widget apiresponse(Orientation orientation) {
    return ScopedModelDescendant<MovieModel>(
      builder: (context, _, model) {
        var jsonResult = getData(apiName, model);
        if (jsonResult.status == ApiStatus.COMPLETED) {
          return getCount(jsonResult.data) > 0
              ? _createUi(jsonResult.data, orientation)
              : Container();
        } else
          return apiHandler(
              loading: ShimmerView(
                apiName: apiName,
                viewType: ShimmerView.VIEW_CATEGORY,
              ),
              response: jsonResult);
      },
    );
  }

  Widget _createUi(data, Orientation orientation) {
    if (data is NowPlayingRespo) {
      pageSize++;
      total_pages = data.total_pages;
      dataResult.addAll(data.results);
    }
    final size = MediaQuery.of(context).size;
    final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
    final double itemWidth = size.width / 2;

    int columnCount = orientation == Orientation.portrait ? data is NowPlayingRespo?2:3 : data is NowPlayingRespo?4:4;
    return Container(
//      width: double.infinity,
//      height: double.infinity,
        child: Container(
          alignment: Alignment.center,
          child: data is MovieCatRespo
              ? ListView.builder(
              physics: BouncingScrollPhysics(),
              itemCount: getCount(data),
              itemBuilder: (BuildContext context, int index) {
                return getItemView(data, index);
              })
              : StaggeredGridView.countBuilder(
            crossAxisCount: columnCount,
            mainAxisSpacing: 1.0,
            crossAxisSpacing: 1.0,
            staggeredTileBuilder: (int index) => StaggeredTile.extent(1, data is NowPlayingRespo?290:128),
            physics: BouncingScrollPhysics(),
            controller: _scrollController,
            itemCount:
            data is NowPlayingRespo ? dataResult.length : getCount(data),
            itemBuilder: (BuildContext context, int index) => Padding(
              padding: const EdgeInsets.only(left: 5, right: 5),
              child: getItemView(data, index, dataResult: dataResult),
            ),
          ),
        ));
  }

  int getCount(result) {
    if (apiName == StringConst.MOVIE_CAST && result is CreditsCrewRespo)
      return result.cast.length;
    else if (apiName == StringConst.MOVIE_CREW && result is CreditsCrewRespo)
      return result.crew.length;
    else if (result is TrandingPersonRespo)
      return result.results.length;
    else if (result is NowPlayingRespo) return result.results.length;
    if (apiName == StringConst.PERSON_MOVIE_CAST && result is PersonMovieRespo)
      return result.cast.length;
    else if (apiName == StringConst.PERSON_MOVIE_CREW &&
        result is PersonMovieRespo)
      return result.crew.length;
    else if (result is MovieCatRespo)
      return result.genres.length;
    else
      return 1;
  }

  Widget getItemView(data, int index, {List<NowPlayResult> dataResult}) {
    try {
      if (data is CreditsCrewRespo) return getPersonDetails(data, index);
      if (data is TrandingPersonRespo) {
        var result = data.results[index];
        var tag = apiName + 'tranding' + index.toString();
        return castCrewItem(
            id: result.id,
            name: result.name,
            tag: tag,
            image: result.profilePath,
            job: result.knownForDepartment,
            onTap: (int id) => navigationPush(
                context,
                PersonDetail(
                    id: id,
                    name: result.name,
                    imgPath: ApiConstant.IMAGE_POSTER + result.profilePath,
                    tag: tag)));
      } else if (data is NowPlayingRespo) {
        // NowPlayResult item = data.results[index];
        NowPlayResult item = dataResult[index];

        return getMovieItemRow(
            context: context,
            apiName: apiName,
            index: index,
            height: 250,
            width: 135,
            id: item.id,
            img: item.poster_path,
            name: item.title,
            vote: item.vote_average);
      } else if (apiName == StringConst.PERSON_MOVIE_CAST &&
          data is PersonMovieRespo) {
        PersonCast item = data.cast[index];
        return getMovieItemRow(
            context: context,
            apiName: apiName,
            index: index,
            height: 240,
            width: 135,
            id: item.id,
            img: item.posterPath,
            name: item.title,
            vote: item.voteAverage);
      } else if (apiName == StringConst.PERSON_MOVIE_CREW &&
          data is PersonMovieRespo) {
        PersonCrew item = data.crew[index];
        return getMovieItemRow(
            context: context,
            apiName: apiName,
            index: index,
            height: 240,
            width: 135,
            id: item.id,
            img: item.posterPath,
            name: item.title,
            vote: item.voteAverage);
      } else if (apiName == ApiConstant.GENRES_LIST && data is MovieCatRespo) {
        Genres item = data.genres[index];
        String tag = getTitle(apiName) + item.name + index.toString();
        return fullListImage(
            name: item.name,
            image: getCategoryMovie()[index],
            tag: tag,
            onTap: () {
              navigationPush(
                  context,
                  MovieListScreen(
                      apiName: StringConst.MOVIE_CATEGORY,
                      dynamicList: item.name,
                      movieId: item.id));
            });
      } else
        Container(
          child: getTxt(msg: 'Data not found'),
        );
    } catch (ex) {
      return Card(
          clipBehavior: Clip.antiAlias,
          color: Colors.blueGrey);
    }
  }

  Widget getPersonDetails(CreditsCrewRespo results, int index) {
    String image = apiName == StringConst.MOVIE_CAST
        ? results.cast[index].profilePath
        : results.crew[index].profilePath;
    String name = apiName == StringConst.MOVIE_CAST
        ? results.cast[index].name
        : results.crew[index].name;
    String chatactor = apiName == StringConst.MOVIE_CAST
        ? results.cast[index].character
        : results.crew[index].job;
    int id = apiName == StringConst.MOVIE_CAST
        ? results.cast[index].id
        : results.crew[index].id;
    var tag = apiName + 'cast_crew list' + index.toString();
    return castCrewItem(
        id: id,
        name: name,
        tag: tag,
        image: image,
        job: chatactor,
        onTap: (int id) => navigationPush(
            context,
            PersonDetail(
                id: id,
                name: name,
                imgPath: ApiConstant.IMAGE_POSTER + image,
                tag: tag)));
  }
}