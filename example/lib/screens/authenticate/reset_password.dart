import 'package:flutter/material.dart';
import 'package:flutter_torrent_streamer_example/constant.dart';
import 'package:flutter_torrent_streamer_example/shared/constants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:email_auth/email_auth.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:firebase_admin/firebase_admin.dart';
import 'package:firebase_admin/src/credential.dart';

class ResetPassword extends StatefulWidget {
  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  void changePassword() async{

  }

  Map routeData;
  String emailId;
  bool passwordsDontMatch =false;
  @override
  Widget build(BuildContext context) {
    String password1;
    String password2;
    routeData = ModalRoute.of(context).settings.arguments;
    emailId = routeData["emailId"];
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: kRed,
        elevation: 0,
        brightness: Brightness.dark,

      ),
      body :Container(
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
                                      hintText: "Enter New Password",
                                      //errorText: showOTPErrorMessage? 'Incorrect OTP' : null,
                                    ),
                                    validator: (val)=>val.isEmpty? 'Enter OTP':null,
                                    onChanged: (val){
                                     password1 = val;
                                    }
                                ),
                                SizedBox(height: 2),
                                TextFormField(
                                    decoration:new InputDecoration(
                                      hintText: "Re-enter New Password",
                                      errorText: passwordsDontMatch? 'Passwords do not match' : null,
                                    ),
                                    validator: (val)=>val.isEmpty? 'Enter OTP':null,
                                    onChanged: (val){
                                        password2 = val;
                                    }
                                ),

                                SizedBox(height: 20),

                                MaterialButton(
                                  minWidth: double.infinity,
                                  height: 60,
                                  onPressed: ()async{
                                    setState(() {
                                      if(password1==password2)
                                        {
                                          passwordsDontMatch = false;
                                          //Change Password
                                          changePassword();
                                        }
                                      else
                                        {
                                          passwordsDontMatch = true;
                                        }
                                    });
                                  },
                                  color: kRed,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(40)
                                  ),
                                  child: Text("Change Password",style:TextStyle(
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
        ),
      ),
    );
  }
}
