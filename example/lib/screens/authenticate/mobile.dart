import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_torrent_streamer_example/services/auth.dart';
import 'package:flutter_torrent_streamer_example/shared/constants.dart';
import 'package:flutter_torrent_streamer_example/shared/loading.dart';
import 'package:flutter_torrent_streamer_example/constant.dart';
import 'package:flutter_torrent_streamer_example/screens/home/new_home.dart';
import 'package:flutter_torrent_streamer_example/like_movie/movie_like.dart';


class MobileAuth extends StatefulWidget {
  @override
  _MobileAuthState createState() => _MobileAuthState();
}

class _MobileAuthState extends State<MobileAuth> {
  final AuthService _auth=AuthService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final _formKey= GlobalKey<FormState>();
  bool loading=false;

  String mobileNumber;
  String verificationId;
  String error='';
  String otp='';
  bool otp_sent=false;


  @override
  Widget build(BuildContext context) {
    String text=ModalRoute.of(context).settings.arguments;
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
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height:90,),
              Column(
                children: [
                  Text("$text",style:TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color:kRed,
                  ),),
                  SizedBox(height:20,),
                  if (text=='Login')
                    Text("Welcome back! Login with your credentials",style:
                    TextStyle(
                        fontSize: 16,
                        color: kWhite
                    ),),
                  if(text=="Sign Up")
                    Text("Create an account. It's free!",style:
                    TextStyle(
                        fontSize: 16,
                        color: kWhite
                    ),),

                ],
              ),
              SizedBox(height:80,),
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
                                  TextFormField(
                                      decoration:textInputDecor.copyWith(hintText: 'Mobile Number'),
                                      validator: (val)=>val.isEmpty? 'Enter Mobile Number':null,
                                      onChanged: (val){
                                        setState(() {
                                          return mobileNumber=val;
                                        });
                                      }
                                  ),
                                  SizedBox(height: 20),
                                  MaterialButton(
                                    minWidth: double.infinity,
                                    height: 60,
                                    onPressed: ()async{
                                      error='';
                                      //verify phone and send otp
                                      if(_formKey.currentState.validate()){
                                        await _firebaseAuth.verifyPhoneNumber(
                                            phoneNumber: mobileNumber,
                                            verificationCompleted:(phoneAuthCredential)async{


                                            },
                                            verificationFailed: (verificationFailed)async{
                                              setState(() {
                                                error=verificationFailed.message;
                                              });

                                            },
                                            codeSent: (verificationId, resendingToken) async{
                                              setState(() {
                                                 otp_sent=true;
                                              });
                                              this.verificationId=verificationId;

                                            },
                                            codeAutoRetrievalTimeout: (verificationId) async{

                                            }
                                        );

                                      }
                                    },
                                    color: kRed,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(40)
                                    ),
                                    child: Text("Get OTP",style:TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                      color:kWhite,

                                    ),),

                                  ),
                                  if (error!='')
                                    Text(
                                    error,
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 20
                                    ),
                                  ),
                                  if (otp_sent==true)
                                    TextFormField(
                                        decoration:textInputDecor.copyWith(hintText: 'Enter OTP'),
                                        validator: (val)=>val.isEmpty? 'Enter OTP':null,
                                        onChanged: (val){
                                          setState(() {
                                            return otp=val;
                                          });
                                        }
                                    ),
                                    SizedBox(height: 20),
                                    MaterialButton(
                                      minWidth: double.infinity,
                                      height: 60,
                                      onPressed: ()async{
                                        //Verify OTP

                                        if(_formKey.currentState.validate()){
                                          setState(() {
                                           // return loading=true;
                                          });
                                          dynamic result=await _auth.mobileAuth(mobileNumber,verificationId, otp);
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
                                      child: Text("Verify OTP",style:TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                        color:kWhite,

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
