import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hovering/hovering.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:uy/services/place_service/model/place.dart';
import 'package:uy/services/provider/current_position_provider.dart';

class MainGoogleMaps extends StatefulWidget {
  final double width;
  final double heigth;
  final TextEditingController tagPlaceController;
  const MainGoogleMaps(
      {Key key, this.width, this.heigth, this.tagPlaceController})
      : super(key: key);

  @override
  _MainGoogleMapsState createState() => _MainGoogleMapsState();
}

class _MainGoogleMapsState extends State<MainGoogleMaps> {
  //Variables
  //TextEditingController tagPlaceController = TextEditingController();
  Completer<GoogleMapController> mapController = Completer();
  StreamSubscription locationSubscription;
  StreamSubscription boundsSubscription;
  Marker origin;
  String resultAddress;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  //Functions

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

  getUserLocation() async {
    markers.values.forEach((value) async {
      print(value.position);
      // From coordinates
      final coordinates =
          new Coordinates(value.position.latitude, value.position.longitude);
      var addresses =
          await Geocoder.google("AIzaSyCoxhDIK_DQ2-vVg7YMJYnpNGNEz1ecBU0")
              .findAddressesFromCoordinates(coordinates);

      print("Address: ${addresses.first.featureName}");
    });
  }

  Widget mapsView() {
    final applicationBloc = Provider.of<GoogleMapsBlocsProvider>(context);
    return GoogleMap(
      mapType: MapType.normal,
      myLocationEnabled: true,
      initialCameraPosition: CameraPosition(
        target: LatLng(applicationBloc.currentLocation.latitude,
            applicationBloc.currentLocation.longitude),
        zoom: 10,
      ),
      onMapCreated: (GoogleMapController controller) {
        mapController.complete(controller);
      },
      //markers: Set<Marker>.of(markers.values),
      /*onTap: (LatLng latLng) {
        // creating a new MARKER
        final MarkerId markerId = MarkerId('4544');
        final Marker marker = Marker(
          markerId: markerId,
          position: latLng,
        );
        print(latLng);
        //getUserLocation();

        setState(() {
          markers.clear();
          // adding a new marker to map
          markers[markerId] = marker;
        });
      },*/
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
        widget.tagPlaceController.text = place.name;
        goToPlace(place);
      } else
        widget.tagPlaceController.text = "";
    });

    super.initState();
  }

  @override
  void dispose() {
    final applicationBloc =
        Provider.of<GoogleMapsBlocsProvider>(context, listen: false);
    applicationBloc.dispose();
    widget.tagPlaceController.dispose();
    locationSubscription.cancel();
    boundsSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    final applicationBloc = Provider.of<GoogleMapsBlocsProvider>(context);
    return Container(
      width: w * widget.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Stack(children: [
        mapsView(),
        applicationBloc.searchResults != null &&
                applicationBloc.searchResults.length != 0
            ? Container(
                height: h * widget.heigth,
                width: w * widget.width,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(.7),
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
                            widget.tagPlaceController.text = applicationBloc
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
    );
  }
}
