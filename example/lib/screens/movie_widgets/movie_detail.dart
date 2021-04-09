import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_torrent_streamer_example/models/movie.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MovieDetail extends StatefulWidget {

  @override
  _MovieDetailState createState() => _MovieDetailState();
}
//To show
class _MovieDetailState extends State<MovieDetail> {

  List _generateMagnetLinksFromInfoHash(List torrentList){
    List allMagnetLinks = [];
    int maxEntries = torrentList.length<10 ? torrentList.length : 10;
    for (int i= 0; i<maxEntries; i++)
      {
        Map magnetLinkList = {};
        Map torrentEntry = torrentList[i];
        String name = torrentEntry["name"];
        String info_hash = torrentEntry["info_hash"];
        name = name.replaceAll(" ", "%");
        //Magnet Link Format
        String magnetLink = ("magnet:?xt=urn:btih:"+ info_hash + "&dn="+ name + "&tr=http%3A%2F%2F125.227.35.196%3A6969%2Fannounce&tr=http%3A%2F%2F210.244.71.25%3A6969%2Fannounce&tr=http%3A%2F%2F210.244.71.26%3A6969%2Fannounce&tr=http%3A%2F%2F213.159.215.198%3A6970%2Fannounce&tr=http%3A%2F%2F37.19.5.139%3A6969%2Fannounce&tr=http%3A%2F%2F37.19.5.155%3A6881%2Fannounce&tr=http%3A%2F%2F46.4.109.148%3A6969%2Fannounce&tr=http%3A%2F%2F87.248.186.252%3A8080%2Fannounce&tr=http%3A%2F%2Fasmlocator.ru%3A34000%2F1hfZS1k4jh%2Fannounce&tr=http%3A%2F%2Fbt.evrl.to%2Fannounce&tr=http%3A%2F%2Fbt.rutracker.org%2Fann&tr=https%3A%2F%2Fwww.artikelplanet.nl&tr=http%3A%2F%2Fmgtracker.org%3A6969%2Fannounce&tr=http%3A%2F%2Fpubt.net%3A2710%2Fannounce&tr=http%3A%2F%2Ftracker.baravik.org%3A6970%2Fannounce&tr=http%3A%2F%2Ftracker.dler.org%3A6969%2Fannounce&tr=http%3A%2F%2Ftracker.filetracker.pl%3A8089%2Fannounce&tr=http%3A%2F%2Ftracker.grepler.com%3A6969%2Fannounce&tr=http%3A%2F%2Ftracker.mg64.net%3A6881%2Fannounce&tr=http%3A%2F%2Ftracker.tiny-vps.com%3A6969%2Fannounce&tr=http%3A%2F%2Ftracker.torrentyorg.pl%2Fannounce&tr=https%3A%2F%2Finternet.sitelio.me%2F&tr=https%3A%2F%2Fcomputer1.sitelio.me%2F&tr=udp%3A%2F%2F168.235.67.63%3A6969&tr=udp%3A%2F%2F182.176.139.129%3A6969&tr=udp%3A%2F%2F37.19.5.155%3A2710&tr=udp%3A%2F%2F46.148.18.250%3A2710&tr=udp%3A%2F%2F46.4.109.148%3A6969&tr=udp%3A%2F%2Fcomputerbedrijven.bestelinks.nl%2F&tr=udp%3A%2F%2Fcomputerbedrijven.startsuper.nl%2F&tr=udp%3A%2F%2Fcomputershop.goedbegin.nl%2F&tr=udp%3A%2F%2Fc3t.org&tr=udp%3A%2F%2Fallerhandelenlaag.nl&tr=udp%3A%2F%2Ftracker.openbittorrent.com%3A80&tr=udp%3A%2F%2Ftracker.opentrackr.org%3A1337&tr=udp%3A%2F%2Ftracker.publicbt.com%3A80&tr=udp%3A%2F%2Ftracker.tiny-vps.com%3A6969");
        magnetLinkList["name"] = torrentEntry["name"];
        magnetLinkList["leechers"] = torrentEntry["leechers"];
        magnetLinkList["seeders"] = torrentEntry["seeders"];
        magnetLinkList["num_of_files"] = torrentEntry["num_files"];
        magnetLinkList["magnet_link"] = magnetLink;
        allMagnetLinks.add(magnetLinkList);
      }
    return allMagnetLinks;
  }

  Map movieData = {};
  List torrentList = [];
  List magnetLinkList = [];
  //Function to fetch Magnet Links
  @override
  Widget build(BuildContext context) {
    movieData = ModalRoute.of(context).settings.arguments;
    torrentList = movieData['magnetLinks'];
    print(torrentList);
    //print(movieData["imdbRating"]);

    //Generate magnet link from info hash
    magnetLinkList = _generateMagnetLinksFromInfoHash(torrentList);
    print(magnetLinkList);
    return Scaffold(
      appBar: AppBar(
        title: Text("Results for ${movieData["title"]}"),
        backgroundColor: Colors.blue,
        elevation: 0,
        actions: <Widget>[
          FlatButton.icon(
              onPressed: (){},
              icon: Icon(Icons.favorite, color: Colors.red),
              label: Text("")
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
                children: [
                  Text(movieData["title"], style: TextStyle(fontSize: 30.0),),
                  SizedBox(height: 5.0,),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.network(movieData["poster"], width: 150),
                    ),
                  ),
                  SizedBox(height: 10.0,),
                  Text("Year of Release : ${movieData["year"]}", style: TextStyle(fontSize: 16.0),textAlign: TextAlign.center,),
                  SizedBox(height: 5.0,),
                  Text("Runtime : ${movieData["runTime"]}", style: TextStyle(fontSize: 16.0),textAlign: TextAlign.center,),
                  SizedBox(height: 5.0,),
                  Text("Synopsis : \n ${movieData["plot"]}", style: TextStyle(fontSize: 16.0), textAlign: TextAlign.center,),
                  SizedBox(height: 5.0,),
                  Text("Genre : ${movieData["genre"]}", style: TextStyle(fontSize: 16.0),textAlign: TextAlign.center,),
                  SizedBox(height: 5.0,),
                  Text("Actors : ${movieData["actors"]}", style: TextStyle(fontSize: 16.0),textAlign: TextAlign.center,),
                  SizedBox(height: 5.0,),
                  Text("IMdb Rating : ${  movieData["imdbRating"]==[] ? movieData["imdbRating"][0]["Value"] : "N/A" }", style: TextStyle(fontSize: 16.0),textAlign: TextAlign.center,),
                  SizedBox(height: 10.0,),
                  TextButton.icon(
                      onPressed: (){
                        Navigator.pushNamed(context, '/movie-magnet-links', arguments: {
                          'magnetLinkList': magnetLinkList,
                          'movieTitle': movieData["title"],
                        });
                      },
                      icon: Icon(Icons.link),
                      label: Text("GET LINKS!"),
                  ),
                ],
              ),
            ),
        ),
      ),
    );
  }
}
