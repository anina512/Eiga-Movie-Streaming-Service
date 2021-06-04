import 'package:flutter/material.dart';
import 'package:flutter_torrent_streamer_example/services/auth.dart';
import 'package:flutter_torrent_streamer_example/shared/constants.dart';
import 'package:flutter_torrent_streamer_example/shared/loading.dart';
import 'package:flutter_torrent_streamer_example/constant.dart';


class Register extends StatefulWidget {
  final toggleView;
  Register({this.toggleView});
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
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
      backgroundColor: kRed,
      appBar: AppBar(
        backgroundColor: kRed,
        elevation: 0,
        brightness: Brightness.dark,
        leading:
        IconButton(onPressed: (){
          widget.toggleView();
        },
            icon:Icon(Icons.arrow_back_ios,size:20,color:kBlack,)),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Text("Sign Up",style:TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color:kBlack,
                  ),),
                  SizedBox(height:20,),
                  Text("Create an account. It's free!",style:
                  TextStyle(
                      fontSize: 16,
                      color: kBlack
                  ),),
                ],
              ),
              Padding(
                  padding:EdgeInsets.symmetric(
                      horizontal:40
                  ),
                  child: Form(
                      key: _formKey,
                      child: SingleChildScrollView(
                          child: ConstrainedBox(
                              constraints: BoxConstraints(),
                              child: Column(
                                children: <Widget>[
                                  SizedBox(height: 20,),
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
                                        dynamic result= await _auth.registerEmail(email, password);
                                        if(result==null){
                                          setState(() {
                                            error='Invalid email';
                                            loading=false;
                                          });
                                        }
                                      }
                                    },
                                    color: kBlack,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(40)
                                    ),
                                    child: Text("Sign Up with Email",style:TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                      color:kRed,

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
                                        color:kBlack,
                                        fontSize:20,
                                      )
                                  ),
                                  SizedBox(height: 20),
                                  MaterialButton(
                                    minWidth: double.infinity,
                                    height: 60,
                                    onPressed: (){
                                      Navigator.pushNamed(context, '/authmobile',arguments: 'Sign Up');

                                      //Navigator.pushNamed(context, '/mobile',arguments: 'Sign Up');
                                    },
                                    color: kBlack,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(40)
                                    ),
                                    child: Text("Sign Up with Mobile",style:TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                      color:kRed,

                                    ),),

                                  ),
                                  SizedBox(height: 30),

                                  Text('Already have an account?',style: TextStyle(
                                    color:kBlack,
                                    fontSize:20,
                                  )),

                                  SizedBox(height: 20),
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
                                    child: Text("Login",style:TextStyle(
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