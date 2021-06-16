import 'dart:io';

import 'package:flutter/material.dart';
import 'package:chicago/chicago.dart';
import 'src/ui/two_fa_main_page.dart';
import 'package:window_size/window_size.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    setWindowTitle('Flutter 2FA Generator');
    setWindowMinSize(const Size(700, 500));
    setWindowMaxSize(Size.infinite);
  }
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
