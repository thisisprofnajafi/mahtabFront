import 'dart:convert';

import 'package:bot/channelCard.dart';
import 'package:bot/utils/AccessToken.dart';
import 'package:bot/utils/helper.dart';
import 'package:bot/utils/http.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController _channelController = TextEditingController();
  String _enteredChannel = '';
  List<Map<String, dynamic>> channelData = []; // List to store channel data
  void _sendCode() async {
    final enteredChannel = _channelController.text;

    setState(() {
      _enteredChannel = enteredChannel;
    });
    final requestData = {
      'id': _enteredChannel,
    };
    try {
      final response = await ApiUtil.postRequest('addChannel', requestData);
      final parsedResponse = Map<String, dynamic>.from(response);
      bool status = parsedResponse['status'];
      if (status) {
        String token = parsedResponse['token'];
      } else {
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
  }

  @override
  void dispose() {
    _channelController.dispose();
    super.dispose();
  }

  late Future fetchDataFuture;

  @override
  initState() {
    super.initState();
    fetchDataFuture = getChannels();
  }

  Future<void> getChannels() async {
    final response = await ApiUtil.getRequest('channels');
    print('API Response: $response'); // Print the response

    if (response is List) {
      // Update channelData with the response data
      print("is a list");
      setState(() {
        channelData = List<Map<String, dynamic>>.from(response);
      });
    } else {
      throw Exception('Invalid response format');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchDataFuture,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: Text(
              "مدیر کانال",
              textAlign: TextAlign.right,
            ),
          ),
          body: SingleChildScrollView(
              child: SafeArea(
            child: Container(
              width: Helper.getScreenWidth(context),
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            showModalBottomSheet(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(15))),
                              context: context,
                              builder: (c) {
                                return StatefulBuilder(
                                    builder: (context, setStateSB) {
                                  return SingleChildScrollView(
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          bottom: MediaQuery.of(context)
                                              .viewInsets
                                              .bottom),
                                      child: Container(
                                        width: Helper.getScreenWidth(context),
                                        padding: EdgeInsets.all(20),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Row(
                                              children: [
                                                SizedBox(width: 10),
                                                Text(
                                                  'افزودن کانال',
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Colors.blueAccent),
                                                )
                                              ],
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                  width: Helper.getScreenWidth(
                                                          context) -
                                                      40,
                                                  decoration: BoxDecoration(
                                                    color: Colors.blue,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    border: Border.all(
                                                      color: Colors.white,
                                                      width:
                                                          2.0, // Border width
                                                    ),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors
                                                            .grey.shade200,
                                                        offset: Offset(0, 2),
                                                        blurRadius: 10,
                                                      ),
                                                    ],
                                                    gradient: LinearGradient(
                                                      colors: [
                                                        Colors.white60,
                                                        Colors.white
                                                      ],
                                                      // Gradient colors
                                                      begin: Alignment.topLeft,
                                                      end:
                                                          Alignment.bottomRight,
                                                    ),
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Expanded(
                                                      child: TextFormField(
                                                        controller:
                                                            _channelController,
                                                        style: TextStyle(
                                                            color: Colors
                                                                .blueAccent),
                                                        decoration:
                                                            InputDecoration(
                                                          hintText:
                                                              'ایدی کانال بدون @',
                                                          hintStyle: TextStyle(
                                                              color: Colors
                                                                  .blueAccent),
                                                          border:
                                                              InputBorder.none,
                                                          contentPadding:
                                                              EdgeInsets
                                                                  .symmetric(
                                                                      vertical:
                                                                          15),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Container(
                                              width: (MediaQuery.of(context)
                                                          .size
                                                          .width -
                                                      50) /
                                                  2,
                                              decoration: BoxDecoration(
                                                color: Colors.blue,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                border: Border.all(
                                                  color: Colors.blueAccent,
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
                                                  colors: [
                                                    Colors.blueAccent,
                                                    Colors.blue
                                                  ],
                                                  // Gradient colors
                                                  begin: Alignment.topLeft,
                                                  end: Alignment.bottomRight,
                                                ),
                                              ),
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 20),
                                                child: Expanded(
                                                  child: TextButton(
                                                    onPressed: () {
                                                      _sendCode();
                                                    },
                                                    child: Text('افزودن',
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 16)),
                                                    style: ButtonStyle(),
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                });
                              },
                            );
                          },
                          child: Text("افزودن کانال"),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: channelData.length,
                      itemBuilder: (context, index) {
                        final channelInfo = channelData[index];
                        print(channelInfo);

                        String baseUrl =
                            'https://abolfazlnajafi.com/mahtab/public/media/channels';
                        String remoteUrl = channelInfo['profile_path'].replaceFirst(
                            '/home/h206274/public_html/mahtab/public/media/channels',
                            baseUrl);
                        print(remoteUrl);
                        return Column(
                          children: [
                            ChannelCard(
                              image: remoteUrl,
                              name: channelInfo['title'].toString(),
                              id: channelInfo['id'],
                              count: channelInfo['members_count'].toString(),
                              channel_id: channelInfo['channel_id'].toString(),
                            ),
                            SizedBox(
                              height: 20,
                            )
                          ],
                        );
                      },
                    )
                  ],
                ),
              ),
            ),
          )),
          // This trailing comma makes auto-formatting nicer for build methods.
        );
      },
    );
  }
}
