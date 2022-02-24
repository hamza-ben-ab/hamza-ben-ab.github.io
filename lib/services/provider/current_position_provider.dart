import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uy/services/place_service/model/geometry.dart';
import 'package:uy/services/place_service/model/location.dart';
import 'package:uy/services/place_service/model/place.dart';
import 'package:uy/services/place_service/model/place_search.dart';
import 'package:uy/services/place_service/services/markers_service.dart';
import 'package:uy/services/place_service/services/place_service.dart';
import 'package:uy/services/provider/geolocator_service.dart';

class GoogleMapsBlocsProvider with ChangeNotifier {
  final geoLocatorService = GeolocatorService();
  final placesService = PlacesService();
  final markerService = MarkerService();

//Variables
  Position currentLocation;
  List<PlaceSearch> searchResults;
  // ignore: close_sinks
  StreamController<Place> selectedLocation = StreamController<Place>();
  Place selectedLocationStatic;
  String placeType;
  var placeResult;
  List<Marker> markers = [];

  GoogleMapsBlocsProvider() {
    setCurrentLocation();
  }

  setCurrentLocation() async {
    currentLocation = await geoLocatorService.getCurrentLocation();
    selectedLocationStatic = Place(
      name: null,
      geometry: Geometry(
        location: Location(
            lat: currentLocation.latitude, lng: currentLocation.longitude),
      ),
    );
    notifyListeners();
  }

  searchPlaces(String searchTerm) async {
    searchResults = await placesService.getAutocomplete(searchTerm);

    notifyListeners();
  }

  setSelectedLocation(String placeId) async {
    var sLocation = await placesService.getPlace(placeId);
    selectedLocation.add(sLocation);
    selectedLocationStatic = sLocation;
    searchResults = null;
    notifyListeners();
  }

  clearSelectedLocation() {
    selectedLocation.add(null);
    selectedLocationStatic = null;
    searchResults = null;
    placeType = null;
    notifyListeners();
  }

  @override
  void dispose() {
    selectedLocation.close();
    //bounds.close();
    super.dispose();
  }
}
