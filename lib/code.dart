import 'package:bot/home.dart';
import 'package:bot/utils/AccessToken.dart';
import 'package:bot/utils/helper.dart';
import 'package:bot/utils/http.dart';
import 'package:flutter/material.dart';

class CodeScreen extends StatefulWidget {
  final String email;
  const CodeScreen({super.key, required this.email});

  @override
  State<CodeScreen> createState() => _CodeScreenState();
}

class _CodeScreenState extends State<CodeScreen> {

  final TextEditingController _codeController = TextEditingController();
  String _enteredCode = '';


  final RegExp _emailRegex = RegExp(
    r'[0-9]{4}$',
  );

  void _sendCode() async {
    final enteredEmail = _codeController.text;

    if (_emailRegex.hasMatch(enteredEmail)) {
      setState(() {
        _enteredCode = enteredEmail;
      });
      final requestData = {
        'email': widget.email,
        'code': _enteredCode,
      };
      try {
        final response = await ApiUtil.postRequest('checkCode', requestData);
        final parsedResponse = Map<String, dynamic>.from(response);
        bool status = parsedResponse['status'];
        if(status){

          String token = parsedResponse['token'];
          AccessTokenUtil.saveAccessToken(token);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Home()),
          );
        }else{
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('کد نامعتبر'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('باشه'),
                ),
              ],
            ),
          );
        }
        print(response);
      } catch (error) {
        print('Error: $error');
      }
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('کد نا معتبر'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('باشه'),
            ),
          ],
        ),
      );
    }
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }







  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'کد ارسال شده به ایمیلتان را وارد کنید',
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.blueAccent,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: Helper.getScreenWidth(context) - 30,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.white,
                    width: 2.0, // Border width
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade200,
                      offset: Offset(0, 2),
                      blurRadius: 10,
                    ),
                  ],
                  gradient: LinearGradient(
                    colors: [Colors.white60, Colors.white],
                    // Gradient colors
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Expanded(
                    child: TextFormField(
                      controller: _codeController,
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(color: Colors.blueAccent),
                      decoration: InputDecoration(
                          hintText: 'کد 4 رقمی',
                          hintStyle: TextStyle(color: Colors.blueAccent),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 15),
                          hintTextDirection: TextDirection.rtl),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Expanded(
                  child: ElevatedButton(
                    onPressed: _sendCode,
                    child: Text('تایید',
                        style: TextStyle(color: Colors.white, fontSize: 16)),
                    style: ElevatedButton.styleFrom(
                        primary: Colors.blue.shade200, // Background color
                        onPrimary: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
