import 'package:bot/utils/http.dart';
import 'package:flutter/material.dart';

class ChannelPage extends StatefulWidget {
  final int id;
  const ChannelPage({super.key, required this.id});

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
        channelMessages = List<Map<String, dynamic>>.from(response);
      });
    } else {
      throw Exception('Invalid response format');
    }
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Align(
        alignment: Alignment.center,
        child: Column(
          children: [
            Text(widget.id.toString())
          ],
        ),
      ),
    );
  }
}
