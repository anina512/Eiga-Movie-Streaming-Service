import 'package:flutter/material.dart';

import 'package:flutter_torrent_streamer_example/screens/onboarding/widgets/text_column.dart';

class CommunityTextColumn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextColumn(
      title: 'Stream Together',
      text:
      'Watch your favourite movies together with your friends.',
    );
  }
}