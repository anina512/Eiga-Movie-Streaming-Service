import 'package:flutter_torrent_streamer/flutter_torrent_streamer.dart';
import 'package:flutter/material.dart';



class TorrentStreamerView extends StatefulWidget {
  @override
  _TorrentStreamerViewState createState() => _TorrentStreamerViewState();
}

class _TorrentStreamerViewState extends State<TorrentStreamerView> {
  TextEditingController _controller;
  String torrentLink;

  bool isDownloading = false;
  bool isStreamReady = false;
  bool isFetchingMeta = false;
  bool hasError = false;
  Map<dynamic, dynamic> status;
  Map torrentLinkData = {};

  @override
  void initState() {
    super.initState();

    _controller = TextEditingController();
    _addTorrentListeners();
  }

  @override
  void dispose() {
    TorrentStreamer.stop();
    TorrentStreamer.removeEventListeners();

    super.dispose();
  }

  void resetState() {
    setState(() {
      isDownloading = false;
      isStreamReady = false;
      isFetchingMeta = false;
      hasError = false;
      status = null;
    });
  }

  void _addTorrentListeners() {
    TorrentStreamer.addEventListener('started', (_) {
      resetState();
      setState(() {
        isDownloading = true;
        isFetchingMeta = true;
      });
    });

    TorrentStreamer.addEventListener('prepared', (_) {
      setState(() {
        isDownloading = true;
        isFetchingMeta = false;
      });
    });

    TorrentStreamer.addEventListener('progress', (data) {
      setState(() => status = data);
    });

    TorrentStreamer.addEventListener('ready', (_) {
      setState(() => isStreamReady = true);
    });

    TorrentStreamer.addEventListener('stopped', (_) {
      resetState();
    });

    TorrentStreamer.addEventListener('error', (_) {
      setState(() => hasError = true);
    });
  }

  int _toKBPS(double bps) {
    return (bps / (8 * 1024)).floor();
  }

  Future<void> _cleanDownloads(BuildContext context) async {
    await TorrentStreamer.clean();
    // Scaffold.of(context).showSnackBar(
    //     SnackBar(
    //         content: Text('Cleared torrent cache!')
    //     )
    // );
  }

  Future<void> _startDownload() async {
    await TorrentStreamer.stop();
    await TorrentStreamer.start(torrentLink);
  }

  Future<void> _openVideo(BuildContext context) async {
    if (isCompleted) {
      await TorrentStreamer.launchVideo();
    } else {
      showDialog(
          builder: (BuildContext context) {
            return AlertDialog(
              title: new Text('Are You Sure?'),
              content: new Text(
                  'Playing video while it is still downloading is experimental '  +
                      'and only works on limited set of apps.'
              ),
              actions: <Widget>[



                new FlatButton(
                  child: new Text("Cancel"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                new FlatButton(
                  child: new Text("Yes, Proceed"),
                  onPressed: () async {
                    await TorrentStreamer.launchVideo();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
          context: context
      );
    }
  }

  Widget _buildInput(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            RaisedButton(
              child: Text('Download'),
              color: Colors.blue,
              onPressed: _startDownload,
            ),
            SizedBox(width: 20),
            OutlineButton(
              child: Text('Clear Cache'),
              onPressed: () => _cleanDownloads(context),
            ),
          ],
          mainAxisAlignment: MainAxisAlignment.center,
        )
      ],
    );
  }

  Widget _buildTorrentStatus(BuildContext context) {
    if (hasError) {
      return Text('Failed to download torrent!');
    } else if (isDownloading) {
      String statusText = '';
      if (isFetchingMeta) {
        statusText = 'Fetching meta data';
      } else {
        statusText = 'Progress: ${progress.floor().toString()}% - ' +
            'Speed: ${_toKBPS(speed)} KB/s';
      }

      return Column(
            children: <Widget>[
              Text(statusText),
              LinearProgressIndicator(
                  value: !isFetchingMeta ? progress / 100 : null
              ),
              Row(
                children: <Widget>[
                  RaisedButton(
                      child: Text('Play Video'),
                      color: Colors.blue,
                      onPressed: isStreamReady ? () => _openVideo(context) : null
                  ),
                  OutlineButton(
                    child: Text('Stop Download'),
                    onPressed: TorrentStreamer.stop,
                  ),
                ],
                mainAxisAlignment: MainAxisAlignment.center,
              )
            ],
        );
    } else {
      return Container(height: 0, width: 0);
    }
  }
  @override
  Widget build(BuildContext context) {
    torrentLinkData= ModalRoute.of(context).settings.arguments;
    torrentLink=torrentLinkData['torrentLink'];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0,
        title: Text('Download'),
      ),
      body: Column(
        children: <Widget>[
          _buildInput(context),
          SizedBox(height: 20,),
          _buildTorrentStatus(context)
        ],
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
      ),

    );
  }

  bool get isCompleted => progress == 100;

  double get progress => status != null ? status['progress'] : 0;

  double get speed => status != null ? status['downloadSpeed'] : 0;
}