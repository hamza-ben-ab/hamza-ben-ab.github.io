import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hovering/hovering.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:uy/generated/l10n.dart';
import 'package:uy/screens/constant.dart';
import 'package:uy/services/place_service/model/place.dart';
import 'package:uy/services/provider/current_position_provider.dart';
import 'package:uy/services/provider/settings_provider.dart';
import 'package:uy/widget/toast.dart';

class EditLocation extends StatefulWidget {
  final bool current;
  const EditLocation({Key key, this.current}) : super(key: key);

  @override
  _EditCurrentLocationState createState() => _EditCurrentLocationState();
}

class _EditCurrentLocationState extends State<EditLocation> {
  TextEditingController currentLocationController = TextEditingController();
  Completer<GoogleMapController> mapController = Completer();
  bool add = false;
  bool tape = false;
  StreamSubscription locationSubscription;
  String resultAddress;
  User currentUser = FirebaseAuth.instance.currentUser;
  TeltrueWidget toast = TeltrueWidget();
  CollectionReference users = FirebaseFirestore.instance.collection('Users');
  FToast fToast;

  Widget goBackWidget(bool hover) {
    double h = MediaQuery.of(context).size.height;
    return Container(
      height: h * .05,
      width: h * .05,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        color: hover ? Colors.orange[400] : Colors.orange[300],
      ),
      child: Center(
        child: Icon(
          LineAwesomeIcons.angle_left,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget goToPreviousPage(int index, String title) {
    double h = MediaQuery.of(context).size.height;
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Container(
        height: h * .06,
        margin: EdgeInsets.symmetric(vertical: 10.0),
        child: Row(
          children: [
            InkWell(
              onTap: () {
                Provider.of<SettingProvider>(context, listen: false)
                    .goToPage(index);
                setState(() {
                  tape = false;
                  add = false;
                });
              },
              child: HoverWidget(
                child: goBackWidget(false),
                hoverChild: goBackWidget(true),
                onHover: (onHover) {},
              ),
            ),
            SizedBox(
              width: 15.0,
            ),
            Text(
              title,
              style: TextStyle(
                color: Colors.black,
                // fontWeight: FontWeight.w500,
                fontSize: 14.0,
                fontFamily: "SPProtext",
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget searchItem(bool hover, String des) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Container(
      width: w,
      height: h * .07,
      color: hover ? Colors.grey[50] : Colors.transparent,
      child: Center(
        child: Text(
          des,
          style: TextStyle(
              color: hover ? Colors.black : Colors.white,
              fontFamily: "SPProtext",
              fontSize: 16.0,
              fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  Widget mapsView() {
    final applicationBloc = Provider.of<GoogleMapsBlocsProvider>(context);
    return GoogleMap(
      mapType: MapType.normal,
      myLocationEnabled: true,
      /* onTap: (val) {
        
        
      },*/
      initialCameraPosition: CameraPosition(
        target: LatLng(applicationBloc.currentLocation.latitude,
            applicationBloc.currentLocation.longitude),
        zoom: 8,
      ),
      onMapCreated: (GoogleMapController controller) {
        mapController.complete(controller);
      },
    );
  }

  Widget addbuttonWidget(bool hover) {
    double h = MediaQuery.of(context).size.height;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        color: hover ? Colors.grey[300] : Colors.grey[200],
      ),
      height: h * .05,
      width: h * .05,
      child: Center(
        child: Icon(LineAwesomeIcons.plus, color: Colors.black),
      ),
    );
  }

  Future<void> goToPlace(Place place) async {
    final GoogleMapController controller = await mapController.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target:
              LatLng(place.geometry.location.lat, place.geometry.location.lng),
          zoom: 14.0,
        ),
      ),
    );
  }

  @override
  void initState() {
    final applicationBloc =
        Provider.of<GoogleMapsBlocsProvider>(context, listen: false);
    applicationBloc.selectedLocation = StreamController<Place>.broadcast();

    //Listen for selected Location
    locationSubscription = applicationBloc.selectedLocation.stream
        .asBroadcastStream()
        .listen((place) {
      if (place != null) {
        currentLocationController.text = place.name;
        goToPlace(place);
        print(applicationBloc.searchResults);
      } else
        currentLocationController.text = "";
    });
    fToast = FToast();
    fToast.init(context);
    super.initState();
  }

  @override
  void dispose() {
    final applicationBloc =
        Provider.of<GoogleMapsBlocsProvider>(context, listen: false);
    applicationBloc.dispose();
    currentLocationController.dispose();
    locationSubscription.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    final applicationBloc = Provider.of<GoogleMapsBlocsProvider>(context);
    return Column(
      children: [
        goToPreviousPage(
          4,
          S.of(context).createProfilecurrentCityHintText,
        ),
        SizedBox(
          height: h * .01,
        ),
        Container(
          child: Row(
            children: [
              Container(
                width: w * .2,
                height: h * .05,
                child: TextFormField(
                  onChanged: (value) => applicationBloc.searchPlaces(value),
                  controller: currentLocationController,
                  autofocus: true,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 17.0,
                    fontFamily: "SPProtext",
                  ),
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: accentColor, width: 0.5),
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: accentColor, width: 0.5),
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: accentColor, width: 0.5),
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: accentColor, width: 0.5),
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                    hintText: widget.current
                        ? S.of(context).createProfilecurrentCityHintText
                        : S.of(context).createProfileHomeTwonHintText,
                    hintStyle: TextStyle(
                      color: Colors.black,
                      letterSpacing: 1.2,
                      fontSize: 12.0,
                      fontFamily: "SPProtext",
                    ),
                  ),
                ),
              ),
              InkWell(
                child: HoverWidget(
                    child: addbuttonWidget(false),
                    hoverChild: addbuttonWidget(true),
                    onHover: (onHover) {}),
                onTap: () async {
                  widget.current
                      ? users.doc(currentUser.uid).set({
                          "currentLocation":
                              currentLocationController.text.trim()
                        }, SetOptions(merge: true))
                      : users.doc(currentUser.uid).set({
                          "homeTownLocation":
                              currentLocationController.text.trim()
                        }, SetOptions(merge: true));
                  toast.showToast("Saved", fToast, Colors.green[400]);
                  currentLocationController.clear();
                  applicationBloc.selectedLocation.close();
                },
              ),
            ],
          ),
        ),
        SizedBox(
          height: h * .005,
        ),
        Expanded(
          child: Container(
            width: w * .24,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Stack(children: [
              mapsView(),
              applicationBloc.searchResults != null &&
                      applicationBloc.searchResults.length != 0
                  ? Container(
                      height: h * .5,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(.6),
                        backgroundBlendMode: BlendMode.darken,
                      ),
                      child: ListView.builder(
                          itemCount: applicationBloc.searchResults.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              child: HoverWidget(
                                  child: searchItem(
                                      false,
                                      applicationBloc
                                          .searchResults[index].description),
                                  hoverChild: searchItem(
                                      true,
                                      applicationBloc
                                          .searchResults[index].description),
                                  onHover: (onHover) {}),
                              onTap: () {
                                setState(() {
                                  currentLocationController.text =
                                      applicationBloc
                                          .searchResults[index].description;
                                });
                                applicationBloc.setSelectedLocation(
                                  applicationBloc.searchResults[index].placeId,
                                );
                              },
                            );
                          }),
                    )
                  : Container(
                      height: 0.0,
                      width: 0.0,
                    )
            ]),
          ),
        ),
      ],
    );
  }
}
