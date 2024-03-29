import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_torrent_streamer_example/constant/api_constant.dart';
import 'package:flutter_torrent_streamer_example/constant/assets_constant.dart';
import 'package:flutter_torrent_streamer_example/constant/string_constant.dart';
import 'package:flutter_torrent_streamer_example/data/home/now_playing_repo.dart';
import 'package:flutter_torrent_streamer_example/models/movie_model.dart';
import 'package:flutter_torrent_streamer_example/utils/apiutils/api_response.dart';
import 'package:flutter_torrent_streamer_example/utils/widgethelper/widget_helper.dart';
import 'package:flutter_torrent_streamer_example/details/detail_movie.dart';
import 'package:flutter_torrent_streamer_example/widgets/rating_result.dart';
import 'package:flutter_torrent_streamer_example/widgets/trending_movie_row.dart';
import 'package:scoped_model/scoped_model.dart';

import '../constant.dart';
import '../constant.dart';
import '../constant.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  MovieModel model;
  String query = ' ';

  BuildContext ctx;
  List<NowPlayResult> dataResult = new List();
  ScrollController _scrollController = new ScrollController();
  bool isLoading = false;
  final TextEditingController searchController = TextEditingController();
  int total_pages = 1;
  int pageSize = 1;
  @override
  void initState() {
    model = MovieModel();
    model.serachMovies(searchController.text.toString(), pageSize, true);
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels > 0 &&
          _scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent) {
        if (pageSize <= total_pages) model.serachMovies(searchController.text.toString(), pageSize, false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ctx = context;
    var homeIcon = IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          color: Colors.black54,
        ),
        onPressed: () => Navigator.pop(context));
    return Scaffold(
      // appBar: getAppBarWithBackBtn(
      //     ctx: context,
      //     title: getTitle('SearchMovie'),
      //     bgColor: ColorConst.WHITE_BG_COLOR,
      //     titleTag: 'Search mOivie',
      //     icon: homeIcon),
      backgroundColor: kBlack,
        body: Container(
          child: Column(
            children: [
              SizedBox(height: 30),
              PreferredSize(
                child: Container(
                  child: Card(
                    color: kRed,
                    child: TextField(
                      style: TextStyle(color: kWhite),
                      cursorColor: kWhite,
                      onChanged: (String query) {
                        pageSize = 1;
                        query = query;
                        dataResult.clear();
                        model.serachMovies(query, pageSize, true);
                      },
                      autofocus: true,
                      controller: searchController,
                      decoration: InputDecoration(                          
                          border: InputBorder.none,
                          hintText: "Search Movies",
                          fillColor: kWhite,
                          contentPadding: EdgeInsets.fromLTRB(10, 15, 10, 10),
                          hintStyle: TextStyle(color: Color.fromARGB(150, 255, 255, 255),fontSize: 20,),
                          icon: IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: Icon(Icons.arrow_back_ios), color: kWhite,),
                          suffixIcon: IconButton(
                              onPressed: () => searchController.clear(),
                              icon: Icon(Icons.close_rounded,color: kWhite))),
                    ),
                  ),
                ),
                preferredSize: Size.fromHeight(80.0),
              ),
              Container(child: ScopedModel(model: model, child: apiresponse())),
            ],
          ),
        ));
    // _createUi(null));
    //
  }

  Widget apiresponse() {
    return ScopedModelDescendant<MovieModel>(
      builder: (context, _, model) {
        var jsonResult = model.searchMovieRespo;
        if (jsonResult.status == ApiStatus.COMPLETED) {
          return jsonResult.data.total_results > 0 || dataResult.length > 0
              ? _createUi(jsonResult.data)
              : Column(children: [
            SizedBox(height: 50),
            Container(
                height: 200,
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top,
                    left: 16,
                    right: 16),
                child: Image.asset(' assets/images/help.jpg')),
            getTxtBlackColor(
                msg: StringConst.NO_DATA_FOUND,
                fontSize: 20,
                fontWeight: FontWeight.bold),
          ]);
        } else
          return Container();
      },
    );
  }

  Widget _createUi(NowPlayingRespo data) {
    pageSize++;
    total_pages = data.total_pages;
    dataResult.addAll(data.results);
    return Expanded(
      child: ListView.separated(
          physics: BouncingScrollPhysics(),
          controller: _scrollController,
          itemCount: dataResult.length,
          separatorBuilder: (context, index) {
            return Container(
                margin: EdgeInsets.only(left: 18, right: 5),
                child: getDivider());
          },
          itemBuilder: (BuildContext context, int index) {
            NowPlayResult data = dataResult[index];
            return getMovieItemRow(
                context: ctx,
                index: index,
                id: data.id,
                img: data.poster_path.toString(),
                //"/yGSxMiF0cYuAiyuve5DA6bnWEOI.jpg",
                name: data.title,
                desc: data.overview,
                vote: data.vote_average);
          }),
    );
  }

  Widget getMovieItemRow(
      {BuildContext context,
        int index,
        int id,
        String img,
        String name,
        String desc,
        var vote}) {
    String tag = StringConst.SEARCH_MOVIE + img + index.toString();
    return GestureDetector(
      onTap: () {
        navigationPush(
            context,
            DetailsMovieScreen(name, ApiConstant.IMAGE_POSTER + img,
                StringConst.SEARCH_MOVIE, index, id, tag));
      },
      child: Container(
        margin: EdgeInsets.only(left: 5, right: 5, top: 8, bottom: 8),
        child: Hero(
          tag: tag,
          child: Row(
            children: <Widget>[
              Stack(
                children: [
                  SizedBox(
                    width: 100,
                    height: 150,
                    child: ClipRRect(
                      child: getCacheImage(
                          url: ApiConstant.IMAGE_POSTER + img.toString(),
                          height: 120),
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  Positioned.fill(
                      child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                              splashColor: Colors.redAccent,
                              onTap: () {
                                navigationPush(
                                    context,
                                    DetailsMovieScreen(
                                        name,
                                        ApiConstant.IMAGE_POSTER + img,
                                        StringConst.SEARCH_MOVIE,
                                        index,
                                        id,
                                        tag));
                              }))),
                ],
              ),
              SizedBox(width: 5),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    getTxtBlackColor(
                        msg: name,
                        maxLines: 1,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        textAlign: TextAlign.start),
                    getTxtGreyColor(
                        msg: desc,
                        maxLines: 5,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        textAlign: TextAlign.start),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        RatingResult(vote, 12.0),
                        SizedBox(width: 5),
                        RatingBar(
                          itemSize: 12.0,
                          initialRating: vote / 2,
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemPadding: EdgeInsets.symmetric(horizontal: 2.0),

                          onRatingUpdate: (rating) {
                            print(rating);
                          },
                        )
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}