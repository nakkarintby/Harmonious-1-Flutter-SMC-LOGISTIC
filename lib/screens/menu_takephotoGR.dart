import 'package:flutter/material.dart';
import 'package:test/components/menu_list.dart';
import 'package:test/screens/afterGI.dart';
import 'package:test/screens/beforeGI.dart';
import 'package:test/screens/securityGI.dart';
import 'package:test/screens/securityGR.dart';

import 'afterGR.dart';
import 'beforeGR.dart';

class MenuTakePhotoGR extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: BackButton(color: Colors.black),
          backgroundColor: Colors.white,
          title: Text(
            'Take Photo GR',
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: Colors.black, fontSize: 20),
          )),
      body: Container(
        constraints: BoxConstraints.expand(),
        decoration: BoxDecoration(
            image: new DecorationImage(
          image: new AssetImage("assets/Background.jpg"),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
              Colors.white.withOpacity(0.5), BlendMode.dstATop),
        )),
        alignment: Alignment.center,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 50),
          child: Column(
            children: [
              MenuList(
                text: "Before",
                icon: Icon(
                  Icons.navigate_before_rounded,
                  size: 40,
                  color: Colors.blue,
                ),
                press: () => {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => BeforeGRPage()))
                },
              ),
              MenuList(
                text: "After",
                icon: Icon(
                  Icons.navigate_next_rounded,
                  size: 40,
                  color: Colors.blue,
                ),
                press: () => {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AfterGRPage()))
                },
              ),
              MenuList(
                text: "Security",
                icon: Icon(
                  Icons.security_rounded,
                  size: 40,
                  color: Colors.blue,
                ),
                press: () => {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SecurityGRPage()))
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
