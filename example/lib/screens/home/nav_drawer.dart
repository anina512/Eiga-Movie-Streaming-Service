import 'package:flutter_torrent_streamer_example/constant/api_constant.dart';
import 'package:flutter_torrent_streamer_example/constant/string_constant.dart';
import 'package:flutter_torrent_streamer_example/utils/widgethelper/oval-right-clipper.dart';
import 'package:flutter_torrent_streamer_example/utils/widgethelper/widget_helper.dart';
import 'package:flutter_torrent_streamer_example/screens/home/new_home.dart';
import 'package:flutter_torrent_streamer_example/listin/movie_list_screen.dart';
import 'package:flutter_torrent_streamer_example/extras/about_us.dart';
import 'package:flutter_torrent_streamer_example/extras/feedback.dart';
import 'package:flutter_torrent_streamer_example/extras/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:flutter_torrent_streamer_example/screens/FAQ.dart';

import '../../constant.dart';
import '../../constant.dart';
import '../../constant.dart';

class NavDrawer extends StatelessWidget {
  BuildContext _context;

  @override
  Widget build(BuildContext context) {
    _context = context;
    return _buildDrawer();
  }

  _buildDrawer() {
    return ClipPath(
      clipper: OvalRightBorderClipper(),
      child: Drawer(
        child: Container(
          padding: const EdgeInsets.only(left: 16.0, right: 40),
          decoration: BoxDecoration(
              color: kPink,
              boxShadow: [BoxShadow(color: Colors.black45)]),
          width: 300,
          child: SafeArea(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                children: <Widget>[
                  Row(
                    children: [
                      Text(

                        "Menu", style: TextStyle(letterSpacing: 1.0, color:kBlack,fontSize: 25.0, fontWeight: FontWeight.w800),
                      ),
                      SizedBox(width: 125.0),
                      Container(
                        child: IconButton(
                            alignment: Alignment.centerRight,
                            icon: Icon(
                              Icons.close,
                              color: kBlack,
                            ),
                            onPressed: () => Navigator.of(_context).pop()),
                      ),
                    ],
                  ),
                  SizedBox(height: 5.0),
                  _buildRow(Icons.home, "Home"),
                  _buildDivider(),
                  _buildRow(Icons.category, "Category"),
                  _buildDivider(),
                  _buildRow(Icons.local_movies, "Trending Movie"),
                  _buildDivider(),
                  _buildRow(Icons.movie_filter, "Popular Movie"),
                  _buildDivider(),
                  _buildRow(Icons.movie, "Upcoming Movie"),
                  _buildDivider(),
                  _buildRow(Icons.question_answer, "FAQ"),
                  _buildDivider(),

                  SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Divider _buildDivider() {
    return Divider(
      color: Colors.blueGrey,
    );
  }

  Widget _buildRow(IconData icon, String title, {bool showBadge = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: InkWell(
        onTap: () => _navigateOnNextScreen(title),
        child: Row(children: [
          Icon(
            icon,
            color: kBlack,
          ),
          SizedBox(width: 10.0),
          getTxtColor(
              msg: title,
              txtColor: kBlack,
              fontSize: 16,
              fontWeight: FontWeight.w600),
          Spacer(),
          if (showBadge)
            Material(
              color: Colors.redAccent,
              elevation: 2.0,
              // shadowColor: ColorConst.APP_COLOR,
              borderRadius: BorderRadius.circular(15.0),
              child: Container(
                width: 10,
                height: 10,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.deepOrangeAccent,
                  borderRadius: BorderRadius.circular(5.0),
                ),
                // child: Text(
                //   "10+",
                //   style: TextStyle(
                //       color: Colors.white,
                //       fontSize: 12.0,
                //       fontWeight: FontWeight.bold),
                // ),
              ),
            )
        ]),
      ),
    );
  }

  void _navigateOnNextScreen(String title) {
    Navigator.of(_context).pop();
    switch (title) {
      case "Home":
      // navigationPush(_context, CategoryMovie());
        break;
      case "Category":
        navigationPush(
            _context, MovieListScreen(apiName: ApiConstant.GENRES_LIST));
        break;
      case "Trending Movie":
        navigationPush(_context,
            MovieListScreen(apiName: ApiConstant.TRENDING_MOVIE_LIST));
        break;
      case "Popular Movie":
        navigationPush(
            _context, MovieListScreen(apiName: ApiConstant.POPULAR_MOVIES));
        break;
      case "Upcoming Movie":
        navigationPush(
            _context, MovieListScreen(apiName: ApiConstant.UPCOMING_MOVIE));
        break;
        break;
      case "Settings":
        navigationPush(_context, SettingScreen());
        break;
      case "Share App":
        final RenderBox box = _context.findRenderObject();
        Share.share(
            '*${StringConst.APP_NAME}*\n${StringConst.SHARE_DETAILS}\n${StringConst.PLAYSTORE_URL}',
            sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
        break;
      case "Feedback":
        return navigationPush(_context, FeedbackScreen());
      case "FAQ":
        navigationPush(_context, FAQScreen());
        break;
      case "Exit":
        onWillPop(_context);
        break;
    }
  }
}