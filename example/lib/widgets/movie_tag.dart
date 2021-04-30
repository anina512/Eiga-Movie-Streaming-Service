import 'package:flutter/widgets.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:flutter_torrent_streamer_example/constant/string_constant.dart';
import 'package:flutter_torrent_streamer_example/data/details/movie_details_repo.dart';
import 'package:flutter_torrent_streamer_example/utils/widgethelper/widget_helper.dart';
import 'package:flutter_torrent_streamer_example/listin/movie_list_screen.dart';
import 'package:flutter_torrent_streamer_example/widgets/shimmer_view.dart';
import 'package:flutter_torrent_streamer_example/constant.dart';

class MovieTag extends StatelessWidget {
  const MovieTag({
    Key key,
    @required List<Genres> items,
    Color textColor,
    Color borderColor,
  })  : _items = items,
        _textColor = textColor,
        _borderColor = borderColor,
        super(key: key);

  final List<Genres> _items;
  final Color _textColor;
  final Color _borderColor;

  @override
  Widget build(BuildContext context) {
    if (_items == null)
      return ShimmerView.movieDetailsTag();
    else
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Tags(
          itemCount: _items.length, // required
          itemBuilder: (int index) {
            final item = _items[index];
            return ItemTags(
                key: Key(index.toString()),
                index: index,
                // required
                title: item.name,
                color: kWhite,
                active: false,
                textStyle: TextStyle(fontSize: 12),
                elevation: 0,
                textColor:kRed,
                border: Border.all(
                  color: kBlack,
                ),
                onLongPressed: null,
                onPressed: (datte) => navigationPush(
                    context,
                    MovieListScreen(
                        apiName: StringConst.MOVIE_CATEGORY,
                        dynamicList: item.name,
                        movieId: item.id)));
          },
        ),
      );
  }
}