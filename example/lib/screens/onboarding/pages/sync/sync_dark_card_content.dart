import 'package:flutter/material.dart';

import 'package:flutter_torrent_streamer_example/constant.dart';

class CommunityDarkCardContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: kPaddingL),
          child: Icon(
            Icons.fastfood ,
            color: kWhite,
            size: 32.0,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: kPaddingL),
          child: Icon(
            Icons.connected_tv,
            color: kWhite,
            size: 32.0,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: kPaddingL),
          child: Icon(
            Icons.fast_rewind_rounded ,
            color: kWhite,
            size: 32.0,
          ),
        ),
      ],
    );
  }
}