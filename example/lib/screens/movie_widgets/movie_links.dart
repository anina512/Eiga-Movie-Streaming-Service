import 'package:flutter/material.dart';

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
    movieLinkData = ModalRoute.of(context).settings.arguments;
    linksList = movieLinkData["magnetLinkList"];
    title = movieLinkData["movieTitle"];
    return Scaffold(
      appBar: AppBar(
        title: Text("Links for $title"),
        backgroundColor: Colors.blue,
        elevation: 0,
      ),
      body: ListView.builder(
          itemCount: linksList.length,
          itemBuilder: (context, index){
            //Dictionary to get info of that particular link
            final link = linksList[index];
            return TextButton(
              onPressed: () {
                print(link['magnet_link']);
                Navigator.pushNamed(context, '/play-torrent',arguments: {'torrentLink': link["magnet_link"]});
              },
              child: ListTile(
                title: Row(
                  children: [
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          margin: const EdgeInsets.all(5.0),
                          padding: const EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.blueAccent)
                          ),
                          child: Column(
                            children: [
                              Text("Link ${index+1}", style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),),
                              SizedBox(height: 5.0,),
                              Text("Name: ${link["name"]}", style: TextStyle(fontSize: 19.0, fontWeight: FontWeight.w400),),
                              SizedBox(height: 5.0,),
                              Text("Seeders: ${link["seeders"]}"),
                              SizedBox(height: 5.0,),
                              Text("Leechers: ${link["leechers"]}"),
                              SizedBox(height: 5.0,),
                              Text("Number Of Files: ${link["num_of_files"]}"),
                              SizedBox(height: 5.0,),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
      }
      ),
    );
  }
}
