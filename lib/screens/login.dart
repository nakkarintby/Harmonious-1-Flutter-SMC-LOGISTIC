import 'package:flutter/material.dart';
import 'package:test/class/datauser.dart';
import 'package:test/class/resinfoapp.dart';
import 'package:test/mywidget.dart';
import 'package:test/screens/main_screen.dart';
import 'package:test/constants.dart';
import 'package:test/components/background_login.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class Login extends StatefulWidget {
  static String routeName = "/login";
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController configsController = TextEditingController();
  TextEditingController qualityController = TextEditingController();
  TextEditingController takephotoOnlyController = TextEditingController();
  late Timer timer;
  String configs = '';
  String showMenu = '';
  String version = '';

  late List<FocusNode> focusNodes = List.generate(1, (index) => FocusNode());
  late ResInfoApp resultInfoApp;

  @override
  void initState() {
    super.initState();
    setSharedPrefs();
    checkVersion();
  }

  void alertDialog(String msg, String type) {
    Icon icon = Icon(Icons.info_outline, color: Colors.lightBlue);
    switch (type) {
      case "Success":
        icon = Icon(Icons.check_circle_outline, color: Colors.lightGreen);
        break;
      case "Error":
        icon = Icon(Icons.error_outline, color: Colors.redAccent);
        break;
      case "Warning":
        icon = Icon(Icons.warning_amber_outlined, color: Colors.orangeAccent);
        break;
      case "Infomation":
        icon = Icon(Icons.info_outline, color: Colors.lightBlue);
        break;
    }

    showDialog(
        context: context,
        builder: (BuildContext builderContext) {
          timer = Timer(Duration(seconds: 5), () {
            Navigator.of(context, rootNavigator: true).pop();
          });

          return AlertDialog(
            title: Row(children: [icon, Text(" " + type)]),
            content: Text(msg),
          );
        }).then((val) {
      if (timer.isActive) {
        timer.cancel();
      }
    });
  }

  void showErrorDialog(String error) {
    //MyWidget.showMyAlertDialog(context, "Error", error);
    alertDialog(error, 'Error');
  }

  void showSuccessDialog(String success) {
    //MyWidget.showMyAlertDialog(context, "Success", success);
    alertDialog(success, 'Success');
  }

  Future<void> launchUrlDownload() async {
    const url = 'http://192.168.1.49/Web/User/DownloadApk';

    //const url = 'https://google.com';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> checkVersion() async {
    String? lastVersion = '';
    var url = Uri.parse(
        'http://192.168.1.49/api/api/configuration/getbyname/VersionApp');

    http.Response response = await http.get(url);

    if (response.statusCode != 200) {
      showErrorDialog('Error Http Requests checkVersion');
      return;
    }

    var data = json.decode(response.body);
    setState(() {
      resultInfoApp = ResInfoApp.fromJson(data);
    });

    if (resultInfoApp != null) {
      setState(() {
        lastVersion = resultInfoApp.description;
      });
    }

    if (version == lastVersion) {
    } else {
      String type = 'Warning';
      Icon icon = Icon(Icons.info_outline, color: Colors.lightBlue);
      switch (type) {
        case "Success":
          icon = Icon(Icons.check_circle_outline, color: Colors.lightGreen);
          break;
        case "Error":
          icon = Icon(Icons.error_outline, color: Colors.redAccent);
          break;
        case "Warning":
          icon = Icon(Icons.warning_amber_outlined, color: Colors.orangeAccent);
          break;
        case "Infomation":
          icon = Icon(Icons.info_outline, color: Colors.lightBlue);
          break;
      }

      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext builderContext) {
            return WillPopScope(
              onWillPop: () async => false,
              child: AlertDialog(
                title: Row(children: [icon, Text(" " + type)]),
                content: Text('Please Update Lastest Version'),
                actions: <Widget>[
                  new FlatButton(
                    child: new Text("OK"),
                    onPressed: () {
                      launchUrlDownload();
                    },
                  ),
                ],
              ),
            );
          }).then((val) {});
    }
  }

  Future<void> setSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool checkConfigsPrefs = prefs.containsKey('configs');
    bool checkQualityPrefs = prefs.containsKey('quality');
    bool checkshowMenuoPrefs = prefs.containsKey('showMenu');

    setState(() {
      version = '2.6';
    });
    if ((checkConfigsPrefs && checkQualityPrefs) && checkshowMenuoPrefs) {
      setState(() {
        showMenu = prefs.getString('showMenu');
      });
    } else {
      prefs.setString('configs', 'http://192.168.1.49:8111');
      prefs.setInt('quality', 35);
      prefs.setString('showMenu', 'Show All Menu');
      setState(() {
        showMenu = prefs.getString('showMenu');
      });
    }
  }

  Future<void> editSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Icon icon = Icon(Icons.edit, color: Colors.lightBlue);

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Row(children: [icon, Text(" " + 'Edit Configs')]),
            content: SingleChildScrollView(
                child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                TextFormField(
                  //autofocus: true, //set initail focus on dialog
                  readOnly: false,
                  controller: configsController
                    ..text = prefs.getString('configs'),
                  decoration: InputDecoration(
                      labelText: 'Configs IP', hintText: "Enter Configs IP"),
                  textInputAction: TextInputAction.next,
                  onEditingComplete: () {
                    Future.delayed(Duration(milliseconds: 100)).then((_) =>
                        FocusScope.of(context).requestFocus(focusNodes[0]));
                  },
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  readOnly: false,
                  controller: qualityController
                    ..text = prefs.getInt('quality').toString(),
                  decoration: InputDecoration(
                      labelText: 'Quality Image',
                      hintText: "Enter Quality Image[0-100]"),
                  textInputAction: TextInputAction.next,
                  onEditingComplete: () {
                    Future.delayed(Duration(milliseconds: 100)).then((_) =>
                        FocusScope.of(context).requestFocus(focusNodes[0]));
                  },
                ),
                SizedBox(
                  height: 25,
                ),
                new DropdownButton<String>(
                  isDense: true,
                  isExpanded: true,
                  value: showMenu,
                  items: <String>['Show All Menu', 'Show Only TakePhoto Menu']
                      .map((String value) {
                    return new DropdownMenuItem<String>(
                      value: value,
                      child: new Text(value),
                    );
                  }).toList(),
                  onTap: () {
                    FocusScope.of(context).requestFocus(new FocusNode());
                  },
                  onChanged: (String? val) {
                    setState(() {
                      showMenu = val!;
                    });
                    Future.delayed(Duration(milliseconds: 100)).then((_) =>
                        FocusScope.of(context).requestFocus(focusNodes[0]));
                  },
                ),
              ],
            )),
            actions: <Widget>[
              FlatButton(
                color: Colors.red,
                textColor: Colors.white,
                child: Text('Cancel'),
                onPressed: () {
                  setState(() {
                    showMenu = prefs.getString('showMenu');
                    Navigator.pop(context);
                  });
                },
              ),
              FlatButton(
                focusNode: focusNodes[0],
                color: Colors.green,
                textColor: Colors.white,
                child: Text('Save'),
                onPressed: () {
                  if (int.parse(qualityController.text) < 1 ||
                      int.parse(qualityController.text) > 100) {
                    alertDialog('Please Enter Quality 0-100', 'Error');
                  } else {
                    setState(() {
                      prefs.setString('configs', configsController.text);
                      prefs.setInt(
                          'quality', int.parse(qualityController.text));
                      prefs.setString('showMenu', showMenu);
                      Navigator.pop(context);
                    });
                    alertDialog('Edit Successful', 'Success');
                  }
                },
              ),
            ],
          );
        });
  }

  Future<void> loginCheck() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {
        configs = prefs.getString('configs');
      });
      var username = usernameController.text;
      var url = Uri.parse(configs + '/api/api/user/validateuser/' + username);
      http.Response response = await http.get(url);

      if (response.statusCode != 200) {
        showErrorDialog('Error Http Requests loginCheck');
        return;
      }

      var data = json.decode(response.body);
      DataUser msg = DataUser.fromJson(data);
      var msg_userid = msg.user?.userId;
      var msg_username = msg.user?.userName;
      var msg_password = msg.user?.password;
      var msg_role = msg.user?.role;
      var msg_user = msg.user;
      var msg_err = msg.errorMsg;

      Timer(Duration(seconds: 3), () async {
        if (msg_username != null) {
          await FlutterSession().set('token', msg_username);
          await FlutterSession().set('token_userid', msg_userid);
          await FlutterSession().set('token_username', msg_username);
          await FlutterSession().set('token_role', msg_role);
          _btnController.reset();
          Navigator.pushReplacementNamed(context, MainScreen.routeName);
        } else {
          _btnController.reset();
          usernameController.text = '';
          showErrorDialog('Username Incorrect');
        }
      });
    } catch (e) {
      Navigator.pushReplacementNamed(context, Login.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Background_Login(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).size.height / 6,
            ),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(horizontal: 40),
              child: TextField(
                controller: usernameController,
                decoration: InputDecoration(
                    // icon: Icon(Icons.mail),
                    prefixIcon: Icon(Icons.lock),
                    hintText: 'Your Username',
                    labelText: 'Username',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: redColor, width: 1))),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 25,
            ),
            Container(
              alignment: Alignment.centerRight,
              margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
              child: RoundedLoadingButton(
                color: roundedLoadingButtonColor,
                successColor: roundedLoadingButtonSuccessColor,
                width: 200,
                controller: _btnController,
                onPressed: () => loginCheck(),
                valueColor: Colors.black,
                borderRadius: 30,
                child: Text('LOGIN', style: TextStyle(color: whiteColor)),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 20,
            ),
            ElevatedButton(
              onPressed: () {
                editSharedPrefs();
              },
              child: const Icon(
                Icons.settings,
                size: 30,
              ),
              style: ElevatedButton.styleFrom(
                shape: CircleBorder(),
                padding: EdgeInsets.all(10),
              ),
            ),
          ],
        ),
      ),
      /*floatingActionButton: FloatingActionButton(
        onPressed: () {
          editSharedPrefs();
        },
        backgroundColor: Colors.red[400],
        child: const Icon(Icons.settings),
      ),*/
      /*floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      floatingActionButton: Container(
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            FloatingActionButton(
              onPressed: () {
                editSharedPrefs();
              },
              backgroundColor: Colors.blue,
              elevation: 1,
              child: const Icon(
                Icons.settings,
                size: 36,
              ),
            ),
          ],
        ),
      ),*/
    );
  }
}
