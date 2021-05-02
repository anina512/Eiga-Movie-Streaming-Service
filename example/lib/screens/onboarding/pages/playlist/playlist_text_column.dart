import 'package:flutter/material.dart';

import 'package:flutter_torrent_streamer_example/screens/onboarding/widgets/text_column.dart';

class WorkTextColumn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextColumn(
      title: 'Get Recommendations',
      text:
      'If you long for movies like the one you watched, fret not! We\'ve got similar, awesome movies just for you! :)',
    );
  }
}