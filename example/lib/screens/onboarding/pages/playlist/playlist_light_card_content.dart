import 'package:flutter/material.dart';

import 'package:flutter_torrent_streamer_example/constant.dart';
import 'package:flutter_torrent_streamer_example/screens/onboarding/widgets/icon_container.dart';

class WorkLightCardContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        IconContainer(
          icon: Icons.event_seat,
          padding: kPaddingS,
        ),
        IconContainer(
          icon: Icons.live_tv_outlined,
          padding: kPaddingM,
        ),
        IconContainer(
          icon: Icons.playlist_add_check_rounded,
          padding: kPaddingS,
        ),
      ],
    );
  }
}