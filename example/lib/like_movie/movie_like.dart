import 'package:flutter_torrent_streamer_example/constant.dart';
import 'package:flutter_torrent_streamer_example/constant/assets_constant.dart';
import 'package:flutter_torrent_streamer_example/constant/string_constant.dart';
import 'package:flutter_torrent_streamer_example/utils/sp/sp_manager.dart';
import 'package:flutter_torrent_streamer_example/utils/widgethelper/widget_helper.dart';
import 'package:flutter_torrent_streamer_example/screens/home/new_home.dart';
import 'package:flutter_torrent_streamer_example/like_movie/adapt.dart';
import 'package:flutter_torrent_streamer_example/like_movie/item_like.dart';
import 'package:flutter_torrent_streamer_example/like_movie/keepalive_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_torrent_streamer_example/services/auth.dart' as auth;

Map genreList;
class MovieLikeScreen extends StatefulWidget {
  @override
  _MovieLikeScreenState createState() => _MovieLikeScreenState();
}

class _MovieLikeScreenState extends State<MovieLikeScreen> {
  static Map<int, bool> _movieGenres = Map<int, bool>();
  static PageController pageController = new PageController();

  static BuildContext ctx;

  @override
  void initState() {
    super.initState();
    movieList.keys.forEach((e) => _movieGenres[e] = false);

  }

  @override
  Widget build(BuildContext context) {
    Adapt.initContext(context);
    ctx = context;
    return Scaffold(
        body: PageView.builder(
          physics: NeverScrollableScrollPhysics(),
          controller: pageController,
          allowImplicitScrolling: false,
          itemCount: pages.length,
          itemBuilder: (context, index) {
            return _buildPage(pages[index]);
          },
        ));
  }

  Widget _buildPage(Widget page) {
    return KeepAliveWidget(page);
  }

  final pages = [
    _FirstPage(
      continueTapped: () => pageController.nextPage(
          duration: Duration(milliseconds: 400), curve: Curves.ease),
    ),
    _SubscribeTopicPage(
        title: StringConst.MOVIE_DO_YOU_LIKE,
        buttonTitle: 'next',
        tag: 'movie_',
        isMovie: true,
        genres: _movieGenres,
        backTapped: () => pageController.previousPage(
            duration: Duration(milliseconds: 400), curve: Curves.ease),
        nextTapped: () {
          for(int i=0; i<genreList.length; i++)
          {
            genreList.forEach((k,v) {
              if (v == true) {
                if(!auth.custom_user.genres.contains(movieList[k]))
                  {
                    if(!auth.custom_user.genres.contains(k))
                      {
                        auth.custom_user.genres.add(k);
                      }
                  }
              }
            }
            );
          }
          SPManager.setOnboarding(true);
          navigationPushReplacement(ctx, HomeScreen());
          print(auth.custom_user.genres);
        }),

  ];
}

class _FirstPage extends StatelessWidget {
  final Function continueTapped;

  const _FirstPage({this.continueTapped});

  @override
  Widget build(BuildContext context) {
    return Container(
        color: kBlack,
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Container(
                child: Column(children: [
                  SizedBox(height: 20),
                  SizedBox(
                      width: 280,
                      height: 250, //Adapt.px(500),
                      child: Image.asset('assets/images/popcorn.gif')),
                  Text( "Konnichi wa!",style: TextStyle(fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color:kPink,)),
                  SizedBox(height: 5),
                  Text( "こんにちわ !",style: TextStyle(fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color:kPink,)),
                  SizedBox(height: 5),
                  Text( "We would love to know about you!",style: TextStyle(fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color:kPink,)),
                  SizedBox(height: 20),
                  Container(
                    margin: EdgeInsets.only(left: 10, right: 10),
                    child: getTxtBlackColor(
                        msg: StringConst.DUMMY_TEXT_SHORT,
                        fontSize: 16,
                        textAlign: TextAlign.center,
                        ),
                  ),
                  SizedBox(height: 100),
                  GestureDetector(
                      onTap: continueTapped,
                      child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 50),
                          height: 50,
                          decoration: BoxDecoration(
                              color: kRed,
                              borderRadius: BorderRadius.circular(30)),
                          child: Center(
                            child: getTxtColor(
                                msg: 'Continue',
                                fontSize: 20,

                                txtColor: Colors.white),
                          ))),
                  SizedBox(height: 40)
                ]),
              ),
            ),
          ),
        ));
  }
}

class _SubscribeTopicPage extends StatefulWidget {
  final String title;
  final String buttonTitle;
  final bool isMovie;
  final String tag;
  final Function backTapped;
  final Function nextTapped;
  final Map<int, bool> genres;

  _SubscribeTopicPage(
      {this.backTapped,
        this.nextTapped,
        this.genres,
        this.isMovie,
        @required this.title,
        @required this.buttonTitle,
        this.tag});

  @override
  _SubscribeTopicPageState createState() => _SubscribeTopicPageState();
}

class _SubscribeTopicPageState extends State<_SubscribeTopicPage> {
  final List<ItemLike> _genres = List<ItemLike>();

  @override
  void initState() {
    final _genresMap = movieList;
    _genresMap.forEach((key, value) {
      _genres.add(ItemLike.fromParams(name: value, value: key));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color:kRed,
        child: SafeArea(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SizedBox(height: Adapt.px(80)),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: Adapt.px(50)),
                child: getTxtColor(
                    msg:"What kind of movies do you like?",
                    fontSize: 28,
                    textAlign: TextAlign.center,
                    txtColor: kBlack,
                    )),
            SizedBox(height: Adapt.px(60)),
            Expanded(
                child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: BouncingScrollPhysics(),
                    child: Wrap(
                      direction: Axis.vertical,
                      runSpacing: Adapt.px(10),
                      spacing: Adapt.px(20),
                      children: _genres.map<Widget>((d) {
                        final _index = _genres.indexOf(d);
                        bool _selected = widget.genres[d.value];
                        return GestureDetector(
                            key: ValueKey(d.name),
                            onTap: () {
                              _selected = !_selected;
                              widget.genres[d.value] = _selected;
                              genreList = widget.genres;
                              setState(() {});
                            },
                            child: Container(
                              width: Adapt.px(200),
                              height: Adapt.px(200),
                              padding: EdgeInsets.all(Adapt.px(5)),
                              margin: EdgeInsets.only(
                                  top: (_index + 4) % 8 == 0 ? Adapt.px(80) : 0),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _selected
                                    ? Colors.redAccent
                                    : kBlack,
                              ),
                              child: Center(
                                  child: getTxtColor(
                                      msg: d.name,
                                      fontSize: Adapt.px(28),
                                      textAlign: TextAlign.center,
                                      fontWeight: FontWeight.w700,
                                      txtColor: _selected
                                          ? const Color(0xFFFFFFFF)
                                          : const Color(0xFF0000000))),
                            ));
                      }).toList()
                        ..add(Container(height: Adapt.px(900), width: Adapt.px(40)))
                        ..insert(0,
                            Container(height: Adapt.px(900), width: Adapt.px(40))),
                    ))),
            Row(children: [
              SizedBox(width: Adapt.px(80)),
              InkWell(
                  onTap: widget.backTapped,
                  child: SizedBox(
                      width: Adapt.px(100),
                      height: Adapt.px(80),
                      child: Center(
                          child: getTxtColor(
                              msg: '<',
                              fontSize: 30,
                              txtColor: kBlack,

                              fontWeight: FontWeight.w700)))),
              Expanded(child: SizedBox()),
              GestureDetector(
                  onTap: () async {

                    widget.nextTapped();
                  },
                  child: Container(
                    width: Adapt.px(250),
                    margin: EdgeInsets.symmetric(horizontal: Adapt.px(40)),
                    height: 50,
                    /*decoration: BoxDecoration(
                        color: const Color(0xFF202F39),
                        borderRadius: BorderRadius.circular(30)),*/
                    child: Center(
                        child: getTxtColor(
                            msg: '>',
                            fontSize: 30,
                            textAlign: TextAlign.center,
                            fontWeight: FontWeight.w700,
                            txtColor: kBlack)),
                  )),
            ]),
            SizedBox(height: Adapt.px(20))
          ]),
        ));
  }
}

final Map<int, String> movieList = {
  12: "Adventure",
  14: "Fantasy",
  16: "Animation",
  18: "Drama",
  27: "Horror",
  28: "Action",
  35: "Comedy",
  36: "History",
  37: "Western",
  53: "Thriller",
  80: "Crime",
  99: "Documentary",
  878: "Science_Fiction",
  9648: "Mystery",
  10402: "Music",
  10749: "Romance",
  10751: "Family",
  10752: "War",
  10762: "Kids",
  10763: "News",
  10764: "Reality",
  10766: "Soap",
  10767: "Talk",
  10770: "TV_Movie",
};