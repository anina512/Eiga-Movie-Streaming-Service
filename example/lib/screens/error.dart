import 'package:flutter/material.dart';

class Error extends StatefulWidget {
  @override
  _ErrorState createState() => _ErrorState();
}

class _ErrorState extends State<Error> {
  Map errorData={};
  String errorMessage;
  @override
  Widget build(BuildContext context) {
    errorData = ModalRoute.of(context).settings.arguments;
    errorMessage=errorData['errorMessage'];
    return  Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          elevation: 0,
          title: Text('Error'),
        ),
        body:Container(
            padding: EdgeInsets.symmetric(vertical: 20,horizontal: 130),
          child:Column(
            children: <Widget>[
              SizedBox(height: 40,),
              Text(errorMessage,style: TextStyle(fontSize: 25,),textAlign: TextAlign.center,)
            ],
          )
        )
    );
  }
}
