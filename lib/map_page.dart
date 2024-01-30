import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';

class MapPage extends StatefulWidget {
  final Function handleMapClick;
  const MapPage({Key? key, required this.handleMapClick}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  Location _locationController = Location();
  List<LatLng> _locations = [];
  BitmapDescriptor? markerIcon;
  late String apiUrl;
  late StreamSubscription<LocationData> _locationSubscription;
  bool isFullScreen = false;

  @override
  void initState() {
    super.initState();
    apiUrl = 'http://13.127.214.1:3000/api/v1/vid_12347/vehicledata';
    fetchData(apiUrl); // Fetch initial data
    getLocationUpdates();
    addCustomIcon();
  }

  @override
  void dispose() {
    _locationSubscription.cancel(); // Stop listening for location updates
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: null, // Remove the title
        centerTitle: false, // Remove centering
      ),
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            print("handle click inside map");
            // widget.handleMapClick();
            //
            // setState(() {
            //   isFullScreen = !isFullScreen;
            // });
          },
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(25.0),
                child: InkWell(
                  splashColor: Colors.white24,
                  onTap: widget.handleMapClick(),
                  child: Container(
                    child: GoogleMap(
                      // onTap: (argument) => widget.handleMapClick(),
                      initialCameraPosition: CameraPosition(
                        target: _locations.isNotEmpty
                            ? _locations.first
                            : LatLng(0, 0),
                        zoom: 15,
                      ),
                      myLocationEnabled: true,
                      zoomControlsEnabled: false,
                      markers: _locations
                          .map(
                            (location) => Marker(
                              markerId: MarkerId(location.toString()),
                              icon: BitmapDescriptor.defaultMarker,
                              position: location,
                            ),
                          )
                          .toSet(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> getLocationUpdates() async {
    _locationSubscription = _locationController.onLocationChanged.listen(
      (LocationData location) {
        if (location.latitude != null && location.longitude != null) {
          setState(() {
            _locations.add(LatLng(location.latitude!, location.longitude!));
          });
        }
      },
    );
  }

  Future<void> addCustomIcon() async {
    BitmapDescriptor.fromAssetImage(
      ImageConfiguration(size: Size(48, 48)),
      'assets/images/stacker2.png',
    ).then((icon) {
      setState(() {
        markerIcon = icon;
      });
    });
  }

  Future<void> fetchData(String url) async {
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data.containsKey('latitude') && data.containsKey('longitude')) {
          final latitude = 12.910896154654043;
          final longitude = 80.22640583833939;

          setState(() {
            _locations.add(LatLng(latitude, longitude));
          });
        } else {
          print(
              'Failed to fetch data. Latitude or Longitude not present in response.');
        }
      } else {
        print('Failed to fetch data. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching data: $error');
    }
  }
}
