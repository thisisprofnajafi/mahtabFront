import 'package:bot/email.dart';
import 'package:bot/home.dart';
import 'package:bot/utils/AccessToken.dart';
import 'package:bot/utils/authUtil.dart';
import 'package:bot/utils/helper.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'مدیر کانال من',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue.shade900),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'مدیر کانال من'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final accessToken = AccessTokenUtil.readAccessToken();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      builder: (context, snapshot) {

        AuthUtil.checkAuthAndNavigate(context);
        return CircularProgressIndicator();
      }, stream: null,
    );
  }
}
