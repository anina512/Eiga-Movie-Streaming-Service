import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_torrent_streamer_example/constant.dart';
import 'package:flutter_torrent_streamer_example/screens/login/widgets/fade_slide_transition.dart';
import 'package:flutter_torrent_streamer_example/widgets/logo.dart';

class Header extends StatelessWidget {
  final Animation<double> animation;

  const Header({
    @required this.animation,
  }) : assert(animation != null);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kPaddingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Logo(
            color: kBlue,
            size: 48.0,
          ),
          const SizedBox(height: kSpaceM),
          FadeSlideTransition(
            animation: animation,
            additionalOffset: 0.0,
            child: Text(
              'Welcome to Eiga',
              style: Theme.of(context)
                  .textTheme
                  .headline5
                  .copyWith(color: kWhite, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: kSpaceS),
          FadeSlideTransition(
            animation: animation,
            additionalOffset: 16.0,
            child: Text(
              'Watch movies anytime, anywhere.',
              style: Theme.of(context)
                  .textTheme
                  .subtitle1
                  .copyWith(color: kWhite.withOpacity(0.5)),
            ),
          ),
        ],
      ),
    );
  }
}