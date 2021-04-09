import 'package:flutter/material.dart';
import 'package:flutter_torrent_streamer_example/services/auth.dart';
import 'package:flutter_torrent_streamer_example/shared/constants.dart';
import 'package:flutter_torrent_streamer_example/shared/loading.dart';


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
      backgroundColor: Colors.grey,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0,
        title: Text('Sign up to Ongaku'),
        actions: [
          FlatButton.icon(
              onPressed: (){
                widget.toggleView();
              },
              icon: Icon(Icons.person),
              label: Text('Sign In'))
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20,horizontal: 50),
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
                  RaisedButton(
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
                    color: Colors.blue,
                    child: Text(
                      'Register',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    error,
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 14
                    ),
                  ),
                  Text('OR'),
                  SizedBox(height: 20),
                  RaisedButton(
                    onPressed: ()async{
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
                    },
                    color: Colors.blue,
                    child: Text(
                      'Sign Up With Google',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
