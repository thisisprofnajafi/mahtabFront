import 'package:flutter/material.dart';

import 'ChannelPage.dart';

class ChannelCard extends StatefulWidget {
  final String image;
  final String name;
  final String channel_id;
  final String count;
  final int id;
  const ChannelCard({super.key, required this.image, required this.name, required this.id, required this.count, required this.channel_id});

  @override
  State<ChannelCard> createState() => _ChannelCardState();
}

class _ChannelCardState extends State<ChannelCard> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ChannelPage(id: widget.id),
        ));
      },
      style: ButtonStyle(
        padding: MaterialStateProperty.all(EdgeInsets.zero),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(45)),
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
        width: double.infinity,
        child: Column(
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Image.network(
                    widget.image,
                    width: 50,
                    height: 50,
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Column(
                  children: [
                    Text(
                      widget.name,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      widget.channel_id,
                      style: TextStyle(fontSize: 14),
                    )
                  ],
                ),
                SizedBox(
                  width: 50,
                ),
                Column(
                  children: [
                    Image.asset(
                      'assets/images/member.png',
                      width: 20,
                      height: 20,
                      color: Colors.blueAccent,
                    ),
                    Text(
                      widget.count.toString(),
                      style: TextStyle(fontSize: 12),
                    )
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
