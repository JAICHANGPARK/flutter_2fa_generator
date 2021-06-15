import 'package:flutter/material.dart';
import 'package:chicago/chicago.dart';
import 'src/ui/2fa_main_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChicagoApp(
      title: 'Flutter Demo',
      home: TwoFAMainPage(title: 'Flutter Demo Home Page'),
    );
  }
}

