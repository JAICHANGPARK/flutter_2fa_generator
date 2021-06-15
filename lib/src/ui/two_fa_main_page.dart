import 'dart:async';

import 'package:flutter/material.dart';
import 'package:chicago/chicago.dart' as cc;

class TwoFAMainPage extends StatefulWidget {
  final String title;

  TwoFAMainPage({Key? key, required this.title}) : super(key: key);

  @override
  State<TwoFAMainPage> createState() => _TwoFAMainPageState();
}

class _TwoFAMainPageState extends State<TwoFAMainPage> {
  Timer? _currentTimeTimer;

  String _currentTimeText = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _currentTimeTimer = Timer.periodic(Duration(milliseconds: 250), (timer) {
      setState(() {
        _currentTimeText = DateTime.now().toString();
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _currentTimeTimer?.cancel();

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

          ],
        ),
      ),
    );
  }
}
