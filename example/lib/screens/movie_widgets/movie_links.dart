import 'package:flutter/material.dart';
import 'package:flutter_torrent_streamer_example/constant.dart';
class MovieLinks extends StatefulWidget {
  @override
  _MovieLinksState createState() => _MovieLinksState();
}

class _MovieLinksState extends State<MovieLinks> {

  Map movieLinkData = {};
  List linksList = [];
  String title;

  @override
  Widget build(BuildContext context) {
    movieLinkData = ModalRoute
        .of(context)
        .settings
        .arguments;
    linksList = movieLinkData["magnetLinkList"];
    title = movieLinkData["movieTitle"];
    return Scaffold(
      backgroundColor: kBlack,
      appBar: AppBar(
        title: Text("Links for $title"),
        backgroundColor: kRed,
        elevation: 0,
      ),

      body: ListView.separated(
        padding: EdgeInsets.only(top: 20),
        itemCount: linksList.length,
        itemBuilder: (context, index) {
          //Dictionary to get info of that particular link
          final link = linksList[index];
          return Card(
            child: ListTile(
              leading: Icon(
                Icons.movie,
                color:kRed,),
                title: Text(
                  "${link["name"]} ", style: TextStyle(fontSize: 15),),
                subtitle: Text(
                    "Seeders:${link["seeders"]}                Leechers:${link["leechers"]}                    Files:${link["num_of_files"]} "),
              onTap: () {
                print(link['magnet_link']);
                Navigator.pushNamed(context, '/play-torrent',arguments: {'torrentLink': link["magnet_link"]});
              },
            ),
          );
        },
        separatorBuilder: (context, index) {
          return Divider();
        },
      ),
    );
  }
}

