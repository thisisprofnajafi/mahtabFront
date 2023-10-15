import 'package:bot/code.dart';
import 'package:bot/utils/helper.dart';
import 'package:bot/utils/http.dart';
import 'package:flutter/material.dart';

class EmailScreen extends StatefulWidget {
  const EmailScreen({super.key});

  @override
  State<EmailScreen> createState() => _EmailScreenState();
}

class _EmailScreenState extends State<EmailScreen> {
  final TextEditingController _emailController = TextEditingController();
  String _enteredEmail = '';

  final RegExp _emailRegex = RegExp(
    r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$',
  );

  void _submitEmail() async {
    final enteredEmail = _emailController.text;

    if (_emailRegex.hasMatch(enteredEmail)) {
      setState(() {
        _enteredEmail = enteredEmail;
      });
      final requestData = {
        'email': _enteredEmail,
      };
      try {
        final response = await ApiUtil.postRequest('login', requestData);
        final parsedResponse = Map<String, dynamic>.from(response);
        bool status = parsedResponse['status'];
        if (status) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => CodeScreen(email: _enteredEmail),
            ),
          );
        } else {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('ایمیل ارسال نشد'),
              content: Text('مشکلی پیش آمد'),
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
          title: Text('ایمیل نادرست'),
          content: Text('لطفا یک ایمیل معتبر وارد کنید'),
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
    _emailController.dispose();
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
                'ایمیل خود را وارد کنید',
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
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(color: Colors.blueAccent),
                      decoration: InputDecoration(
                          hintText: 'ایمیل',
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
                    onPressed: _submitEmail,
                    child: Text('ارسال کد',
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
