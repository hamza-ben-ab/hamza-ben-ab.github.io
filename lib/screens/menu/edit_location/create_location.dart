import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hovering/hovering.dart';
import 'package:provider/provider.dart';
import 'package:uy/generated/l10n.dart';
import 'package:uy/screens/constant.dart';
import 'package:uy/screens/create_post_file/create_post_fn.dart';
import 'package:uy/services/place_service/model/place.dart';
import 'package:uy/services/provider/create_location_provider.dart';
import 'package:uy/services/provider/current_position_provider.dart';
import 'package:uy/services/responsiveLayout.dart';
import 'package:uy/widget/toast.dart';

class CreateLocation extends StatefulWidget {
  final bool current;
  const CreateLocation({Key key, this.current}) : super(key: key);

  @override
  _CreateLocationState createState() => _CreateLocationState();
}

class _CreateLocationState extends State<CreateLocation> {
  final TextEditingController currentlocationController =
      TextEditingController();
  final TextEditingController homelocationController = TextEditingController();
  StreamSubscription locationSubscription;
  String resultAddress;
  Completer<GoogleMapController> mapController = Completer();
  TeltrueWidget toast = TeltrueWidget();
  FToast fToast;
  CreatePostAllFunctions createPostAllFunctions = CreatePostAllFunctions();

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
        currentlocationController.text = place.name;
        goToPlace(place);
        print(applicationBloc.searchResults);
      } else
        currentlocationController.text = "";
    });
    fToast = FToast();
    fToast.init(context);
    super.initState();
  }

  @override
  void dispose() {
    //final applicationBloc = Provider.of<GoogleMapsBlocsProvider>(context, listen: false);
    //applicationBloc.dispose();
    currentlocationController.dispose();
    locationSubscription.cancel();
    super.dispose();
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
              fontSize: 14.0,
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

  cancelFunction() {
    Navigator.of(context, rootNavigator: true).pop();
  }

  Widget cancelButton() {
    double h = MediaQuery.of(context).size.height;
    return HoverWidget(
        child:
            createPostAllFunctions.cancelButtonWidget(false, h, cancelFunction),
        hoverChild:
            createPostAllFunctions.cancelButtonWidget(true, h, cancelFunction),
        onHover: (onHover) {});
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

  @override
  Widget build(BuildContext context) {
    final applicationBloc = Provider.of<GoogleMapsBlocsProvider>(context);
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    bool largeScreen = ResponsiveLayout.isLargeScreen(context);
    return Container(
      width: w * .5,
      height: h * .7,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(15.0)),
      child: Column(
        children: [
          Directionality(
            textDirection: TextDirection.ltr,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              height: h * .1,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  cancelButton(),
                  Container(
                    height: h * .05,
                    width: w * .3,
                    child: Center(
                      child: Text(
                        widget.current
                            ? S.of(context).createProfilecurrentCityHintText
                            : S.of(context).createProfileHomeTwonHintText,
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontFamily: "SPProtext",
                            fontSize: 17.0),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        height: h * .05,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            createPostAllFunctions.doneButton(
                              h,
                              w,
                              S.of(context).doneButton,
                              () async {
                                widget.current
                                    ? Provider.of<CreateLocationProvider>(
                                            context,
                                            listen: false)
                                        .changeCurrentLocation(
                                            currentlocationController.text
                                                .trim())
                                    : Provider.of<CreateLocationProvider>(
                                            context,
                                            listen: false)
                                        .changeHomeTownLocation(
                                            currentlocationController.text
                                                .trim());
                                Navigator.of(context, rootNavigator: true)
                                    .pop();
                              },
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          SizedBox(height: h * .01),
          Container(
            height: h * .05,
            width: largeScreen ? w * .4 : w * .5,
            child: TextFormField(
              onChanged: (value) => applicationBloc.searchPlaces(value),
              controller: currentlocationController,
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
          SizedBox(height: h * .01),
          Expanded(
            child: Stack(
              children: [
                mapsView(),
                applicationBloc.searchResults != null &&
                        applicationBloc.searchResults.length != 0
                    ? Container(
                        height: h * .3,
                        width: w * .5,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(.6),
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
                                    currentlocationController.text =
                                        applicationBloc
                                            .searchResults[index].description;
                                    applicationBloc.setSelectedLocation(
                                      applicationBloc
                                          .searchResults[index].placeId,
                                    );
                                    applicationBloc.searchResults = null;
                                  });
                                },
                              );
                            }),
                      )
                    : Container(
                        height: 0.0,
                        width: 0.0,
                      )
              ],
            ),
          ),
          SizedBox(
            height: h * .015,
          )
        ],
      ),
    );
  }
}
