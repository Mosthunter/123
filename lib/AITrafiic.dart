import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AItraffic extends StatefulWidget {
  @override
  _AItrafficState createState() => _AItrafficState();
}

class _AItrafficState extends State<AItraffic> {
  String type = "Normal";
  int status = 0;
  @override
  Widget build(BuildContext context) {
    Size a = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: a.width,
            height: a.width / 2.5,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Color(0xff6E6E6E).withOpacity(0.45),
                  spreadRadius: 0,
                  blurRadius: 7,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: Container(
              margin: EdgeInsets.only(
                  top: a.width / 10, left: a.width / 20, right: a.width / 20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(
                          Icons.keyboard_backspace,
                          size: a.width / 15,
                        ),
                      ),
                      Text(
                        "AItraffic",
                        style: TextStyle(
                            fontSize: a.width / 20,
                            fontWeight: FontWeight.bold),
                      ),
                      Icon(
                        Icons.keyboard_backspace,
                        size: a.width / 15,
                        color: Colors.white,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: a.width / 20,
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        left: a.width / 20, right: a.width / 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              type = "Normal";
                              status = 0;
                            });
                          },
                          child: Column(
                            children: [
                              Text(
                                "Normal",
                                style: TextStyle(
                                    fontSize: a.width / 30,
                                    color: type == "Normal"
                                        ? Color(0xff3DBCBD)
                                        : Color(0xff898989)),
                              )
                            ],
                          ),
                        ),
                        Container(
                          height: a.width / 8,
                          decoration: BoxDecoration(
                              border: Border.all(color: Color(0xffE3E3E3))),
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              type = "Repair";
                              status = 1;
                            });
                          },
                          child: Column(
                            children: [
                              Text(
                                "Repair",
                                style: TextStyle(
                                    fontSize: a.width / 30,
                                    color: type == "Repair"
                                        ? Color(0xff3DBCBD)
                                        : Color(0xff898989)),
                              )
                            ],
                          ),
                        ),
                        Container(
                          height: a.width / 8,
                          decoration: BoxDecoration(
                              border: Border.all(color: Color(0xffE3E3E3))),
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              type = "Damaged";
                              status = 2;
                            });
                          },
                          child: Column(
                            children: [
                              Text(
                                "Damaged",
                                style: TextStyle(
                                    fontSize: a.width / 30,
                                    color: type == "Damaged"
                                        ? Color(0xff3DBCBD)
                                        : Color(0xff898989)),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            height: a.width / 25,
          ),
          Container(
              margin: EdgeInsets.only(
                  top: a.width / 2, right: a.width / 20, left: a.width / 20),
              child: StreamBuilder(
                stream: Firestore.instance
                    .collection("data")
                    .where("status", isEqualTo: status)
                    .snapshots(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return ListView.builder(
                      padding: EdgeInsets.all(10.0),
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: a.width / 8,
                                  height: a.width / 8,
                                  decoration: BoxDecoration(boxShadow: [
                                    BoxShadow(
                                      color:
                                          Color(0xff6E6E6E).withOpacity(0.45),
                                      spreadRadius: 0,
                                      blurRadius: 7,
                                      offset: Offset(
                                          0, 3), // changes position of shadow
                                    ),
                                  ], color: Colors.white),
                                  child: Icon(Icons.traffic,
                                      size: a.width / 15,
                                      color: Color(snapshot.data
                                                  .documents[index]["color"] ==
                                              "red"
                                          ? 0xffC70607
                                          : snapshot.data.documents[index]
                                                      ["color"] ==
                                                  "yellow"
                                              ? 0xffCEAE13
                                              : 0xff07A924)),
                                ),
                                Container(
                                  width: a.width / 1.5,
                                  height: a.width / 3,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.circular(a.width / 40),
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color:
                                            Color(0xff6E6E6E).withOpacity(0.45),
                                        spreadRadius: 0,
                                        blurRadius: 7,
                                        offset: Offset(
                                            0, 3), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  padding: EdgeInsets.all(a.width / 20),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Address : ${snapshot.data.documents[index]['address'][0]} ${snapshot.data.documents[index]['address'][1]} ${snapshot.data.documents[index]['address'][2]} ${snapshot.data.documents[index]['address'][3]} ",
                                        style:
                                            TextStyle(fontSize: a.width / 30),
                                      ),
                                      Text(
                                        "Location(latitude) : ${snapshot.data.documents[index]['location'].latitude.toStringAsFixed(4)} N",
                                        style:
                                            TextStyle(fontSize: a.width / 30),
                                      ),
                                      Text(
                                        "Location(longitude) : ${snapshot.data.documents[index]['location'].longitude.toStringAsFixed(4)} S",
                                        style:
                                            TextStyle(fontSize: a.width / 30),
                                      ),
                                      Text(
                                        "Service life : ${snapshot.data.documents[index]['old']}",
                                        style:
                                            TextStyle(fontSize: a.width / 30),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                            SizedBox(height: a.width / 10)
                          ],
                        );
                      },
                      itemCount: snapshot.data.documents.length,
                    );
                  }
                },
              ))
        ],
      ),
    );
  }
}
