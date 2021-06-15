import 'dart:async';

import 'package:flutter/material.dart';
import 'package:chicago/chicago.dart' as cc;
import 'package:dart_otp/dart_otp.dart';

class TwoFAMainPage extends StatefulWidget {
  final String title;

  TwoFAMainPage({Key? key, required this.title}) : super(key: key);

  @override
  State<TwoFAMainPage> createState() => _TwoFAMainPageState();
}

class _TwoFAMainPageState extends State<TwoFAMainPage> {
  Timer? _currentTimeTimer;
  Timer? _toptTimer;
  String _currentTimeText = "";
  String _totpText = "";
  int _totpCounter = 0;

  TOTP totp = TOTP(secret: "J22U6B3WIWRRBTAV", digits: 6, interval: 30);
  double _percent = 0.0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _currentTimeTimer = Timer.periodic(Duration(milliseconds: 250), (timer) {
      setState(() {
        _currentTimeText = DateTime.now().toString();
      });
    });
    _toptTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      _totpCounter++;
      print(_totpCounter);
      print(_totpCounter / 30);
      _percent = _totpCounter / 30;
      print(_percent);
      if (_totpCounter == 30) {
        _totpCounter = 0;
      }
      setState(() {
        _totpText = totp.now();
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _currentTimeTimer?.cancel();
    _toptTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffdddcd5),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Text(
              "${_currentTimeText}",
              style: TextStyle(fontSize: 18),
            ),
            cc.TextInput(),
            SizedBox(height: 8),
            Expanded(
              child: cc.TabPane(
                initialSelectedIndex: 0,
                tabs: [
                  cc.Tab(
                      label: "TOTP",
                      builder: (context) => SizedBox(
                            height: MediaQuery.of(context).size.height / 2,
                            width: MediaQuery.of(context).size.width / 2,
                            child: Center(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    _totpText,
                                    style: const TextStyle(fontSize: 64, color: Colors.black),
                                  ),
                                  cc.Meter(
                                    gridFrequency: 0.25,
                                    percentage:_totpCounter != 0 ?  _totpCounter / 31: 0,
                                    child: Text("${(_totpCounter / 31).toStringAsFixed(2)}"),
                                  )
                                ],
                              ),
                            ),
                          )),
                  cc.Tab(label: "HOTP", builder: (context) => Column()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
