import 'package:flutter/material.dart';

class Changelight extends StatefulWidget {
  final int color;
  final String light;
  Changelight({@required this.color, this.light});
  @override
  _ChangelightState createState() => _ChangelightState();
}

class _ChangelightState extends State<Changelight> {
  @override
  Widget build(BuildContext context) {
    Size a = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.only(bottom: a.width / 20),
      width: a.width / 5,
      height: a.width / 10,
      decoration: BoxDecoration(
          color: Color(widget.color),
          borderRadius: BorderRadius.circular(a.width)),
      alignment: Alignment.center,
      child: Text(
        widget.light,
        style: TextStyle(color: Colors.white, fontSize: a.width / 28),
      ),
    );
  }
}
