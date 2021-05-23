import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:traf/widget/Taoast.dart';

class AddMarker extends StatefulWidget {
  @override
  _AddMarkerState createState() => _AddMarkerState();
}

class _AddMarkerState extends State<AddMarker> {
  var Location;
  var pinPosition = LatLng(7.009460298757617, 100.47474021941028);
  GoogleMapController myController;

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))
        .buffer
        .asUint8List();
  }

  Future<void> initMarker(specify, specifyId) async {
    var markerIdval = specifyId;
    final Uint8List markerIconRed =
        await getBytesFromAsset('assets/red-light.png', 80);
    final Uint8List markerIconYellow =
        await getBytesFromAsset('assets/yellow-light.png', 60);
    final Uint8List markerIconGreen =
        await getBytesFromAsset('assets/green-light.png', 60);
    final MarkerId markerId = MarkerId(markerIdval);
    final Marker marker = Marker(
        markerId: markerId,
        icon: BitmapDescriptor.fromBytes(specify['color'] == "red"
            ? markerIconRed
            : specify['color'] == "yellow"
                ? markerIconYellow
                : markerIconGreen),
        position:
            LatLng(specify['location'].latitude, specify['location'].longitude),
        infoWindow: InfoWindow(
            title: "สัญญาณไฟ",
            snippet:
                "${specify['address'][0]} ${specify['address'][1]} ${specify['address'][2]} ${specify['address'][3]}"));
    setState(() {
      markers[markerId] = marker;
    });
  }

  getMarkerData() async {
    Firestore.instance.collection("data").getDocuments().then((myMockData) {
      if (myMockData.documents.isNotEmpty) {
        for (int i = 0; i < myMockData.documents.length; i++) {
          initMarker(
              myMockData.documents[i].data, myMockData.documents[i].documentID);
        }
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getMarkerData();
  }

  TextEditingController _location = TextEditingController();
  TextEditingController _type = TextEditingController();
  TextEditingController _ordertype = TextEditingController();
  TextEditingController _orderligh = TextEditingController();
  TextEditingController _life = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size a = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        actions: [
          Container(
            width: a.width,
            height: a.width,
            color: Colors.blue,
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(
              left: a.width / 20,
              right: a.width / 20,
            ),
            child: Stack(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.arrow_back,
                    size: a.width / 18,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                width: a.width,
                // height: a.width / 2.2,
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey[300].withOpacity(0.4),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(a.width / 25)),
                margin: EdgeInsets.all(a.width / 50),
                padding: EdgeInsets.all(a.width / 30),
                child: Wrap(
                  alignment: WrapAlignment.center,
                  direction: Axis.horizontal,
                  spacing: 10.0,
                  runSpacing: 10.0,
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Text(
                          'Location',
                          style: TextStyle(
                              color: Color(0xff707070), fontSize: a.width / 30),
                        ),
                        SizedBox(
                          height: a.width / 40,
                        ),
                        Container(
                          width: a.width / 4,
                          height: a.width / 10,
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey[300].withOpacity(0.4),
                                  spreadRadius: 5,
                                  blurRadius: 7,
                                  offset: Offset(
                                      0, 3), // changes position of shadow
                                ),
                              ],
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(a.width)),
                          child: TextField(
                            textAlign: TextAlign.center,
                            controller: _location,
                            obscureText: false,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                contentPadding: EdgeInsets.only(
                                    left: a.width / 30, right: a.width / 30),
                                hintText: "Location"),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          'Type ',
                          style: TextStyle(
                              color: Color(0xff707070), fontSize: a.width / 30),
                        ),
                        SizedBox(
                          height: a.width / 40,
                        ),
                        Container(
                          width: a.width / 6,
                          height: a.width / 10,
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey[300].withOpacity(0.4),
                                  spreadRadius: 5,
                                  blurRadius: 7,
                                  offset: Offset(
                                      0, 3), // changes position of shadow
                                ),
                              ],
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(a.width)),
                          child: TextField(
                            textAlign: TextAlign.center,
                            controller: _type,
                            obscureText: false,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                contentPadding: EdgeInsets.only(
                                    left: a.width / 30, right: a.width / 30),
                                hintText: "Type"),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          'OrderType',
                          style: TextStyle(
                              color: Color(0xff707070), fontSize: a.width / 30),
                        ),
                        SizedBox(
                          height: a.width / 40,
                        ),
                        Container(
                          width: a.width / 4,
                          height: a.width / 10,
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey[300].withOpacity(0.4),
                                  spreadRadius: 5,
                                  blurRadius: 7,
                                  offset: Offset(
                                      0, 3), // changes position of shadow
                                ),
                              ],
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(a.width)),
                          child: TextField(
                            textAlign: TextAlign.center,
                            controller: _ordertype,
                            obscureText: false,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                contentPadding: EdgeInsets.only(
                                    left: a.width / 30, right: a.width / 30),
                                hintText: "OrderType"),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          'Order ',
                          style: TextStyle(
                              color: Color(0xff707070), fontSize: a.width / 30),
                        ),
                        SizedBox(
                          height: a.width / 40,
                        ),
                        Container(
                          width: a.width / 6,
                          height: a.width / 10,
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey[300].withOpacity(0.4),
                                  spreadRadius: 5,
                                  blurRadius: 7,
                                  offset: Offset(
                                      0, 3), // changes position of shadow
                                ),
                              ],
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(a.width)),
                          child: TextField(
                            textAlign: TextAlign.center,
                            controller: _orderligh,
                            obscureText: false,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                contentPadding: EdgeInsets.only(
                                    left: a.width / 30, right: a.width / 30),
                                hintText: "Order"),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          'Service life',
                          style: TextStyle(
                              color: Color(0xff707070), fontSize: a.width / 30),
                        ),
                        SizedBox(
                          height: a.width / 40,
                        ),
                        Container(
                          width: a.width / 4,
                          height: a.width / 10,
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey[300].withOpacity(0.4),
                                  spreadRadius: 5,
                                  blurRadius: 7,
                                  offset: Offset(
                                      0, 3), // changes position of shadow
                                ),
                              ],
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(a.width)),
                          child: TextField(
                            textAlign: TextAlign.center,
                            controller: _life,
                            obscureText: false,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                contentPadding: EdgeInsets.only(
                                    left: a.width / 30, right: a.width / 30),
                                hintText: "Service life"),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: a.width / 50)
                  ],
                ),
              ),
              Container(
                width: a.width,
                height: a.width,
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey[300].withOpacity(0.4),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(a.width / 25)),
                margin: EdgeInsets.all(a.width / 50),
                child: GoogleMap(
                  zoomGesturesEnabled: true,
                  markers: Set<Marker>.of(markers.values),
                  initialCameraPosition:
                      CameraPosition(target: pinPosition, zoom: 15),
                  mapType: MapType.hybrid,
                  trafficEnabled: true,
                  onMapCreated: (GoogleMapController controller) {
                    // _controller.complete(controller);
                  },
                  onTap: _handleTap,
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: InkWell(
              onTap: () {
                if (_location.text == "" ||
                    _type.text == "" ||
                    _ordertype.text == "" ||
                    _orderligh.text == "" ||
                    _life.text == "") {
                  Taoast().toast("ใส่ข้อมูลไม่ครบ");
                } else {
                  Firestore.instance.collection("data").add({
                    'address': [
                      _location.text,
                      _type.text,
                      _ordertype.text,
                      _orderligh.text
                    ],
                    'location': GeoPoint(Location.latitude, Location.longitude),
                    'status': 0,
                    'type': 1,
                    'old': int.parse(_life.text),
                    'color': 'red'
                  });
                  if (_orderligh.text == '1') {
                    Firestore.instance
                        .collection("group")
                        .document(
                            '${_location.text}${_type.text}${_ordertype.text}')
                        .setData({
                      'type': _type.text,
                      'num': 0,
                      '${_orderligh.text}':
                          "${_location.text} ${_type.text} ${_ordertype.text} ${_orderligh.text}"
                    });
                  } else {
                    Firestore.instance
                        .collection("group")
                        .document(
                            '${_location.text}${_type.text}${_ordertype.text}')
                        .updateData({
                      '${_orderligh.text}':
                          "${_location.text} ${_type.text} ${_ordertype.text} ${_orderligh.text}"
                    });
                  }
                  getMarkerData();
                  _location.clear();
                  _life.clear();
                  _orderligh.clear();
                  _ordertype.clear();
                  _type.clear();
                }
              },
              child: Container(
                width: a.width / 4,
                height: a.width / 12,
                margin: EdgeInsets.all(a.width / 50),
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.4),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                    borderRadius: BorderRadius.circular(a.width),
                    color: Colors.blue),
                alignment: Alignment.center,
                child: Text(
                  "Add",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  _handleTap(LatLng tappedPoint) async {
    final Uint8List markerIconRed =
        await getBytesFromAsset('assets/red-light.png', 80);
    setState(() {
      markers = <MarkerId, Marker>{};
      markers[MarkerId(tappedPoint.toString())] = Marker(
        markerId: MarkerId(tappedPoint.toString()),
        icon: BitmapDescriptor.fromBytes(markerIconRed),
        position: tappedPoint,
      );
      getMarkerData();
      print(tappedPoint);
      Location = tappedPoint;
    });
  }
}
