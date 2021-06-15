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
  int _totpCounter = 1;
  TOTP? totp;

  double _percent = 0.0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _currentTimeTimer = Timer.periodic(const Duration(milliseconds: 1000), (timer) {
      setState(() {
        _currentTimeText = DateTime.now().toString();
      });
    });

    totp = TOTP(secret: "J22U6B3WIWRRBTAV", digits: 6, interval: 30);
    setState(() {
      _totpText = totp!.now();
    });
    print("_totpText");
    _toptTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      int s = DateTime.now().second;
      print("second: $s");
      if(s > 30){
        s = 59 - s;
      }
      _totpCounter = s ~/ 30;
      print("_totpCounter : ${_totpCounter}");

      if(DateTime.now().second % 30 == 0){
        setState(() {
          _totpCounter = 1;
          _totpText = totp!.now();
        });
      }

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
                                    _totpText != ""
                                        ? "${_totpText.substring(0, 3) + " " + _totpText.substring(3, 6)}"
                                        : "",
                                    style: const TextStyle(fontSize: 64, color: Colors.black),
                                  ),
                                  cc.Meter(
                                    gridFrequency: 0.25,
                                    percentage: _totpCounter != 1 ? _totpCounter / 31 : 0,
                                    child: Text("${(_totpCounter / 31).toStringAsFixed(2)}"),
                                  ),
                                  Text(
                                    "${_totpCounter.toString()} s",
                                    style: const TextStyle(fontSize: 64, color: Colors.black),
                                  ),
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
