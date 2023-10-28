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
  List<Map<String, dynamic>> channelMessages = []; // List to store channel data

  late Future fetchDataFuture;

  @override
  initState() {
    super.initState();
    fetchDataFuture = getInfo();
  }

  Future<void> getInfo() async {
    final response = await ApiUtil.getRequest('channel/${widget.id}/messages');
    print('API Response: $response'); // Print the response
    if (response['messages'] is List) {
      // Update channelData with the response data
      print("is a list");
      setState(() {
        channelMessages = List<Map<String, dynamic>>.from(response['messages']);
      });
      print(channelMessages);
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
              widget.title,
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

                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: channelMessages.length,
                          itemBuilder: (context, index) {
                            final message = channelMessages[index];
                            if(message['type'] != "text")
                              print(message);
                            if(message['type'] == "text")
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
                                  width: Helper.getScreenWidth(context)*0.5,
                                  child: Text(message['text']),
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
