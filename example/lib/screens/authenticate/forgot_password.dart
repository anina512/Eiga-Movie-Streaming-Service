import 'package:flutter/material.dart';
import 'package:flutter_torrent_streamer_example/constant.dart';
import 'package:flutter_torrent_streamer_example/shared/constants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_torrent_streamer_example/screens/authenticate/verify_otp.dart';
import 'package:flutter_torrent_streamer_example/screens/authenticate/verify_otp.dart' as verifyotp;

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  bool emailInvalid = false;
  List<String> emailIdList;
  final FirebaseAuth firebase= FirebaseAuth.instance;
  String emailId;
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: kRed,
        elevation: 0,
        brightness: Brightness.dark,

      ),
      body: Container(
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  SizedBox(height:20,),
                  Text("Reset Password",style:TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color:Colors.black,
                  ),),
                  SizedBox(height:20,),
                ],
              ),
              Padding(
                  padding:EdgeInsets.symmetric(
                      horizontal:40
                  ),
                  child: Form(
                      child: SingleChildScrollView(
                          child: ConstrainedBox(
                              constraints: BoxConstraints(),
                              child: Column(
                                children: <Widget>[
                                  SizedBox(height: 20,),
                                  TextFormField(
                                      decoration:new InputDecoration(
                                        hintText: "Email Id",
                                          errorText: emailInvalid ? 'Invalid Email Id' : null,
                                          ),
                                      validator: (val)=>val.isEmpty? 'Enter Email':null,
                                      onChanged: (val){
                                        emailId = val;
                                      }
                                  ),

                                  SizedBox(height: 20),
                                  MaterialButton(
                                    minWidth: double.infinity,
                                    height: 60,
                                    onPressed: ()async{
                                      print(emailId);
                                      emailIdList = await firebase.fetchSignInMethodsForEmail(emailId);
                                      print(emailIdList[0]);
                                      setState(() {
                                        if(emailIdList.length == 0)
                                        {
                                          emailInvalid = true;
                                        }
                                        else if (emailIdList[0]=="google.com")
                                          {
                                            emailInvalid = true;
                                          }
                                        else
                                        {
                                          //Send OTP
                                          Navigator.pushNamed(context, '/verifyotp', arguments: {'emailId': emailId});
                                        }
                                      });

                                      },
                                    color: kRed,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(40)
                                    ),
                                    child: Text("Verify Email",style:TextStyle(
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

