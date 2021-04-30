import 'package:flutter/material.dart';

import 'package:flutter_torrent_streamer_example/constant.dart';
import 'package:flutter_torrent_streamer_example/screens/onboarding/widgets/icon_container.dart';

class EducationLightCardContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        IconContainer(
          icon: Icons.fast_forward ,
          padding: kPaddingS,
        ),
        IconContainer(
          icon: Icons.local_movies,
          padding: kPaddingM,
        ),
        IconContainer(
          icon: Icons.movie_creation_rounded ,
          padding: kPaddingS,
        ),
      ],
    );
  }
}