
import 'package:flutter/material.dart';
import 'package:flutter_torrent_streamer_example/services/auth.dart';
import 'package:flutter_torrent_streamer_example/shared/loading.dart';
import 'package:flutter_torrent_streamer_example/constant.dart';
import 'package:flutter_torrent_streamer_example/screens/authenticate/authenticate.dart';
import 'package:flutter_torrent_streamer_example/screens/wrapper.dart';
import 'package:flutter_torrent_streamer_example/screens/authenticate/register.dart';

class LoginForm extends StatefulWidget {
  final toggleView;
  LoginForm({this.toggleView});
  @override
  _LoginFormState createState() => _LoginFormState();
}
class _LoginFormState extends State<LoginForm> {

  final AuthService _auth=AuthService();

  bool loading=false;
  String error='';

  @override
  Widget build(BuildContext context){
    return loading? Loading(): Container(

          child:Column(
              children: <Widget>[
                MaterialButton(
                  minWidth: double.infinity,
                  height: 60,
                  onPressed:()async{
                    setState(() {
                      loading=true;
                    });
                    dynamic result=await _auth.signInGoogle();
                    print(result.toString());
                    if(result==null) {
                      setState(() {
                        error = 'Invalid credentials';
                        loading=false;
                      });
                    }
                    setState(() {
                      loading=false;
                    });
                    Navigator.pushNamed(context, '/auth');
                  },
                  color: kRed,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40)
                  ),
                  child: Text("Continue with Google",style:TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color:kWhite,

                  ),),



                ),
                SizedBox(height: 20),
                MaterialButton(
                  minWidth: double.infinity,
                  height: 60,
                  onPressed:  () {
                Navigator.pushNamed(context, '/auth');
                },
                  color: kRed,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40)
                  ),
                  child: Text("Login or Create an Eiga Account",style:TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color:kWhite,

                  ),),



                ),


    ],

          )

      );



  }
}

