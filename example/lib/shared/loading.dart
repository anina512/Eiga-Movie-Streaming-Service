import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_torrent_streamer_example/constant.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: kBlack,
      child: Center(
        child: SpinKitChasingDots(
          color: kRed,
          size: 30,
        ),
      ),
    );
  }
}
