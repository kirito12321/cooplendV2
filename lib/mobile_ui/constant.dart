import 'package:ascoop/style.dart';
import 'package:flutter/material.dart';

var appBarDef = AppBar(
  elevation: 0.5,
  title: const Text(
    'Member Dashboard',
    style: TextStyle(
        fontFamily: FontNameDefault,
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: Colors.black),
  ),
  backgroundColor: Colors.white,
  actions: [
    IconButton(
      icon: const Image(image: AssetImage('assets/images/cooplendlogo.png')),
      padding: const EdgeInsets.all(2.0),
      iconSize: 35,
      onPressed: () {},
    )
  ],
);
