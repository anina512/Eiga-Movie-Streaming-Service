import 'package:flutter/material.dart';

import 'package:flutter_torrent_streamer_example/screens/onboarding/widgets/text_column.dart';

class CommunityTextColumn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextColumn(
      title: 'Discover Movies',
      text:
      'Explore our collection of the top rated, trending and upcoming movies. Uncover the treasure trove of the various genres and movie info.',
    );
  }
}