import 'package:bot/email.dart';
import 'package:bot/home.dart';
import 'package:flutter/material.dart';
import 'accessToken.dart';

class AuthUtil {
  static Future<void> checkAuthAndNavigate(BuildContext context) async {
    final accessToken = await AccessTokenUtil.readAccessToken();
    final isLoggedIn = accessToken != null && accessToken.isNotEmpty;

    if (isLoggedIn) {
      // User is logged in, proceed to the desired screen (e.g., home screen)
      // For demonstration purposes, we will navigate to an empty home screen.
      // Replace `HomeScreen` with your actual home screen widget.
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Home()),
      );
    } else {
      // User is not logged in, redirect to the login screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => EmailScreen()),
      );
    }
  }
}
