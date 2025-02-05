import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'package:simple_ui/models/nearby_recycler_mode.dart';
import 'package:simple_ui/ui_utils/button_widgets.dart';
import 'package:simple_ui/ui_utils/text_widgets.dart';

class OpenStreetMapPage extends StatefulWidget {
  @override
  _OpenStreetMapPageState createState() => _OpenStreetMapPageState();
}

class _OpenStreetMapPageState extends State<OpenStreetMapPage> {
  LatLng? _currentLocation;
  Recycler? _selectedRecycler;
  List<LatLng> _routeCoordinates = [];
  final String openRouteKey =
      "5b3ce3597851110001cf62488989b7de40474d2aa292c64784320a50";

  final List<Recycler> recyclers = [
    Recycler(
      name: "Green Earth Recycler",
      address: "123 Eco Street, New Delhi",
      contact: "+91 9876543210",
      location: LatLng(
        28.6901247,
        77.1344339,
      ),
    ),
    Recycler(
      name: "Recycle Hub",
      address: "456 Clean Road, New Delhi",
      contact: "+91 8765432109",
      location: LatLng(28.694020, 77.114437),
    ),
    Recycler(
      name: "Eco Waste Solutions",
      address: "789 Green Lane, New Delhi",
      contact: "+91 7654321098",
      location: LatLng(28.687660, 77.145465),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  Future<void> _getUserLocation() async {
    Location location = Location();
    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) return;
    }
    PermissionStatus permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) return;
    }
    final userLocation = await location.getLocation();
    setState(() {
      _currentLocation =
          LatLng(userLocation.latitude!, userLocation.longitude!);
    });
  }

  /// Fetch road route from OpenRouteService
  Future<void> _getRoute(LatLng destination) async {
    if (_currentLocation == null) return;

    final url =
        "https://api.openrouteservice.org/v2/directions/driving-car?api_key=$openRouteKey&start=${_currentLocation!.longitude},${_currentLocation!.latitude}&end=${destination.longitude},${destination.latitude}";

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      final List<dynamic> coordinates =
          decoded['features'][0]['geometry']['coordinates'];

      setState(() {
        _routeCoordinates = coordinates
            .map((coord) => LatLng(coord[1], coord[0])) // Swap lat/lng
            .toList();
      });
    } else {
      print("Error fetching route: ${response.body}");
    }
  }

  void _showRecyclerDetails(Recycler recycler) {
    setState(() {
      _selectedRecycler = recycler;
      _getRoute(recycler.location);
    });

    // showModalBottomSheet(
    //   context: context,
    //   shape: RoundedRectangleBorder(
    //     borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    //   ),
    //   builder: (context) => );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          leading: AppBarButton(),
          title: BricolageText(
            text: 'Locate Recyclers',
            style: TextStyle(fontSize: 20.sp),
          )),
      body: _currentLocation == null
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.r)),
                    height: 1.sh * 0.85,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20.r),
                      child: FlutterMap(
                        options: MapOptions(
                          initialCenter: _currentLocation ?? LatLng(0, 0),
                          initialZoom: 14.0,
                          minZoom: 5.0,
                        ),
                        children: [
                          TileLayer(
                            urlTemplate:
                                "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                            subdomains: ['a', 'b', 'c'],
                          ),
                          MarkerLayer(
                            markers: [
                              Marker(
                                point: _currentLocation!,
                                width: 80.0,
                                height: 80.0,
                                child: Icon(Icons.location_pin,
                                    color: Colors.red, size: 40),
                              ),
                              ...recyclers.map((recycler) {
                                return Marker(
                                  point: recycler.location,
                                  width: 80.0,
                                  height: 80.0,
                                  child: GestureDetector(
                                    onTap: () {
                                      _showRecyclerDetails(recycler);
                                    },
                                    child: Icon(Icons.recycling,
                                        color: Colors.blue, size: 40),
                                  ),
                                );
                              }).toList(),
                            ],
                          ),
                          if (_routeCoordinates.isNotEmpty)
                            PolylineLayer(
                              polylines: [
                                Polyline(
                                  points: _routeCoordinates,
                                  color: Colors.blue,
                                  strokeWidth: 5.0,
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ),
                  Align(
                      alignment: Alignment.bottomCenter,
                      child: Builder(builder: (context) {
                        Size size = MediaQuery.of(context).size;
                        double minChildSize = 260.h / size.height;
                        return DraggableScrollableSheet(
                            expand: false,
                            shouldCloseOnMinExtent: false,
                            initialChildSize: 0.9,
                            minChildSize: minChildSize,
                            maxChildSize: 0.9,
                            builder: (context, scrollController) {
                              return SingleChildScrollView(
                                controller: scrollController,
                              );
                            });
                      }))
                ],
              ),
            ),
    );
  }
}
