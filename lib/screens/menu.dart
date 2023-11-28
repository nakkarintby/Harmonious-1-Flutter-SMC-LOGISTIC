import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test/components/menu_list.dart';
import 'package:test/screens/menu_gi.dart';
import 'package:test/screens/menu_gr.dart';
import 'package:test/screens/menu_takephotoGI.dart';
import 'package:test/screens/menu_transfer.dart';
import 'package:test/screens/stock_overview.dart';
import 'package:test/screens/beforeGI.dart';

import 'menu_takephotoGR.dart';

class Menu extends StatefulWidget {
  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<Menu> {
  bool grVisible = false;
  bool giVisible = false;
  bool transferVisible = false;
  bool stockVisible = false;
  bool takephotoGRVisible = false;
  bool takephotoGIVisible = false;
  String showMenu = '';

  @override
  void initState() {
    super.initState();
    getSharedPrefs();
  }

  Future<void> getSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      showMenu = prefs.getString('showMenu');
    });
    if (showMenu == 'Show All Menu') {
      setState(() {
        grVisible = true;
        giVisible = true;
        transferVisible = true;
        stockVisible = true;
        takephotoGRVisible = true;
        takephotoGIVisible = true;
      });
    } else {
      setState(() {
        grVisible = false;
        giVisible = false;
        transferVisible = false;
        stockVisible = false;
        takephotoGRVisible = true;
        takephotoGIVisible = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              SizedBox(height: 2),
              Visibility(
                visible: grVisible,
                child: MenuList(
                  text: "GR",
                  icon: Icon(
                    Icons.flight_land_rounded,
                    size: 40,
                    color: Colors.blue,
                  ),
                  press: () => {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => MenuGR()))
                  },
                ),
              ),
              Visibility(
                visible: giVisible,
                child: MenuList(
                  text: "GI",
                  icon: Icon(
                    Icons.flight_takeoff_rounded,
                    size: 40,
                    color: Colors.blue,
                  ),
                  press: () => {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => MenuGI()))
                  },
                ),
              ),
              Visibility(
                visible: transferVisible,
                child: MenuList(
                  text: "Transfer",
                  icon: Icon(
                    Icons.swap_horiz_outlined,
                    size: 40,
                    color: Colors.blue,
                  ),
                  press: () => {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => MenuTransfer()))
                  },
                ),
              ),
              Visibility(
                visible: stockVisible,
                child: MenuList(
                  text: "Stock",
                  icon: Icon(
                    Icons.shopping_cart_rounded,
                    size: 40,
                    color: Colors.blue,
                  ),
                  press: () => {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => StockOverviewPage()))
                  },
                ),
              ),
              Visibility(
                visible: takephotoGRVisible,
                child: MenuList(
                  text: "Take Photo GR",
                  icon: Icon(
                    Icons.camera_alt_rounded,
                    size: 40,
                    color: Colors.blue,
                  ),
                  press: () => {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MenuTakePhotoGR()))
                  },
                ),
              ),
              Visibility(
                visible: takephotoGIVisible,
                child: MenuList(
                  text: "Take Photo GI",
                  icon: Icon(
                    Icons.camera_alt_rounded,
                    size: 40,
                    color: Colors.blue,
                  ),
                  press: () => {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MenuTakePhotoGI()))
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
