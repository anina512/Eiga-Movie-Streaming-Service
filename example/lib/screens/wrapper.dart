import 'package:flutter/material.dart';
import 'package:flutter_torrent_streamer_example/models/user.dart';
import 'package:flutter_torrent_streamer_example/screens/authenticate/authenticate.dart';
import 'package:flutter_torrent_streamer_example/screens/home/home.dart';
import 'package:flutter_torrent_streamer_example/services/auth.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final user= Provider.of<Users>(context);
    // home or authenticate
    if (user==null){
      return Authenticate();
    }
    else{
      return Home();
    }
  }
}
