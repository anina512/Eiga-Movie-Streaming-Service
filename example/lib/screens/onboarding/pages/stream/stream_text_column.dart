import 'package:flutter/material.dart';

import 'package:flutter_torrent_streamer_example/screens/onboarding/widgets/text_column.dart';

class EducationTextColumn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextColumn(
      title: 'Watch Movies',
      text: 'Download and Stream your favourite movies, anytime and anywhere.',
    );
  }
}