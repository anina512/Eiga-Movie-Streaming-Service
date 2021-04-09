import 'package:flutter/material.dart';

const textInputDecor=InputDecoration(

    fillColor: Colors.white,
    filled: true,
    enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white,width: 2)
    ),
    focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.blue,width: 2)
    )
);