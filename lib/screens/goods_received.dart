import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test/class/resvalidatedocument.dart';
import 'package:test/class/resvalidatelocation.dart';
import 'package:test/class/resvalidatepalletitem.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:test/constants.dart';
import 'package:test/mywidget.dart';
import 'package:test/screens/history.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter/services.dart';
import 'package:input_with_keyboard_control/input_with_keyboard_control.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:device_info_plus/device_info_plus.dart';

class GoodReceived extends StatefulWidget {
  const GoodReceived({Key? key}) : super(key: key);

  @override
  _GoodReceivedState createState() => _GoodReceivedState();
}

class _GoodReceivedState extends State<GoodReceived> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController documentController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController gradeController = TextEditingController();
  TextEditingController matController = TextEditingController();
  TextEditingController lotController = TextEditingController();
  TextEditingController palletnumberController = TextEditingController();
  TextEditingController pallettypeController = TextEditingController();
  TextEditingController remainweightController = TextEditingController();
  TextEditingController palletweightController = TextEditingController();
  bool documentVisible = false;
  bool locationVisible = false;
  bool gradeVisible = false;
  bool matVisible = false;
  bool lotVisible = false;
  bool palletnumberVisible = false;
  bool pallettypeVisible = false;
  bool remainweightVisible = false;
  bool palletweightVisible = false;
  bool documentReadonly = false;
  bool locationReadonly = false;
  bool gradeReadonly = false;
  bool matReadonly = false;
  bool lotReadonly = false;
  bool palletnumberReadonly = false;
  bool pallettypeReadonly = false;
  bool remainweightReadonly = false;
  bool palletweightReadonly = false;
  Color documentColor = Color(0xFFFFFFFF);
  Color locationColor = Color(0xFFFFFFFF);
  Color gradeColor = Color(0xFFFFFFFF);
  Color matColor = Color(0xFFFFFFFF);
  Color lotColor = Color(0xFFFFFFFF);
  Color palletnumberColor = Color(0xFFFFFFFF);
  Color pallettypeColor = Color(0xFFFFFFFF);
  Color remainweightColor = Color(0xFFFFFFFF);
  Color palletweightColor = Color(0xFFFFFFFF);
  bool historyEnabled = false;
  bool backEnabled = false;
  bool submitEnabled = false;
  bool finishEnabled = false;

  //step
  int step = 0;
  //variable call api
  String documentIdInput = '';
  String locationInput = '';
  String gradeInput = '';
  String matInput = '';
  String lotInput = '';
  String palletnumberInput = '';
  String pallettypeInput = '';
  String remainweightInput = '';
  String palletweightInput = '';

  late ResValidateDocument? resultValDocument;
  late ResValidateLocation? resultValLocation;
  late ResValidatePalletitem? resultValPallet;
  late Document? resultDocument;
  late Location? resultLocation;
  late Palletitem? resultPalletitem;
  late List<Palletitem?> listHistoryPalletitem;

  String username = "";
  late List<FocusNode> focusNodes = List.generate(5, (index) => FocusNode());
  late Timer timer;

  String configs = '';
  String deviceInfo = '';

  TextEditingController test = TextEditingController();
  @override
  void initState() {
    super.initState();
    getDeviceInfo();
    getSharedPrefs();
    getSession();
    setState(() {
      step = 0;
    });
    setVisible();
    setReadOnly();
    setColor();
    setText();
    setFocus();
  }

  Future<void> getDeviceInfo() async {
    //DeviceInfoPlugin device = DeviceInfoPlugin();
    // Android
    //AndroidDeviceInfo info = await device.androidInfo;
    //print(info.brand);
    //print(info.device.toString());
    //print(info.id);
    var androidInfo = await DeviceInfoPlugin().androidInfo;
    var release = androidInfo.version.release;
    var sdkInt = androidInfo.version.sdkInt;
    var manufacturer = androidInfo.manufacturer;
    var model = androidInfo.model;
    var ans = 'Android ' +
        release.toString() +
        ' (SDK ' +
        sdkInt.toString() +
        '), ' +
        manufacturer.toString() +
        ' ' +
        model.toString();
    print(ans);
    // Android 9 (SDK 28), Xiaomi Redmi Note 7
    setState(() {
      deviceInfo = ans;
    });
  }

  Future<void> showProgressLoading(bool finish) async {
    ProgressDialog pr = ProgressDialog(context);
    pr = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: true, showLogs: true);
    pr.style(
        progress: 50.0,
        message: "Please wait...",
        progressWidget: Container(
            padding: EdgeInsets.all(8.0), child: CircularProgressIndicator()),
        maxProgress: 100.0,
        progressTextStyle: TextStyle(
            color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
        messageTextStyle: TextStyle(
            color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600));

    if (finish == false) {
      await pr.show();
    } else {
      await pr.hide();
    }
  }

  Future<void> getSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      configs = prefs.getString('configs');
    });
  }

  Future<void> getSession() async {
    var isUsername = await FlutterSession().get("token_username");
    setState(() {
      username = "$isUsername";
    });
  }

  Future<void> setDocumentIdSession() async {
    await FlutterSession().set('token_documentID', documentIdInput);
  }

  Future<void> setHistoryAppBarSession() async {
    await FlutterSession().set('token_historyAppBarSession', 'GoodsRecieved');
  }

  void setVisible() {
    if (step == 0) {
      setState(() {
        documentVisible = true;
        locationVisible = false;
        gradeVisible = false;
        matVisible = false;
        lotVisible = false;
        palletnumberVisible = false;
        pallettypeVisible = false;
        remainweightVisible = false;
        palletweightVisible = false;
      });
    } else if (step == 1) {
      setState(() {
        documentVisible = true;
        locationVisible = true;
        gradeVisible = false;
        matVisible = false;
        lotVisible = false;
        palletnumberVisible = false;
        pallettypeVisible = false;
        remainweightVisible = false;
        palletweightVisible = false;
      });
    } else if (step == 2) {
      setState(() {
        documentVisible = true;
        locationVisible = true;
        gradeVisible = true;
        matVisible = false;
        lotVisible = false;
        palletnumberVisible = false;
        pallettypeVisible = false;
        remainweightVisible = false;
        palletweightVisible = false;
      });
    } else if (step == 3) {
      setState(() {
        documentVisible = true;
        locationVisible = true;
        gradeVisible = true;
        matVisible = true;
        lotVisible = true;
        palletnumberVisible = true;
        pallettypeVisible = true;
        remainweightVisible = true;
        palletweightVisible = true;
      });
    }
  }

  void setReadOnly() {
    if (step == 0) {
      setState(() {
        documentReadonly = false;
        locationReadonly = false;
        gradeReadonly = false;
        matReadonly = false;
        lotReadonly = false;
        palletnumberReadonly = false;
        pallettypeReadonly = false;
        remainweightReadonly = false;
        palletweightReadonly = false;

        historyEnabled = false;
        backEnabled = false;
        submitEnabled = false;
        finishEnabled = false;
      });
    } else if (step == 1) {
      setState(() {
        documentReadonly = true;
        locationReadonly = false;
        gradeReadonly = false;
        matReadonly = false;
        lotReadonly = false;
        palletnumberReadonly = false;
        pallettypeReadonly = false;
        remainweightReadonly = false;
        palletweightReadonly = false;

        historyEnabled = true;
        backEnabled = true;
        submitEnabled = false;
        finishEnabled = false;
      });
    } else if (step == 2) {
      setState(() {
        documentReadonly = true;
        locationReadonly = true;
        gradeReadonly = false;
        matReadonly = false;
        lotReadonly = false;
        palletnumberReadonly = false;
        pallettypeReadonly = false;
        remainweightReadonly = false;
        palletweightReadonly = false;

        historyEnabled = true;
        backEnabled = true;
        submitEnabled = false;
        finishEnabled = false;
      });
    } else if (step == 3) {
      setState(() {
        documentReadonly = true;
        locationReadonly = true;
        gradeReadonly = true;
        matReadonly = true;
        lotReadonly = true;
        palletnumberReadonly = true;
        pallettypeReadonly = true;
        remainweightReadonly = true;
        palletweightReadonly = true;

        historyEnabled = true;
        backEnabled = true;
        submitEnabled = true;
        finishEnabled = false;
      });
    } else if (step == 4) {
      bool? temp = resultDocument?.silo;
      bool siloTemp = temp!;
      if (siloTemp) {
        setState(() {
          documentReadonly = true;
          locationReadonly = true;
          gradeReadonly = true;
          matReadonly = true;
          lotReadonly = true;
          palletnumberReadonly = true;
          pallettypeReadonly = true;
          remainweightReadonly = true;
          palletweightReadonly = true;

          historyEnabled = true;
          backEnabled = true;
          submitEnabled = false;
          finishEnabled = true;
        });
      } else {
        setState(() {
          documentReadonly = true;
          locationReadonly = true;
          gradeReadonly = true;
          matReadonly = true;
          lotReadonly = true;
          palletnumberReadonly = true;
          pallettypeReadonly = true;
          remainweightReadonly = true;
          palletweightReadonly = true;

          historyEnabled = true;
          backEnabled = true;
          submitEnabled = false;
          finishEnabled = true;
        });
      }
    }
  }

  void setColor() {
    if (step == 0) {
      setState(() {
        documentColor = Color(0xFFFFFFFF);
        locationColor = Color(0xFFFFFFFF);
        gradeColor = Color(0xFFFFFFFF);
        matColor = Color(0xFFFFFFFF);
        lotColor = Color(0xFFFFFFFF);
        palletnumberColor = Color(0xFFFFFFFF);
        pallettypeColor = Color(0xFFFFFFFF);
        remainweightColor = Color(0xFFFFFFFF);
        palletweightColor = Color(0xFFFFFFFF);
      });
    } else if (step == 1) {
      setState(() {
        documentColor = Color(0xFFEEEEEE);
        locationColor = Color(0xFFFFFFFF);
        gradeColor = Color(0xFFFFFFFF);
        matColor = Color(0xFFFFFFFF);
        lotColor = Color(0xFFFFFFFF);
        palletnumberColor = Color(0xFFFFFFFF);
        pallettypeColor = Color(0xFFFFFFFF);
        remainweightColor = Color(0xFFFFFFFF);
        palletweightColor = Color(0xFFFFFFFF);
      });
    } else if (step == 2) {
      setState(() {
        documentColor = Color(0xFFEEEEEE);
        locationColor = Color(0xFFEEEEEE);
        gradeColor = Color(0xFFFFFFFF);
        matColor = Color(0xFFFFFFFF);
        lotColor = Color(0xFFFFFFFF);
        palletnumberColor = Color(0xFFFFFFFF);
        pallettypeColor = Color(0xFFFFFFFF);
        remainweightColor = Color(0xFFFFFFFF);
        palletweightColor = Color(0xFFFFFFFF);
      });
    } else if (step == 3) {
      setState(() {
        documentColor = Color(0xFFEEEEEE);
        locationColor = Color(0xFFEEEEEE);
        gradeColor = Color(0xFFEEEEEE);
        matColor = Color(0xFFEEEEEE);
        lotColor = Color(0xFFEEEEEE);
        palletnumberColor = Color(0xFFEEEEEE);
        pallettypeColor = Color(0xFFEEEEEE);
        remainweightColor = Color(0xFFEEEEEE);
        palletweightColor = Color(0xFFEEEEEE);
      });
    }
  }

  void setText() {
    if (step == 0) {
      setState(() {
        documentController.text = "";
        locationController.text = "";
        gradeController.text = "";
        matController.text = "";
        lotController.text = "";
        palletnumberController.text = "";
        pallettypeController.text = "";
        remainweightController.text = "";
        palletweightController.text = "";
      });
    } else if (step == 1) {
      setState(() {
        documentController.text = documentIdInput;
        locationController.text = "";
        gradeController.text = "";
        matController.text = "";
        lotController.text = "";
        palletnumberController.text = "";
        pallettypeController.text = "";
        remainweightController.text = "";
        palletweightController.text = "";
      });
    } else if (step == 2) {
      setState(() {
        documentController.text = documentIdInput;
        locationController.text = locationInput;
        gradeController.text = "";
        matController.text = "";
        lotController.text = "";
        palletnumberController.text = "";
        pallettypeController.text = "";
        remainweightController.text = "";
        palletweightController.text = "";
      });
    } else if (step == 3) {
      setState(() {
        documentController.text = documentIdInput;
        locationController.text = locationInput;
        gradeController.text = gradeInput;
        matController.text = matInput;
        lotController.text = lotInput;
        palletnumberController.text = palletnumberInput;
        pallettypeController.text = pallettypeInput;
        remainweightController.text = remainweightInput;
        palletweightController.text = palletweightInput;
      });
    }
  }

  void setFocus() {
    if (step == 0) {
      Future.delayed(Duration(milliseconds: 100))
          .then((_) => FocusScope.of(context).requestFocus(focusNodes[0]));
    } else if (step == 1) {
      Future.delayed(Duration(milliseconds: 100))
          .then((_) => FocusScope.of(context).requestFocus(focusNodes[1]));
    } else if (step == 2) {
      Future.delayed(Duration(milliseconds: 100))
          .then((_) => FocusScope.of(context).requestFocus(focusNodes[2]));
    } else if (step == 3) {
      Future.delayed(Duration(milliseconds: 100))
          .then((_) => FocusScope.of(context).requestFocus(focusNodes[3]));
    } else if (step == 4) {
      Future.delayed(Duration(milliseconds: 100))
          .then((_) => FocusScope.of(context).requestFocus(focusNodes[4]));
    }
  }

  void showErrorDialog(String error) {
    //MyWidget.showMyAlertDialog(context, "Error", error);
    alertDialog(error, 'Error');
  }

  void showSuccessDialog(String success) {
    //MyWidget.showMyAlertDialog(context, "Success", success);
    alertDialog(success, 'Success');
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

  Future<void> documentIDCheck() async {
    setState(() {
      documentIdInput = documentController.text;
    });
    var url =
        Uri.parse(configs + '/api/api/document/validategr/' + documentIdInput);
    http.Response response = await http.get(url);

    if (response.statusCode != 200) {
      showErrorDialog('Error Http Requests documentIDCheck GR');
      return;
    }

    var data = json.decode(response.body);
    setState(() {
      resultValDocument = ResValidateDocument.fromJson(data);
      resultDocument = resultValDocument?.document;
    });

    if (resultDocument == null) {
      showErrorDialog(resultValDocument!.errorMsg.toString());
    } else {
      if (resultValDocument!.errorMsg.toString() == "") {
        setState(() {
          step++;
        });
      } else {
        //silo
        setState(() {
          step = 4;
          documentVisible = true;
          documentReadonly = true;
          documentColor = Color(0xFFEEEEEE);
          documentController.text = documentIdInput;
        });
        showErrorDialog(resultValDocument!.errorMsg.toString());
      }
    }
    setVisible();
    setReadOnly();
    setColor();
    setText();
    setFocus();
  }

  Future<void> locationCheck() async {
    setState(() {
      locationInput = locationController.text;
    });

    var url = Uri.parse(configs +
        '/api/api/location/validategr/' +
        documentIdInput +
        '/' +
        locationInput);
    http.Response response = await http.get(url);

    if (response.statusCode != 200) {
      showErrorDialog('Error Http Requests locationCheck GR');
      return;
    }

    var data = json.decode(response.body);
    setState(() {
      resultValLocation = ResValidateLocation.fromJson(data);
      resultLocation = resultValLocation?.location;
    });

    if (resultLocation == null) {
      showErrorDialog(resultValLocation!.errorMsg.toString());
    } else {
      setState(() {
        step++;
      });
    }
    setVisible();
    setReadOnly();
    setColor();
    setText();
    setFocus();
  }

  Future<void> gradeCheck() async {
    setState(() {
      gradeInput = gradeController.text;
      gradeInput = gradeInput.replaceAll('/', ' ');
    });

    int? temp = resultLocation?.binId;
    int binIdTemp = temp!;
    var url = Uri.parse(configs +
        '/api/api/palletitem/validategr/' +
        documentIdInput +
        '/' +
        gradeInput +
        '/' +
        binIdTemp.toString());
    http.Response response = await http.get(url);

    if (response.statusCode != 200) {
      showErrorDialog('Error Http Requests gradeCheck GR');
      return;
    }

    var data = json.decode(response.body);
    setState(() {
      resultValPallet = ResValidatePalletitem.fromJson(data);
      resultPalletitem = resultValPallet?.palletitem;
    });
    bool isPostedTemp = false;
    if (resultPalletitem != null) {
      bool? temp2 = resultPalletitem?.isPosted;
      isPostedTemp = temp2!;
    }

    if (resultPalletitem == null || isPostedTemp) {
      showErrorDialog(resultValPallet!.errorMsg.toString());
    } else {
      setState(() {
        step++;
        matInput = resultValPallet!.matdescription.toString();
        lotInput = resultValPallet!.palletitem!.lot.toString();
        palletnumberInput = resultValPallet!.palletitem!.palletNo.toString();
        pallettypeInput = resultValPallet!.pallettypename.toString();
        remainweightInput = resultValPallet!.remainingweight.toString();
        palletweightInput = resultValPallet!.palletitem!.weight.toString();
      });
    }
    setVisible();
    setReadOnly();
    setColor();
    setText();
    setFocus();
  }

  Future<void> submitGR() async {
    print("disable submit");
    setState(() {
      submitEnabled = false;
    });
    await showProgressLoading(false);
    int? temp = resultPalletitem?.materialId;
    String materialIdTemp = temp!.toString();
    String? temp2 = resultPalletitem?.lot;
    String lotTemp = temp2.toString();
    String? temp3 = resultPalletitem?.palletNo;
    String palletNoTemp = temp3!.toString();

    var url = Uri.parse(configs +
        '/api/api/palletitem/checkdup/' +
        documentIdInput +
        '/' +
        materialIdTemp +
        '/' +
        lotTemp +
        '/' +
        palletNoTemp);
    print("call get api checkup palletitem");
    http.Response response = await http.get(url);

    if (response.statusCode != 200) {
      await showProgressLoading(true);
      showErrorDialog('Error Http Requests submitGR1 GR');
      return;
    }
    print("success call get api checkup palletitem");

    var data = json.decode(response.body);

    String tempAPI = configs + '/api/';
    int? temp5 = resultPalletitem?.palletItemId;
    int palletItemIDtemp = temp5!;
    bool? temp6 = resultDocument?.silo;
    bool siloTemp = temp6!;

    if (data != null) {
      await showProgressLoading(true);
      showErrorDialog("Pallet is Duplicate");
    } else {
      if (palletItemIDtemp == 0) {
        DateTime? a = DateTime.now();
        int? temp = resultLocation?.binId;
        int binIdtemp = temp!;
        setState(() {
          resultPalletitem!.scanOn = a.toString();
          resultPalletitem!.binId = binIdtemp;
          resultPalletitem!.scanBy = username;
          resultPalletitem!.createdBy = username;
          resultPalletitem!.deviceInfo = deviceInfo;
        });

        if (siloTemp) {
          tempAPI += 'api/palletitem/createandupdatestatus';
        } else {
          tempAPI += 'api/palletitem/createandpost';
        }
      } else {
        DateTime? a = DateTime.now();
        int? temp = resultLocation?.binId;
        int binIdtemp = temp!;
        setState(() {
          resultPalletitem!.scanOn = a.toString();
          resultPalletitem!.binId = binIdtemp;
          resultPalletitem!.scanBy = username;
          resultPalletitem!.modifiedBy = username;
          resultPalletitem!.deviceInfo = deviceInfo;
        });
        tempAPI += 'api/palletitem/updateandpost';
      }

      final uri2 = Uri.parse(tempAPI);
      final headers2 = {'Content-Type': 'application/json'};
      var jsonBody2 = jsonEncode(resultPalletitem?.toJson());
      final encoding2 = Encoding.getByName('utf-8');
      print("call post api updateandpost palletitem");
      http.Response response2 = await http.post(
        uri2,
        headers: headers2,
        body: jsonBody2,
        encoding: encoding2,
      );

      if (response.statusCode != 200) {
        await showProgressLoading(true);
        showErrorDialog('Error Http Requests submitGR2 GR');
        return;
      }

      print("success call post api updateandpost palletitem");
      var data2 = json.decode(response2.body);
      setState(() {
        resultPalletitem = Palletitem.fromJson(data2);
      });

      if (resultPalletitem!.isDeleted == true) {
        await showProgressLoading(true);
        showErrorDialog(resultPalletitem!.damageBy.toString());
      } else if (((resultPalletitem!.isDeleted == false &&
                  resultPalletitem!.isPosted == true) &&
              temp6 == false) ||
          ((resultPalletitem!.isDeleted == false &&
                  resultPalletitem!.isPosted == false) &&
              temp6 == true)) {
        if (siloTemp) {
          setState(() {
            resultDocument!.documentStatus = "Scan Completed";
          });
        } else {
          setState(() {
            resultDocument!.documentStatus = "In Progress";
          });
        }

        tempAPI = configs + '/api/api/document/updatemobile';
        final uri3 = Uri.parse(tempAPI);
        final headers3 = {'Content-Type': 'application/json'};
        var jsonBody3 = jsonEncode(resultDocument?.toJson());
        final encoding3 = Encoding.getByName('utf-8');
        print("call post api update document when first post");
        http.Response response3 = await http.post(
          uri3,
          headers: headers3,
          body: jsonBody3,
          encoding: encoding3,
        );

        if (response.statusCode != 200) {
          await showProgressLoading(true);
          showErrorDialog('Error Http Requests submitGR3 GR');
          return;
        }

        print("success call post api update document when first post");
        var data3 = json.decode(response3.body);
        setState(() {
          resultDocument = Document.fromJson(data3);
        });

        bool? temp7 = resultDocument?.silo;
        bool siloTemp2 = temp7!;
        double? temp8 = resultValPallet?.remainingdocument;
        double remainingtemp = temp8!;
        double? temp9 = resultPalletitem?.weight;
        double wieghttemp = temp9!;

        if (!siloTemp2 && remainingtemp - wieghttemp <= 0) {
          setState(() {
            step++;
          });
        } else if (siloTemp2) {
          setState(() {
            step = 0;
          });
        } else {
          setState(() {
            step--;
          });
        }
        await showProgressLoading(true);
        showSuccessDialog('Post Complete');
      } else {
        await showProgressLoading(true);
        showErrorDialog('Post Failed');
      }
    }
    setVisible();
    setReadOnly();
    setColor();
    setText();
    setFocus();
  }

  Future<void> finishGR() async {
    print("disable finish");
    setState(() {
      finishEnabled = false;
    });
    await showProgressLoading(false);
    setState(() {
      resultDocument!.documentStatus = "Scan Completed";
      resultDocument!.modifiedBy = username;
    });

    String tempAPI = configs + '/api/api/document/updatemobile';
    final uri = Uri.parse(tempAPI);
    final headers = {'Content-Type': 'application/json'};
    var jsonBody = jsonEncode(resultDocument?.toJson());
    final encoding = Encoding.getByName('utf-8');
    print("call post api update document when finish");
    http.Response response = await http.post(
      uri,
      headers: headers,
      body: jsonBody,
      encoding: encoding,
    );

    if (response.statusCode != 200) {
      await showProgressLoading(true);
      showErrorDialog('Error Http Requests finishGR GR');
      return;
    }

    print("success call post api update document when finish");

    var data = json.decode(response.body);
    setState(() {
      resultDocument = Document.fromJson(data);
    });

    if (resultDocument == null) {
      await showProgressLoading(true);
      showErrorDialog(resultValDocument!.errorMsg.toString());
    } else {
      setState(() {
        step = 0;
      });
      await showProgressLoading(true);
      showSuccessDialog('Scan Complete');
    }
    setVisible();
    setReadOnly();
    setColor();
    setText();
    setFocus();
  }

  void back() {
    setState(() {
      if (step == 4) {
        step = 0;
      } else {
        step--;
      }
    });
  }

  Future<void> scanQR() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    if (step == 0) {
      setState(() {
        documentController.text = barcodeScanRes;
      });
      documentIDCheck();
    } else if (step == 1) {
      setState(() {
        locationController.text = barcodeScanRes;
      });
      locationCheck();
    } else if (step == 2) {
      setState(() {
        gradeController.text = barcodeScanRes;
      });
      gradeCheck();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 50,
          leading: BackButton(color: Colors.black),
          backgroundColor: Colors.white,
          title: Text(
            'GoodsReceived',
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: Colors.black, fontSize: 18),
          ),
          actions: <Widget>[
            IconButton(
                icon: Icon(
                  Icons.qr_code_scanner_rounded,
                  color: Colors.black,
                ),
                onPressed: scanQR)
          ],
        ),
        body: Container(
            child: SingleChildScrollView(
                child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 16,
              ),
              Container(
                  padding: new EdgeInsets.only(
                      left: MediaQuery.of(context).size.width / 5,
                      right: MediaQuery.of(context).size.width / 5),
                  child: Visibility(
                      visible: documentVisible,
                      child: TextFormField(
                        focusNode: focusNodes[0],
                        readOnly: documentReadonly,
                        textInputAction: TextInputAction.go,
                        style: TextStyle(fontSize: 13),
                        onFieldSubmitted: (value) {
                          documentIDCheck();
                        },
                        decoration: InputDecoration(
                          //icon: const Icon(Icons.person),
                          fillColor: documentColor,
                          filled: true,
                          hintText: 'Enter Document No.',
                          labelText: 'Document Number',
                          labelStyle: TextStyle(fontSize: 13),
                          border: OutlineInputBorder(),
                          isDense: true, // Added this
                          contentPadding: EdgeInsets.all(6), //
                        ),
                        controller: documentController,
                      ))),
              SizedBox(
                height: 12,
              ),
              Container(
                  padding: new EdgeInsets.only(
                      left: MediaQuery.of(context).size.width / 5,
                      right: MediaQuery.of(context).size.width / 5),
                  child: Visibility(
                      visible: locationVisible,
                      child: TextFormField(
                        focusNode: focusNodes[1],
                        readOnly: locationReadonly,
                        textInputAction: TextInputAction.go,
                        style: TextStyle(fontSize: 13),
                        onFieldSubmitted: (value) {
                          locationCheck();
                        },
                        decoration: InputDecoration(
                          //icon: const Icon(Icons.person),
                          fillColor: locationColor,
                          filled: true,
                          hintText: 'Enter Location',
                          labelText: 'Location',
                          labelStyle: TextStyle(fontSize: 13),
                          border: OutlineInputBorder(),
                          isDense: true, // Added this
                          contentPadding: EdgeInsets.all(6), //
                        ),
                        controller: locationController,
                      ))),
              SizedBox(
                height: 12,
              ),
              Container(
                  padding: new EdgeInsets.only(
                      left: MediaQuery.of(context).size.width / 5,
                      right: MediaQuery.of(context).size.width / 5),
                  child: Visibility(
                      visible: gradeVisible,
                      child: TextFormField(
                        focusNode: focusNodes[2],
                        readOnly: gradeReadonly,
                        textInputAction: TextInputAction.go,
                        style: TextStyle(fontSize: 13),
                        onFieldSubmitted: (value) {
                          gradeCheck();
                        },
                        decoration: InputDecoration(
                          //icon: const Icon(Icons.person),
                          fillColor: gradeColor,
                          filled: true,
                          hintText: 'Enter Grade Label',
                          labelText: 'GradeLabel',
                          labelStyle: TextStyle(fontSize: 13),
                          border: OutlineInputBorder(),
                          isDense: true, // Added this
                          contentPadding: EdgeInsets.all(6), //
                        ),
                        controller: gradeController,
                      ))),
              SizedBox(
                height: 12,
              ),
              Container(
                  padding: new EdgeInsets.only(
                      left: MediaQuery.of(context).size.width / 5,
                      right: MediaQuery.of(context).size.width / 5),
                  child: Visibility(
                      visible: matVisible,
                      child: TextFormField(
                        readOnly: matReadonly,
                        textInputAction: TextInputAction.go,
                        style: TextStyle(fontSize: 13),
                        onFieldSubmitted: (value) {},
                        decoration: InputDecoration(
                          //icon: const Icon(Icons.person),
                          fillColor: matColor,
                          filled: true,
                          hintText: 'Enter Mat Desc.',
                          labelText: 'Mat Descriptions',
                          labelStyle: TextStyle(fontSize: 13),
                          border: OutlineInputBorder(),
                          isDense: true, // Added this
                          contentPadding: EdgeInsets.all(6), //
                        ),
                        controller: matController,
                      ))),
              SizedBox(
                height: 12,
              ),
              Container(
                  padding: new EdgeInsets.only(
                      left: MediaQuery.of(context).size.width / 5,
                      right: MediaQuery.of(context).size.width / 5),
                  child: Visibility(
                      visible: lotVisible,
                      child: TextFormField(
                        readOnly: locationReadonly,
                        textInputAction: TextInputAction.go,
                        style: TextStyle(fontSize: 13),
                        onFieldSubmitted: (value) {},
                        decoration: InputDecoration(
                          //icon: const Icon(Icons.person),
                          fillColor: lotColor,
                          filled: true,
                          hintText: 'Enter Lot',
                          labelText: 'Lot',
                          labelStyle: TextStyle(fontSize: 13),
                          border: OutlineInputBorder(),
                          isDense: true, // Added this
                          contentPadding: EdgeInsets.all(6), //
                        ),
                        controller: lotController,
                      ))),
              SizedBox(
                height: 12,
              ),
              Container(
                  padding: new EdgeInsets.only(
                      left: MediaQuery.of(context).size.width / 5,
                      right: MediaQuery.of(context).size.width / 5),
                  child: Visibility(
                      visible: palletnumberVisible,
                      child: TextFormField(
                        readOnly: palletnumberReadonly,
                        textInputAction: TextInputAction.go,
                        style: TextStyle(fontSize: 13),
                        onFieldSubmitted: (value) {},
                        decoration: InputDecoration(
                          //icon: const Icon(Icons.person),
                          fillColor: palletnumberColor,
                          filled: true,
                          hintText: 'Enter Pallet No.',
                          labelText: 'Pallet Number',
                          labelStyle: TextStyle(fontSize: 13),
                          border: OutlineInputBorder(),
                          isDense: true, // Added this
                          contentPadding: EdgeInsets.all(6), //
                        ),
                        controller: palletnumberController,
                      ))),
              SizedBox(
                height: 12,
              ),
              Container(
                  padding: new EdgeInsets.only(
                      left: MediaQuery.of(context).size.width / 5,
                      right: MediaQuery.of(context).size.width / 5),
                  child: Visibility(
                      visible: pallettypeVisible,
                      child: TextFormField(
                        readOnly: pallettypeReadonly,
                        textInputAction: TextInputAction.go,
                        style: TextStyle(fontSize: 13),
                        onFieldSubmitted: (value) {},
                        decoration: InputDecoration(
                          //icon: const Icon(Icons.person),
                          fillColor: pallettypeColor,
                          filled: true,
                          hintText: 'Enter Pallet Type',
                          labelText: 'Pallet Type',
                          labelStyle: TextStyle(fontSize: 13),
                          border: OutlineInputBorder(),
                          isDense: true, // Added this
                          contentPadding: EdgeInsets.all(6), //
                        ),
                        controller: pallettypeController,
                      ))),
              SizedBox(
                height: 12,
              ),
              Container(
                  padding: new EdgeInsets.only(
                      left: MediaQuery.of(context).size.width / 5,
                      right: MediaQuery.of(context).size.width / 5),
                  child: Visibility(
                      visible: remainweightVisible,
                      child: TextFormField(
                        readOnly: remainweightReadonly,
                        textInputAction: TextInputAction.go,
                        style: TextStyle(fontSize: 13),
                        onFieldSubmitted: (value) {},
                        decoration: InputDecoration(
                          //icon: const Icon(Icons.person),
                          fillColor: remainweightColor,
                          filled: true,
                          hintText: 'Enter Remain Weight',
                          labelText: 'Remain Weight',
                          labelStyle: TextStyle(fontSize: 13),
                          border: OutlineInputBorder(),
                          isDense: true, // Added this
                          contentPadding: EdgeInsets.all(6), //
                        ),
                        controller: remainweightController,
                      ))),
              SizedBox(
                height: 12,
              ),
              Container(
                  padding: new EdgeInsets.only(
                      left: MediaQuery.of(context).size.width / 5,
                      right: MediaQuery.of(context).size.width / 5),
                  child: Visibility(
                      visible: palletweightVisible,
                      child: TextFormField(
                        readOnly: palletweightReadonly,
                        textInputAction: TextInputAction.go,
                        style: TextStyle(fontSize: 13),
                        onFieldSubmitted: (value) {},
                        decoration: InputDecoration(
                          //icon: const Icon(Icons.person),
                          fillColor: palletweightColor,
                          filled: true,
                          hintText: 'Enter Pallet Weight',
                          labelText: 'Pallet Weight',
                          labelStyle: TextStyle(fontSize: 13),
                          border: OutlineInputBorder(),
                          isDense: true, // Added this
                          contentPadding: EdgeInsets.all(6), //
                        ),
                        controller: palletweightController,
                      ))),
              SizedBox(
                height: 6,
              ),
              new Center(
                child: new ButtonBar(
                  mainAxisSize: MainAxisSize
                      .min, // this will take space as minimum as posible(to center)
                  children: <Widget>[
                    Container(
                      width: 70.0,
                      height: 30.0,
                      child: new RaisedButton(
                        color: Colors.blue,
                        child: const Text('History',
                            style: TextStyle(
                              color: Colors.white,
                            )),
                        onPressed: historyEnabled
                            ? () {
                                // showHistoryDialog();
                                setDocumentIdSession();
                                setHistoryAppBarSession();
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => History()));
                              }
                            : null,
                      ),
                    ),
                    Container(
                      width: 70.0,
                      height: 30.0,
                      child: new RaisedButton(
                        color: Colors.blue,
                        child: const Text('Back',
                            style: TextStyle(
                              color: Colors.white,
                            )),
                        onPressed: backEnabled
                            ? () {
                                back();
                                setVisible();
                                setReadOnly();
                                setColor();
                                setText();
                                setFocus();
                              }
                            : null,
                      ),
                    ),
                    Container(
                      width: 70.0,
                      height: 30.0,
                      child: new RaisedButton(
                        focusNode: focusNodes[3],
                        color: step == 3 ? Colors.green : Colors.blue,
                        child: const Text('Submit',
                            style: TextStyle(
                              color: Colors.white,
                            )),
                        onPressed: submitEnabled
                            ? () {
                                submitGR();
                                /*Scaffold.of(context).showSnackBar(
                                  SnackBar(content: Text('Post Complete')));*/
                              }
                            : null,
                      ),
                    ),
                    Container(
                      width: 70.0,
                      height: 30.0,
                      child: new RaisedButton(
                        focusNode: focusNodes[4],
                        color: step == 4 ? Colors.green : Colors.blue,
                        child: const Text('Finish',
                            style: TextStyle(
                              color: Colors.white,
                            )),
                        onPressed: finishEnabled
                            ? () {
                                finishGR();
                              }
                            : null,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 16,
              ),
            ],
          ),
        ))));
  }
}
