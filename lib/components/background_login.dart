import 'package:flutter/material.dart';

class Background_Login extends StatelessWidget {
  final Widget child;

  const Background_Login({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: double.infinity,
      height: size.height,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Positioned(
            top: 0,
            right: 0,
            child: Image.asset("assets/top1.png", width: size.width),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: Image.asset("assets/top2.png", width: size.width),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height / 5.5,
            right: MediaQuery.of(context).size.width / 3.2,
            child: Image.asset("assets/SMC_logo.png", width: size.width * 0.58),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Image.asset("assets/bottom1.png", width: size.width),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Image.asset("assets/bottom2.png", width: size.width),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height / 1.12,
            right: MediaQuery.of(context).size.width / 1.7,
            child: Image.asset("assets/hms2.png", width: size.width * 0.38),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height / 1.135,
            right: MediaQuery.of(context).size.width / 80,
            child: ElevatedButton(
              onPressed: () {},
              child: Text('V2.5'),
              style: ElevatedButton.styleFrom(
                primary: Colors.red[400], //
                shape: CircleBorder(),
                padding: EdgeInsets.all(12),
              ),
            ),
          ),
          child
        ],
      ),
    );
  }
}
