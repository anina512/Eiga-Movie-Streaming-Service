import 'package:flutter/material.dart';
import 'package:flutter_torrent_streamer_example/models/user.dart';
import 'package:flutter_torrent_streamer_example/like_movie/movie_like.dart';
import 'package:flutter_torrent_streamer_example/screens/authenticate/authenticate.dart';
import 'package:flutter_torrent_streamer_example/screens/home/home.dart';
import 'package:flutter_torrent_streamer_example/screens/home/new_home.dart';
import 'package:flutter_torrent_streamer_example/services/auth.dart' as auth;
import 'package:provider/provider.dart';
import 'package:flutter_torrent_streamer_example/screens/authenticate/mobile.dart';

class WrapperMobile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final user= Provider.of<Users>(context);
    // home or authenticate
    if (user==null){
      return MobileAuth();
    }
    else{
      print(auth.custom_user.firstTimeLogin);
      if(auth.custom_user.firstTimeLogin==true)
      {
        print("movie like");
        return MovieLikeScreen();
      }
      else
      {
        print("home");
        return HomeScreen();
        //return MovieLikeScreen();
      }
    }
  }
}
