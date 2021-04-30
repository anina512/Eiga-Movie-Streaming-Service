import 'package:flutter/material.dart';

import 'package:flutter_torrent_streamer_example/screens/onboarding/widgets/text_column.dart';

class WorkTextColumn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextColumn(
      title: 'Create Playlists',
      text:
      'Create playlists of your favourite movies to binge later.',
    );
  }
}