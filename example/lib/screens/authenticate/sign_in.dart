import 'package:flutter/material.dart';
import 'package:flutter_torrent_streamer_example/screens/authenticate/register.dart';
import 'package:flutter_torrent_streamer_example/services/auth.dart';
import 'package:flutter_torrent_streamer_example/shared/constants.dart';
import 'package:flutter_torrent_streamer_example/shared/loading.dart';
import 'package:flutter_torrent_streamer_example/constant.dart';


class SignIn extends StatefulWidget {
  final toggleView;
  SignIn({this.toggleView});
  @override
  _SignInState createState() => _SignInState();
}
class _SignInState extends State<SignIn> {

  final AuthService _auth=AuthService();
  final _formKey= GlobalKey<FormState>();
  bool loading=false;

  String email='';
  String password='';
  String error='';


  @override
  Widget build(BuildContext context) {
    return loading? Loading():Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: kBlack,
      appBar: AppBar(
        backgroundColor: kBlack,
        elevation: 0,
        brightness: Brightness.dark,
        leading:
        IconButton(onPressed: (){
          Navigator.pop(context);
        },
            icon:Icon(Icons.arrow_back_ios,size:20,color:kRed,)),
      ),
      body: Container(
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Text("Login",style:TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color:kRed,
                  ),),
                  SizedBox(height:20,),
                  Text("Welcome back! Login with your credentials",style:
                  TextStyle(
                      fontSize: 16,
                      color: kWhite
                  ),),
                ],
              ),
              Padding(
                  padding:EdgeInsets.symmetric(
                      horizontal:40
                  ),
                  child:Form(
                      key: _formKey,
                      child:SingleChildScrollView(
                          child:ConstrainedBox(
                              constraints: BoxConstraints(),
                              child: Column(
                                children: <Widget>[
                                  SizedBox(height:10,),
                                  TextFormField(
                                      decoration:textInputDecor.copyWith(hintText: 'Email'),
                                      validator: (val)=>val.isEmpty? 'Enter Email':null,
                                      onChanged: (val){
                                        setState(() {
                                          return email=val;
                                        });
                                      }
                                  ),
                                  SizedBox(height: 20),
                                  TextFormField(
                                    decoration:textInputDecor.copyWith(hintText: 'Password'),
                                    validator: (val)=>val.length<6? 'Enter a password with 6 or more characters':null,
                                    obscureText: true,
                                    onChanged: (val){
                                      setState(() {
                                        return password=val;
                                      });
                                    },
                                  ),
                                  SizedBox(height: 20),
                                  MaterialButton(
                                    minWidth: double.infinity,
                                    height: 60,
                                    onPressed: ()async{
                                      if(_formKey.currentState.validate()){
                                        setState(() {
                                          return loading=true;
                                        });
                                        dynamic result=await _auth.signInEmail(email, password);
                                        if(result==null){
                                          setState(() {
                                            error='Invalid credentials!';
                                            loading=false;
                                          });
                                        }
                                      }
                                    },
                                    color: kRed,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(40)
                                    ),
                                    child: Text("Login with Email",style:TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                      color:kWhite,

                                    ),),

                                  ),
                                  if (error!='')
                                    SizedBox(height: 10),
                                    Text(
                                      error,
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontSize: 20
                                      ),
                                    ),


                                  SizedBox(height: 10),
                                  Text(
                                      'OR',
                                      style: TextStyle(
                                          color:kWhite,
                                          fontSize:20,
                                        )
                                  ),
                                  SizedBox(height: 20),
                                  MaterialButton(
                                    minWidth: double.infinity,
                                    height: 60,
                                    onPressed: (){
                                      Navigator.pushNamed(context, '/authmobile',arguments: 'Login');

                                      //Navigator.pushNamed(context, '/mobile',arguments: 'Login');
                                    },
                                    color: kRed,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(40)
                                    ),
                                    child: Text("Login with Mobile",style:TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                      color:kWhite,

                                    ),),

                                  ),

                                  SizedBox(height: 30),
                                  Text('Don\'t have an account ?',style: TextStyle(
                                    color:kWhite,
                                    fontSize:20,
                                  )),
                                  SizedBox(height: 10),
                                  MaterialButton(
                                    minWidth: double.infinity,
                                    height: 60,
                                    onPressed: (){
                                      widget.toggleView();
                                    },
                                    color: kWhite,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(40)
                                    ),
                                    child: Text("Sign Up",style:TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                      color:Colors.white,

                                    ),),

                                  ),

                                ],
                              )

                          )
                      )
                  )
              )
            ],
          )
      ),
    );
  }
}
