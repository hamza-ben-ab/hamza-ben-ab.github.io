import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hovering/hovering.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:uy/generated/l10n.dart';
import 'package:uy/screens/constant.dart';
import 'package:uy/services/place_service/main_maps.dart';
import 'package:uy/services/place_service/model/place.dart';
import 'package:uy/services/provider/current_position_provider.dart';
import 'package:uy/services/provider/tag_post_provider.dart';
//import 'package:intl/intl.dart' as intl;

class TagPlace extends StatefulWidget {
  static String place;
  const TagPlace({Key key}) : super(key: key);

  @override
  _TagPlaceState createState() => _TagPlaceState();
}

class _TagPlaceState extends State<TagPlace> {
  //Variables
  TextEditingController tagPlaceController = TextEditingController();
  Completer<GoogleMapController> mapController = Completer();
  StreamSubscription locationSubscription;

  //Functions
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
        tagPlaceController.text = place.name;
        goToPlace(place);
      } else
        tagPlaceController.text = "";
    });

    super.initState();
  }

  @override
  void dispose() {
    final applicationBloc =
        Provider.of<GoogleMapsBlocsProvider>(context, listen: false);
    applicationBloc.dispose();
    tagPlaceController.dispose();
    locationSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    final applicationBloc = Provider.of<GoogleMapsBlocsProvider>(context);

    return Container(
      width: w,
      height: h,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: h * .05),
          Container(
            height: h * .05,
            width: w * .6,
            //padding: EdgeInsets.symmetric(horizontal: w * .1),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    height: h * .05,
                    width: w * .08,
                    margin: EdgeInsets.symmetric(horizontal: 10.0),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Center(
                      child: Text(
                        S.of(context).cancelButton,
                        style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontFamily: "SPProtext"),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 30.0,
                ),
                Container(
                  height: h * .05,
                  width: w * .4,
                  child: TextFormField(
                    onChanged: (value) => applicationBloc.searchPlaces(value),
                    controller: tagPlaceController,
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
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 10.0),
                      hintText: S.of(context).addPostSearchPlaceHint,
                      hintStyle: TextStyle(
                        color: Colors.black,
                        letterSpacing: 1.2,
                        fontSize: 12.0,
                        fontFamily: "SPProtext",
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10.0,
                ),
                InkWell(
                  child: HoverWidget(
                      child: addbuttonWidget(false),
                      hoverChild: addbuttonWidget(true),
                      onHover: (onHover) {}),
                  onTap: () async {
                    Provider.of<TagPostProvider>(context, listen: false)
                        .changeTagPlace(tagPlaceController.text.trim());
                    Navigator.of(context).pop();
                    tagPlaceController.clear();

                    applicationBloc.selectedLocation.close();
                  },
                ),
              ],
            ),
          ),
          SizedBox(
            height: h * .02,
          ),
          Expanded(
            child: MainGoogleMaps(
              tagPlaceController: tagPlaceController,
              width: 1.0,
              heigth: .5,
            ),
          ),
        ],
      ),
    );
  }
}
