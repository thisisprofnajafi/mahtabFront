import 'package:bot/utils/helper.dart';
import 'package:bot/utils/http.dart';
import 'package:flutter/material.dart';

import 'channelCard.dart';

class ChannelPage extends StatefulWidget {
  final int id;
  final String title;
  const ChannelPage({super.key, required this.id, required this.title});

  @override
  State<ChannelPage> createState() => _ChannelPageState();
}

class _ChannelPageState extends State<ChannelPage> {
  List<Map<String, dynamic>> channelMessages = [];
  late Future fetchDataFuture;

  @override
  void initState() {
    super.initState();
    fetchDataFuture = getInfo();
  }

  Future<void> getInfo() async {
    final response = await ApiUtil.getRequest('channel/${widget.id}/messages');
    print('API Response: $response');
    if (response['messages'] is List) {
      setState(() {
        channelMessages = List<Map<String, dynamic>>.from(response['messages']);
      });
    } else {
      throw Exception('Invalid response format');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(
          widget.title,
          textAlign: TextAlign.right,
        ),
      ),
      body: FutureBuilder(
        future: fetchDataFuture,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator(); // Show a loading indicator while fetching data.
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return SingleChildScrollView(
              child: SafeArea(
                child: Container(
                  width: Helper.getScreenWidth(context),
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: channelMessages.length,
                          itemBuilder: (context, index) {
                            final message = channelMessages[index];
                            if (message['type'] == "text") {
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white60,
                                      borderRadius: BorderRadius.all(Radius.circular(5)),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black26.withOpacity(0.1),
                                          spreadRadius: 0,
                                          blurRadius: 5,
                                          offset: Offset(0, 5),
                                        ),
                                      ],
                                    ),
                                    padding: EdgeInsets.all(10),
                                    width: Helper.getScreenWidth(context) * 0.5,
                                    child: Text(message['text']),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  )
                                ],
                              );
                            } else {
                              print(message);
                              return Container(); // Handle other message types or skip them.
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
