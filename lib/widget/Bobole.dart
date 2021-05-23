import 'package:flutter/material.dart';

class Bobole extends StatefulWidget {
  final int color1;
  final IconData icon1;
  final String text1;
  final String text2;
  Bobole(
      {@required this.color1,
      @required this.icon1,
      @required this.text1,
      @required this.text2});
  @override
  _BoboleState createState() => _BoboleState();
}

class _BoboleState extends State<Bobole> {
  @override
  Widget build(BuildContext context) {
    Size a = MediaQuery.of(context).size;
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            widget.icon1,
            size: a.width / 20,
            color: Color(widget.color1),
          ),
          SizedBox(
            width: a.width / 80,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${widget.text1}",
                style: TextStyle(
                    color: Color(widget.color1),
                    fontWeight: FontWeight.bold,
                    fontSize: a.width / 8),
              ),
              Text("${widget.text2}", style: TextStyle(fontSize: a.width / 40))
            ],
          )
        ],
      ),
    );
  }
}
