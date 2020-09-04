import 'package:flutter/material.dart';

const textInputDecoration = InputDecoration(
  fillColor: Colors.white, // background color
  filled: true, // apply background color
  enabledBorder: OutlineInputBorder( // apply this when not clicked
    borderSide: BorderSide(color: Colors.white,width: 2.0),
  ),
  focusedBorder: OutlineInputBorder( // apply this when clicked
    borderSide: BorderSide(color: Colors.pink,width: 2.0),
  ),
);