import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Consult extends StatefulWidget {
  @override
  _ConsultState createState() => _ConsultState();
}

class _ConsultState extends State<Consult> {
  AIcalculate(int single, int one, int two, int alltime) {
    return single / (one + two + single) * alltime;
  }

  AIcalculate1(int single, int one, int two, int three, int alltime) {
    return single / (one + two + three + single) * alltime;
  }

  Stability(int settime, int single, int one, int two, int alltime) {
    return settime / (single / (one + two + single) * alltime) * 100;
  }

  Stability1(
      int settime, int single, int one, int two, int three, int alltime) {
    return settime / (single / (one + two + three + single) * alltime) * 100;
  }

  @override
  Widget build(BuildContext context) {
    Size a = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: a.width,
            height: a.width / 4,
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
            padding: EdgeInsets.only(
                top: a.width / 20, left: a.width / 20, right: a.width / 20),
            child: Row(
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
                  "Consulttraffic",
                  style: TextStyle(
                      fontSize: a.width / 20, fontWeight: FontWeight.bold),
                ),
                Icon(
                  Icons.keyboard_backspace,
                  size: a.width / 15,
                  color: Colors.white,
                ),
              ],
            ),
          ),
          Container(
            width: a.width,
            margin: EdgeInsets.only(top: a.width / 4),
            padding: EdgeInsets.only(
                top: a.width / 10, right: a.width / 20, left: a.width / 20),
            child: StreamBuilder(
              stream: Firestore.instance.collection("group").snapshots(),
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          snapshot.data.documents[index]['type'] == "3" &&
                                  snapshot.data.documents[index]['cheak'] ==
                                      true
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${snapshot.data.documents[index].documentID}",
                                      style: TextStyle(
                                          fontSize: a.width / 30,
                                          color: Color(0xff898989),
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: a.width / 20,
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                            width: a.width / 8,
                                            height: a.width / 8,
                                            decoration:
                                                BoxDecoration(boxShadow: [
                                              BoxShadow(
                                                color: Color(0xff6E6E6E)
                                                    .withOpacity(0.45),
                                                spreadRadius: 0,
                                                blurRadius: 7,
                                                offset: Offset(0,
                                                    3), // changes position of shadow
                                              ),
                                            ], color: Colors.white),
                                            child: Icon(
                                              Icons.traffic,
                                              size: a.width / 15,
                                            )),
                                        Container(
                                          width: a.width / 1.5,
                                          height: a.width / 3,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                                a.width / 40),
                                            color: Colors.white,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Color(0xff6E6E6E)
                                                    .withOpacity(0.45),
                                                spreadRadius: 0,
                                                blurRadius: 7,
                                                offset: Offset(0,
                                                    3), // changes position of shadow
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
                                                "Address : ${snapshot.data.documents[index]["1"]}",
                                                style: TextStyle(
                                                    fontSize: a.width / 30),
                                              ),
                                              Text(
                                                "Set time : ${snapshot.data.documents[index]['a1']}",
                                                style: TextStyle(
                                                    fontSize: a.width / 30),
                                              ),
                                              Text(
                                                "AI time(sec) : ${AIcalculate(snapshot.data.documents[index]['dataCar'][0], snapshot.data.documents[index]['dataCar'][1], snapshot.data.documents[index]['dataCar'][2], 120).toStringAsFixed(0)}",
                                                style: TextStyle(
                                                    fontSize: a.width / 30),
                                              ),
                                              Text(
                                                "Stability : ${Stability(snapshot.data.documents[index]['a1'], snapshot.data.documents[index]['dataCar'][0], snapshot.data.documents[index]['dataCar'][1], snapshot.data.documents[index]['dataCar'][2], 120).toStringAsFixed(2)} %",
                                                style: TextStyle(
                                                    fontSize: a.width / 30),
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: a.width / 10,
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          width: a.width / 8,
                                          height: a.width / 8,
                                          decoration: BoxDecoration(boxShadow: [
                                            BoxShadow(
                                              color: Color(0xff6E6E6E)
                                                  .withOpacity(0.45),
                                              spreadRadius: 0,
                                              blurRadius: 7,
                                              offset: Offset(0,
                                                  3), // changes position of shadow
                                            ),
                                          ], color: Colors.white),
                                          child: Icon(
                                            Icons.traffic,
                                            size: a.width / 15,
                                          ),
                                        ),
                                        Container(
                                          width: a.width / 1.5,
                                          height: a.width / 3,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                                a.width / 40),
                                            color: Colors.white,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Color(0xff6E6E6E)
                                                    .withOpacity(0.45),
                                                spreadRadius: 0,
                                                blurRadius: 7,
                                                offset: Offset(0,
                                                    3), // changes position of shadow
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
                                                "Address : ${snapshot.data.documents[index]["2"]}",
                                                style: TextStyle(
                                                    fontSize: a.width / 30),
                                              ),
                                              Text(
                                                "Set time : ${snapshot.data.documents[index]['a2']}",
                                                style: TextStyle(
                                                    fontSize: a.width / 30),
                                              ),
                                              Text(
                                                "AI time(sec) : ${AIcalculate(snapshot.data.documents[index]['dataCar'][1], snapshot.data.documents[index]['dataCar'][0], snapshot.data.documents[index]['dataCar'][2], 120).toStringAsFixed(0)}",
                                                style: TextStyle(
                                                    fontSize: a.width / 30),
                                              ),
                                              Text(
                                                "Stability : ${Stability(snapshot.data.documents[index]['a2'], snapshot.data.documents[index]['dataCar'][1], snapshot.data.documents[index]['dataCar'][0], snapshot.data.documents[index]['dataCar'][2], 120).toStringAsFixed(2)} %",
                                                style: TextStyle(
                                                    fontSize: a.width / 30),
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: a.width / 10,
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          width: a.width / 8,
                                          height: a.width / 8,
                                          decoration: BoxDecoration(boxShadow: [
                                            BoxShadow(
                                              color: Color(0xff6E6E6E)
                                                  .withOpacity(0.45),
                                              spreadRadius: 0,
                                              blurRadius: 7,
                                              offset: Offset(0,
                                                  3), // changes position of shadow
                                            ),
                                          ], color: Colors.white),
                                          child: Icon(
                                            Icons.traffic,
                                            size: a.width / 15,
                                          ),
                                        ),
                                        Container(
                                          width: a.width / 1.5,
                                          height: a.width / 3,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                                a.width / 40),
                                            color: Colors.white,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Color(0xff6E6E6E)
                                                    .withOpacity(0.45),
                                                spreadRadius: 0,
                                                blurRadius: 7,
                                                offset: Offset(0,
                                                    3), // changes position of shadow
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
                                                "Address : ${snapshot.data.documents[index]["3"]}",
                                                style: TextStyle(
                                                    fontSize: a.width / 30),
                                              ),
                                              Text(
                                                "Set time : ${snapshot.data.documents[index]['a3']}",
                                                style: TextStyle(
                                                    fontSize: a.width / 30),
                                              ),
                                              Text(
                                                "AI time(sec) : ${AIcalculate(snapshot.data.documents[index]['dataCar'][2], snapshot.data.documents[index]['dataCar'][0], snapshot.data.documents[index]['dataCar'][1], 120).toStringAsFixed(0)}",
                                                style: TextStyle(
                                                    fontSize: a.width / 30),
                                              ),
                                              Text(
                                                "Stability : ${Stability(snapshot.data.documents[index]['a3'], snapshot.data.documents[index]['dataCar'][2], snapshot.data.documents[index]['dataCar'][0], snapshot.data.documents[index]['dataCar'][1], 120).toStringAsFixed(2)} %",
                                                style: TextStyle(
                                                    fontSize: a.width / 30),
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                )
                              : snapshot.data.documents[index]['type'] == "4" &&
                                      snapshot.data.documents[index]['cheak'] ==
                                          true
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${snapshot.data.documents[index].documentID}",
                                          style: TextStyle(
                                              fontSize: a.width / 30,
                                              color: Color(0xff898989),
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          height: a.width / 20,
                                        ),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              width: a.width / 8,
                                              height: a.width / 8,
                                              decoration:
                                                  BoxDecoration(boxShadow: [
                                                BoxShadow(
                                                  color: Color(0xff6E6E6E)
                                                      .withOpacity(0.45),
                                                  spreadRadius: 0,
                                                  blurRadius: 7,
                                                  offset: Offset(0,
                                                      3), // changes position of shadow
                                                ),
                                              ], color: Colors.white),
                                              child: Icon(
                                                Icons.traffic,
                                                size: a.width / 15,
                                              ),
                                            ),
                                            Container(
                                              width: a.width / 1.5,
                                              height: a.width / 3,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        a.width / 40),
                                                color: Colors.white,
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Color(0xff6E6E6E)
                                                        .withOpacity(0.45),
                                                    spreadRadius: 0,
                                                    blurRadius: 7,
                                                    offset: Offset(0,
                                                        3), // changes position of shadow
                                                  ),
                                                ],
                                              ),
                                              padding:
                                                  EdgeInsets.all(a.width / 20),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "Address : ${snapshot.data.documents[index]["1"]}",
                                                    style: TextStyle(
                                                        fontSize: a.width / 30),
                                                  ),
                                                  Text(
                                                    "Set time : ${snapshot.data.documents[index]['a1']}",
                                                    style: TextStyle(
                                                        fontSize: a.width / 30),
                                                  ),
                                                  Text(
                                                    "AI time(sec) : ${AIcalculate1(snapshot.data.documents[index]['dataCar'][0], snapshot.data.documents[index]['dataCar'][1], snapshot.data.documents[index]['dataCar'][2], snapshot.data.documents[index]['dataCar'][3], 120).toStringAsFixed(0)}",
                                                    style: TextStyle(
                                                        fontSize: a.width / 30),
                                                  ),
                                                  Text(
                                                    "Stability : ${Stability1(snapshot.data.documents[index]['a1'], snapshot.data.documents[index]['dataCar'][0], snapshot.data.documents[index]['dataCar'][1], snapshot.data.documents[index]['dataCar'][2], snapshot.data.documents[index]['dataCar'][3], 120).toStringAsFixed(2)} %",
                                                    style: TextStyle(
                                                        fontSize: a.width / 30),
                                                  )
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          height: a.width / 10,
                                        ),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              width: a.width / 8,
                                              height: a.width / 8,
                                              decoration:
                                                  BoxDecoration(boxShadow: [
                                                BoxShadow(
                                                  color: Color(0xff6E6E6E)
                                                      .withOpacity(0.45),
                                                  spreadRadius: 0,
                                                  blurRadius: 7,
                                                  offset: Offset(0,
                                                      3), // changes position of shadow
                                                ),
                                              ], color: Colors.white),
                                              child: Icon(
                                                Icons.traffic,
                                                size: a.width / 15,
                                              ),
                                            ),
                                            Container(
                                              width: a.width / 1.5,
                                              height: a.width / 3,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        a.width / 40),
                                                color: Colors.white,
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Color(0xff6E6E6E)
                                                        .withOpacity(0.45),
                                                    spreadRadius: 0,
                                                    blurRadius: 7,
                                                    offset: Offset(0,
                                                        3), // changes position of shadow
                                                  ),
                                                ],
                                              ),
                                              padding:
                                                  EdgeInsets.all(a.width / 20),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "Address : ${snapshot.data.documents[index]["2"]}",
                                                    style: TextStyle(
                                                        fontSize: a.width / 30),
                                                  ),
                                                  Text(
                                                    "Set time : ${snapshot.data.documents[index]['a2']}",
                                                    style: TextStyle(
                                                        fontSize: a.width / 30),
                                                  ),
                                                  Text(
                                                    "AI time(sec) : ${AIcalculate1(snapshot.data.documents[index]['dataCar'][1], snapshot.data.documents[index]['dataCar'][0], snapshot.data.documents[index]['dataCar'][2], snapshot.data.documents[index]['dataCar'][3], 120).toStringAsFixed(0)}",
                                                    style: TextStyle(
                                                        fontSize: a.width / 30),
                                                  ),
                                                  Text(
                                                    "Stability : ${Stability1(snapshot.data.documents[index]['a2'], snapshot.data.documents[index]['dataCar'][1], snapshot.data.documents[index]['dataCar'][0], snapshot.data.documents[index]['dataCar'][2], snapshot.data.documents[index]['dataCar'][3], 120).toStringAsFixed(2)} %",
                                                    style: TextStyle(
                                                        fontSize: a.width / 30),
                                                  )
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          height: a.width / 10,
                                        ),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              width: a.width / 8,
                                              height: a.width / 8,
                                              decoration:
                                                  BoxDecoration(boxShadow: [
                                                BoxShadow(
                                                  color: Color(0xff6E6E6E)
                                                      .withOpacity(0.45),
                                                  spreadRadius: 0,
                                                  blurRadius: 7,
                                                  offset: Offset(0,
                                                      3), // changes position of shadow
                                                ),
                                              ], color: Colors.white),
                                              child: Icon(
                                                Icons.traffic,
                                                size: a.width / 15,
                                              ),
                                            ),
                                            Container(
                                              width: a.width / 1.5,
                                              height: a.width / 3,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        a.width / 40),
                                                color: Colors.white,
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Color(0xff6E6E6E)
                                                        .withOpacity(0.45),
                                                    spreadRadius: 0,
                                                    blurRadius: 7,
                                                    offset: Offset(0,
                                                        3), // changes position of shadow
                                                  ),
                                                ],
                                              ),
                                              padding:
                                                  EdgeInsets.all(a.width / 20),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "Address : ${snapshot.data.documents[index]["3"]}",
                                                    style: TextStyle(
                                                        fontSize: a.width / 30),
                                                  ),
                                                  Text(
                                                    "Set time : ${snapshot.data.documents[index]['a3']}",
                                                    style: TextStyle(
                                                        fontSize: a.width / 30),
                                                  ),
                                                  Text(
                                                    "AI time(sec) : ${AIcalculate1(snapshot.data.documents[index]['dataCar'][2], snapshot.data.documents[index]['dataCar'][0], snapshot.data.documents[index]['dataCar'][1], snapshot.data.documents[index]['dataCar'][3], 120).toStringAsFixed(0)}",
                                                    style: TextStyle(
                                                        fontSize: a.width / 30),
                                                  ),
                                                  Text(
                                                    "Stability : ${Stability1(snapshot.data.documents[index]['a3'], snapshot.data.documents[index]['dataCar'][2], snapshot.data.documents[index]['dataCar'][0], snapshot.data.documents[index]['dataCar'][1], snapshot.data.documents[index]['dataCar'][3], 120).toStringAsFixed(2)} %",
                                                    style: TextStyle(
                                                        fontSize: a.width / 30),
                                                  )
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          height: a.width / 10,
                                        ),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              width: a.width / 8,
                                              height: a.width / 8,
                                              decoration:
                                                  BoxDecoration(boxShadow: [
                                                BoxShadow(
                                                  color: Color(0xff6E6E6E)
                                                      .withOpacity(0.45),
                                                  spreadRadius: 0,
                                                  blurRadius: 7,
                                                  offset: Offset(0,
                                                      3), // changes position of shadow
                                                ),
                                              ], color: Colors.white),
                                              child: Icon(
                                                Icons.traffic,
                                                size: a.width / 15,
                                              ),
                                            ),
                                            Container(
                                              width: a.width / 1.5,
                                              height: a.width / 3,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        a.width / 40),
                                                color: Colors.white,
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Color(0xff6E6E6E)
                                                        .withOpacity(0.45),
                                                    spreadRadius: 0,
                                                    blurRadius: 7,
                                                    offset: Offset(0,
                                                        3), // changes position of shadow
                                                  ),
                                                ],
                                              ),
                                              padding:
                                                  EdgeInsets.all(a.width / 20),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "Address : ${snapshot.data.documents[index]["4"]}",
                                                    style: TextStyle(
                                                        fontSize: a.width / 30),
                                                  ),
                                                  Text(
                                                    "Set time : ${snapshot.data.documents[index]['a4']}",
                                                    style: TextStyle(
                                                        fontSize: a.width / 30),
                                                  ),
                                                  Text(
                                                    "AI time(sec) : ${AIcalculate1(snapshot.data.documents[index]['dataCar'][3], snapshot.data.documents[index]['dataCar'][0], snapshot.data.documents[index]['dataCar'][1], snapshot.data.documents[index]['dataCar'][2], 120).toStringAsFixed(0)}",
                                                    style: TextStyle(
                                                        fontSize: a.width / 30),
                                                  ),
                                                  Text(
                                                    "Stability : ${Stability1(snapshot.data.documents[index]['a4'], snapshot.data.documents[index]['dataCar'][3], snapshot.data.documents[index]['dataCar'][0], snapshot.data.documents[index]['dataCar'][1], snapshot.data.documents[index]['dataCar'][2], 120).toStringAsFixed(2)} %",
                                                    style: TextStyle(
                                                        fontSize: a.width / 30),
                                                  )
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                    )
                                  : Container(),
                          SizedBox(height: a.width / 10)
                        ],
                      );
                    },
                    itemCount: snapshot.data.documents.length,
                  );
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
