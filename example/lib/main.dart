import 'package:flutter/material.dart';
import 'package:flutter_torrent_streamer/flutter_torrent_streamer.dart';
import 'package:flutter_torrent_streamer_example/models/user.dart';
import 'package:flutter_torrent_streamer_example/screens/movie_widgets/movie_detail.dart';
import 'package:flutter_torrent_streamer_example/screens/movie_widgets/movie_links.dart';
import 'package:flutter_torrent_streamer_example/screens/torrent/torrent.dart';
import 'package:flutter_torrent_streamer_example/screens/wrapper.dart';
import 'package:flutter_torrent_streamer_example/services/auth.dart';
import 'package:provider/provider.dart';
import 'package:flutter_torrent_streamer_example/shared/loading.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_torrent_streamer_example/screens/error.dart';
import 'package:flutter_torrent_streamer_example/screens/home/new_home.dart';
import 'package:flutter_torrent_streamer_example/screens/onboarding/onboarding.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:flutter_torrent_streamer_example/screens/login/widgets/login_form.dart';
import 'constant.dart';


void main() async {
//  final Directory saveDir = await getExternalStorageDirectory();
  WidgetsFlutterBinding.ensureInitialized();
  await TorrentStreamer.init();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<Users>.value(
      value: AuthService().user,
      child: MaterialApp(
        home: Splash2(),
        routes: {
          '/movie-detail': (context) => MovieDetail(),
          '/movie-magnet-links': (context) => MovieLinks(),
          '/loading': (context)=>Loading(),
          '/play-torrent': (context)=> TorrentStreamerView(),
          '/error':(context)=>Error(),
          '/login':(context) => LoginForm(),
          '/home': (context)=>HomeScreen(),
          '/auth': (context) => Wrapper(),
        }
      ),
    );
  }
}
class Splash2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 5,
      backgroundColor: kBlack,
      title:new Text('Eiga.',style: TextStyle(color:kRed,fontSize: 130,fontFamily:'Pacifico',),),
      //image: Image.asset('assets/images/popcorn.gif'),
      navigateAfterSeconds: Builder(
          builder: (BuildContext context) {
            var screenHeight = MediaQuery.of(context).size.height;
            return Onboarding(
              screenHeight: screenHeight,
            );
          }
      ),

      photoSize: 100.0,
      loaderColor: kRed,
    );
  }
}

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: Text('Torrent Streamer'),
//         ),
//         body: TorrentStreamerView()
//       ),
//       theme: ThemeData(primaryColor: Colors.blue)
//     );
//   }
// }

