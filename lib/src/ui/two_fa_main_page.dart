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
  String _hotpText = "";
  int _totpCounter = 1;
  TOTP? totp;
  HOTP? hotp;

  double _percent = 0.0;
  TextEditingController _totpTextEditingController = TextEditingController();
  TextEditingController _hotpTextEditingController = TextEditingController();

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
    hotp = HOTP(secret: "J22U6B3WIWRRBTAV", digits: 6);

    setState(() {
      _totpText = totp!.now();
      _hotpText = hotp!.at(counter: 0).toString();
    });
    print("_totpText");
    _toptTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      int s = DateTime.now().second;
      print("second: $s");
      if (s > 30) {
        s = 31 - (60 - s);
      }
      _totpCounter = s % 30;
      if (_totpCounter == 0) _totpCounter = 1;
      print("_totpCounter : ${_totpCounter}");

      if (DateTime.now().second % 30 == 0) {
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
            SizedBox(
              height: 48,
              width: double.infinity,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Secret Key: ",
                    style: TextStyle(fontSize: 18),
                  ),
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: cc.TextInput(
                      controller: _totpTextEditingController,
                    ),
                  )),
                  cc.PushButton(
                      label: 'Set',
                      onPressed: () {
                        if (_totpTextEditingController.text.length > 0) {
                          String code = _totpTextEditingController.text.toUpperCase();
                          try {
                            totp = TOTP(secret: "${code}", digits: 6, interval: 30);
                            _totpTextEditingController.clear();
                            cc.Prompt.open(
                              context: context,
                              messageType: cc.MessageType.info,
                              message: 'OTP 적용 완료',
                              body: Container(),
                              options: ['OK'],
                              selectedOption: 0,
                            );
                            setState(() {
                              _totpText = totp!.now();
                            });
                          } catch (e) {
                            cc.Prompt.open(
                              context: context,
                              messageType: cc.MessageType.info,
                              message: '${e.toString()}',
                              body: Container(),
                              options: ['OK'],
                              selectedOption: 0,
                            );
                            return;
                          }
                        } else {
                          cc.Prompt.open(
                            context: context,
                            messageType: cc.MessageType.info,
                            message: "빈칸일수 없습니다.",
                            body: Container(),
                            options: ['OK'],
                            selectedOption: 0,
                          );
                        }
                      }),
                ],
              ),
            ),
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
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    _totpText != ""
                                        ? "${_totpText.substring(0, 3) + " " + _totpText.substring(3, 6)}"
                                        : "",
                                    style: const TextStyle(fontSize: 64, color: Colors.black),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      cc.ActivityIndicator(),
                                      Text(
                                        "${_totpCounter.toString()} s",
                                        style: const TextStyle(fontSize: 64, color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          )),
                  cc.Tab(
                      label: "HOTP",
                      builder: (context) => Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(24.0),
                                child: Row(
                                  children: [
                                    Text("Count Hope : "),
                                    Expanded(
                                      child: cc.TextInput(
                                        controller: _hotpTextEditingController,
                                      ),
                                    ),
                                    SizedBox(width: 16,),
                                    cc.PushButton(
                                      onPressed: () {
                                        if (_hotpTextEditingController.text.length > 0) {
                                          String code = _hotpTextEditingController.text.toUpperCase();
                                          int tmp = int.parse(code);
                                          try {
                                            _hotpTextEditingController.clear();
                                            cc.Prompt.open(
                                              context: context,
                                              messageType: cc.MessageType.info,
                                              message: 'OTP 적용 완료',
                                              body: Container(),
                                              options: ['OK'],
                                              selectedOption: 0,
                                            );
                                            setState(() {
                                              _hotpText = hotp!.at(counter: tmp).toString();
                                            });
                                          } catch (e) {
                                            cc.Prompt.open(
                                              context: context,
                                              messageType: cc.MessageType.info,
                                              message: '${e.toString()}',
                                              body: Container(),
                                              options: ['OK'],
                                              selectedOption: 0,
                                            );
                                            return;
                                          }
                                        } else {
                                          cc.Prompt.open(
                                            context: context,
                                            messageType: cc.MessageType.info,
                                            message: "빈칸일수 없습니다.",
                                            body: Container(),
                                            options: ['OK'],
                                            selectedOption: 0,
                                          );
                                        }
                                      },
                                      label: 'Set',
                                    ),
                                    SizedBox(width: 16,),
                                    cc.PushButton(
                                      label: "Reset",
                                      onPressed: () {

                                        setState(() {
                                          _hotpText = hotp!.at(counter: 0).toString();
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                _hotpText != "" ? "${_hotpText.substring(0, 3) + " " + _hotpText.substring(3, 6)}" : "",
                                style: const TextStyle(fontSize: 64, color: Colors.black),
                              ),

                            ],
                          )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
