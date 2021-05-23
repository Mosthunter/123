import 'dart:typed_data';

import 'dart:ui' as ui;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'widget/Taoast.dart';

class Addtraffic extends StatefulWidget {
  @override
  _AddtrafficState createState() => _AddtrafficState();
}

class _AddtrafficState extends State<Addtraffic> {
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

  TextEditingController _zipcode = TextEditingController();
  TextEditingController _type = TextEditingController();
  TextEditingController _order = TextEditingController();
  TextEditingController _number = TextEditingController();
  TextEditingController _life = TextEditingController();

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

  @override
  Widget build(BuildContext context) {
    Size a = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: a.width,
            height: a.height,
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
            child: GoogleMap(
              zoomGesturesEnabled: true,
              markers: Set<Marker>.of(markers.values),
              initialCameraPosition:
                  CameraPosition(target: pinPosition, zoom: 15),
              mapType: MapType.terrain,
              trafficEnabled: true,
              onMapCreated: (GoogleMapController controller) {
                // _controller.complete(controller);
              },
              onTap: _handleTap,
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              margin: EdgeInsets.only(top: a.width / 10, left: a.width / 20),
              child: Icon(
                Icons.keyboard_backspace,
                size: a.width / 15,
              ),
            ),
          ),
          Positioned(
              bottom: 0,
              child: Container(
                width: a.width,
                height: a.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(a.width / 20),
                    topRight: Radius.circular(a.width / 20),
                  ),
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
                    top: a.width / 15,
                    bottom: a.width / 15,
                    right: a.width / 10,
                    left: a.width / 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Details",
                      style: TextStyle(
                          fontSize: a.width / 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: a.width / 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Location",
                          style: TextStyle(
                              color: Color(0xff898989), fontSize: a.width / 30),
                        ),
                        SizedBox(height: a.width / 50),
                        Container(
                            width: a.width,
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
                            alignment: Alignment.center,
                            child: Text(
                              Location == null
                                  ? ""
                                  : "${Location.longitude.toStringAsFixed(6)} N ${Location.latitude.toStringAsFixed(6)} S",
                              style: TextStyle(fontSize: a.width / 25),
                            )),
                      ],
                    ),
                    SizedBox(height: a.width / 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Zip Code",
                              style: TextStyle(
                                  color: Color(0xff898989),
                                  fontSize: a.width / 30),
                            ),
                            SizedBox(height: a.width / 50),
                            Container(
                              width: a.width / 3,
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
                              alignment: Alignment.center,
                              child: TextField(
                                textAlign: TextAlign.center,
                                controller: _zipcode,
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
                                ),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Order",
                              style: TextStyle(
                                  color: Color(0xff898989),
                                  fontSize: a.width / 30),
                            ),
                            SizedBox(height: a.width / 50),
                            Container(
                              width: a.width / 3,
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
                              alignment: Alignment.center,
                              child: TextField(
                                textAlign: TextAlign.center,
                                controller: _order,
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
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: a.width / 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Type",
                              style: TextStyle(
                                  color: Color(0xff898989),
                                  fontSize: a.width / 30),
                            ),
                            SizedBox(height: a.width / 50),
                            Container(
                              width: a.width / 5,
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
                              alignment: Alignment.center,
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
                                ),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Number",
                              style: TextStyle(
                                  color: Color(0xff898989),
                                  fontSize: a.width / 30),
                            ),
                            SizedBox(height: a.width / 50),
                            Container(
                              width: a.width / 5,
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
                              alignment: Alignment.center,
                              child: TextField(
                                textAlign: TextAlign.center,
                                controller: _number,
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
                                ),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Life",
                              style: TextStyle(
                                  color: Color(0xff898989),
                                  fontSize: a.width / 30),
                            ),
                            SizedBox(height: a.width / 50),
                            Container(
                              width: a.width / 5,
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
                              alignment: Alignment.center,
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
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: a.width / 15,
                    ),
                    Container(
                      width: a.width,
                      padding: EdgeInsets.only(
                          left: a.width / 10, right: a.width / 10),
                      child: InkWell(
                        onTap: () {
                          if (_zipcode.text == "" ||
                              _type.text == "" ||
                              _order.text == "" ||
                              _number.text == "" ||
                              _life.text == "") {
                            Taoast().toast("ใส่ข้อมูลไม่ครบ");
                          } else {
                            Firestore.instance.collection("data").add({
                              'address': [
                                _zipcode.text,
                                _type.text,
                                _order.text,
                                _number.text
                              ],
                              'location': GeoPoint(
                                  Location.latitude, Location.longitude),
                              'status': 0,
                              'type': 1,
                              'old': int.parse(_life.text),
                              'color': 'red',
                            });
                            if (_number.text == '1') {
                              Firestore.instance
                                  .collection("group")
                                  .document(
                                      '${_zipcode.text}${_type.text}${_order.text}')
                                  .setData({
                                'type': _type.text,
                                'num': 0,
                                '${_number.text}':
                                    "${_zipcode.text} ${_type.text} ${_order.text} ${_number.text}",
                                'a${_number.text}': 40,
                                'dataCar': _type.text.toString() == "3"
                                    ? [1520, 652, 1200]
                                    : [1520, 652, 1200, 720]
                              });
                            } else {
                              Firestore.instance
                                  .collection("group")
                                  .document(
                                      '${_zipcode.text}${_type.text}${_order.text}')
                                  .updateData({
                                '${_number.text}':
                                    "${_zipcode.text} ${_type.text} ${_order.text} ${_number.text}",
                                'a${_number.text}': 40,
                                'cheak':
                                    _type.text == _number.text ? true : false
                              });
                            }
                            setState(() {
                              Location = null;
                            });
                            getMarkerData();
                            _zipcode.clear();
                            _life.clear();
                            _number.clear();
                            _order.clear();
                            _type.clear();
                          }
                        },
                        child: Container(
                          height: a.width / 8,
                          decoration: BoxDecoration(
                              color: Color(0xffFBB311),
                              borderRadius:
                                  BorderRadius.circular(a.width / 40)),
                          alignment: Alignment.center,
                          child: Text(
                            "Add Traffic!",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: a.width / 25,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ))
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
