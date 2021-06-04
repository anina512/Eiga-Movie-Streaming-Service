import 'package:flutter/material.dart';
import 'package:flutter_torrent_streamer_example/constant.dart';
import 'package:flutter_torrent_streamer_example/shared/constants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart' ;
import 'package:email_auth/email_auth.dart';

showAlertDialog(BuildContext context) {

  // set up the button
  Widget okButton = FlatButton(
    child: Text("OK"),
    onPressed: () {
      int count = 0;
      Navigator.of(context).popUntil((_) => count++ >= 3);
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Password Reset Email Sent"),
    content: Text("Change your password on the link sent to your registered email Id"),
    actions: [
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

class VerifyOTP extends StatefulWidget {
  @override
  _VerifyOTPState createState() => _VerifyOTPState();
}

class _VerifyOTPState extends State<VerifyOTP> {
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => sendOTP());
  }
  void sendOTP () async
  {
    EmailAuth.sessionName = "Test Session";
    var res = await EmailAuth.sendOtp(receiverMail: emailId);
    if(res)
      {
        print("OTP sent");
      }
    else
      {
        print("OTP not sent");
      }
  }

  void verifyOTP() async{
    var res = EmailAuth.validate(receiverMail: emailId, userOTP: OTP);
    if(res)
      {
        print("OTP verified");
        otpVerified = true;
      }
    else
      {
        print("OTP not verified");
        otpVerified = false;
      }
  }
  bool OTPInvalid = false;
  bool showOTPErrorMessage = false;
  Map routeData;
  String emailId;
  String OTP;
  bool otpVerified;
  @override
  Widget build(BuildContext context) {
    routeData = ModalRoute.of(context).settings.arguments;
    emailId = routeData["emailId"];

    return  Scaffold(
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
                  Text("OTP Verification",style:TextStyle(
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
                                        hintText: "Enter OTP",
                                        errorText: showOTPErrorMessage? 'Incorrect OTP' : null,
                                      ),
                                      validator: (val)=>val.isEmpty? 'Enter OTP':null,
                                      onChanged: (val){
                                        OTP = val;
                                      }
                                  ),
                                  SizedBox(height: 2),
                                  TextButton(
                                    style: TextButton.styleFrom(
                                      textStyle: const TextStyle(fontSize: 12),
                                    ),
                                    onPressed: () {
                                      sendOTP();
                                    },
                                    child: const Text('Resend OTP'),
                                  ),
                                  const SizedBox(height: 3),
                                  SizedBox(height: 20),

                                  MaterialButton(
                                    minWidth: double.infinity,
                                    height: 60,
                                    onPressed: ()async{
                                        print(OTP);
                                        print(emailId);
                                        verifyOTP();
                                        if(otpVerified ==false)
                                        {
                                          setState(() async{
                                          showOTPErrorMessage = true;
                                          });
                                        }
                                        else
                                          {
                                            //Reset Password
                                            //Navigator.pushNamed(context, '/resetpassword', arguments: {'emailId': emailId});
                                            final FirebaseAuth _auth= FirebaseAuth.instance;
                                            await _auth.sendPasswordResetEmail(email: emailId);
                                            showAlertDialog(context);

                                          }
                                        print(showOTPErrorMessage);

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
          ),
        ),
    );

  }
}
