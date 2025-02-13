import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'package:simple_ui/models/nearby_recycler_mode.dart';
import 'package:simple_ui/ui_utils/button_widgets.dart';
import 'package:simple_ui/ui_utils/text_widgets.dart';
import 'dart:math' as math;

class OpenStreetMapPage extends StatefulWidget {
  @override
  _OpenStreetMapPageState createState() => _OpenStreetMapPageState();
}

class _OpenStreetMapPageState extends State<OpenStreetMapPage> {
  LatLng? _currentLocation;
  Recycler? _selectedRecycler;
  final double fixedRadiusMeters = 5000;
  List<LatLng> _routeCoordinates = [];
  final String openRouteKey =
      "5b3ce3597851110001cf62488989b7de40474d2aa292c64784320a50";
  double _zoom = 10.0; // Default zoom level
  final MapController _mapController = MapController();
  final List<Recycler> recyclers = [
    // Recycler(
    //   name: "Green Earth Recycler",
    //   address: "123 Eco Street, New Delhi",
    //   contact: "+91 9876543210",
    //   location: LatLng(
    //     28.6901247,
    //     77.1344339,
    //   ),
    // ),
    Recycler(
      name: "Recycle Hub",
      address: "456 Clean Road, New Delhi",
      contact: "+91 8765432109",
      location: LatLng(37.428541, -122.130557),
    ),
    Recycler(
      name: "Eco Waste Solutions",
      address: "789 Green Lane, New Delhi",
      contact: "+91 7654321098",
      location: LatLng(37.384326, -122.075663),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _getUserLocation();
    _mapController.mapEventStream.listen((event) {
      if (event is MapEventMove) {
        setState(() {
          _zoom = event.camera.zoom;
        });
      }
    });
  }

  /// Convert meters to pixel radius based on zoom level
  double _calculateRadius() {
    // Approximate conversion factor for meters to pixels at zoom level 10
    const double basePixelPerMeterAtZoom10 = 0.02;
    return fixedRadiusMeters *
        basePixelPerMeterAtZoom10 *
        (math.pow(1.5, (_zoom - 10)));
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

  // void _showRecyclerDetails(Recycler recycler) {
  //   setState(() {
  //     _selectedRecycler = recycler;
  //     _getRoute(recycler.location);
  //   });

  // }

  void _recenterView() {
    if (_currentLocation != null) {
      _mapController.move(_currentLocation!, 10);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _currentLocation == null
          ? Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: _currentLocation ?? LatLng(0, 0),
                    initialZoom: _zoom,
                    keepAlive: true,
                    minZoom: 5.0,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                      subdomains: ['a', 'b', 'c'],
                    ),
                    // 🟢 Add Circle Layer for User Location Radius
                    if (_currentLocation != null)
                      CircleLayer(
                        circles: [
                          CircleMarker(
                            point: _currentLocation!,
                            radius:
                                _calculateRadius(), // Dynamically calculated
                            color: Colors.green.withOpacity(0.3),
                            borderColor: Colors.green,
                            borderStrokeWidth: 2,
                          ),
                        ],
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
                                // _showRecyclerDetails(recycler);
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
                Positioned(
                  top: 0,
                  child: SafeArea(
                    child: Container(
                      margin: EdgeInsets.only(top: 16.h),
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      width: 1.sw,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AppBarButton(
                            bgColor: const Color.fromARGB(212, 255, 255, 255),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20.w, vertical: 10.h),
                            decoration: BoxDecoration(
                                color: const Color.fromARGB(212, 255, 255, 255),
                                borderRadius: BorderRadius.circular(100.r)),
                            child: BricolageText(
                                text:
                                    '${recyclers.length} recyclers around you'),
                          ),
                          AppBarButton(
                            iconData: CupertinoIcons.refresh_thin,
                            bgColor: const Color.fromARGB(212, 255, 255, 255),
                            onTap: () {
                              _recenterView();
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

// Align(
//                     alignment: Alignment.bottomCenter,
//                     child: Builder(builder: (context) {
//                       Size size = MediaQuery.of(context).size;
//                       double minChildSize = 260.h / size.height;
//                       return DraggableScrollableSheet(
//                           expand: false,
//                           shouldCloseOnMinExtent: false,
//                           initialChildSize: 0.9,
//                           minChildSize: minChildSize,
//                           maxChildSize: 0.9,
//                           builder: (context, scrollController) {
//                             return SingleChildScrollView(
//                               controller: scrollController,
//                             );
//                           });
//                     }))
// import 'dart:convert';
// import 'package:easy_debounce/easy_debounce.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:latlong2/latlong.dart';
// import 'package:location/location.dart';
// import 'package:http/http.dart' as http;
// import 'dart:math' as math;

// class OpenStreetMapPage extends StatefulWidget {
//   @override
//   _OpenStreetMapPageState createState() => _OpenStreetMapPageState();
// }

// class _OpenStreetMapPageState extends State<OpenStreetMapPage> {
//   LatLng? _currentLocation;
//   final MapController _mapController = MapController();
//   final double fixedRadiusMeters = 5000;
//   double _zoom = 10.0;
//   final TextEditingController _searchController = TextEditingController();
//   List<dynamic> _searchResults = [];

//   @override
//   void initState() {
//     super.initState();
//     _getUserLocation();
//     _mapController.mapEventStream.listen((event) {
//       if (event is MapEventMove) {
//         setState(() {
//           _zoom = event.camera.zoom;
//         });
//       }
//     });
//   }

//   /// Convert meters to pixel radius based on zoom level
//   double _calculateRadius() {
//     // Approximate conversion factor for meters to pixels at zoom level 10
//     const double basePixelPerMeterAtZoom10 = 0.02;
//     return fixedRadiusMeters *
//         basePixelPerMeterAtZoom10 *
//         (math.pow(1.5, (_zoom - 10)));
//   }

//   /// Get User Location
//   Future<void> _getUserLocation() async {
//     Location location = Location();
//     bool serviceEnabled = await location.serviceEnabled();
//     if (!serviceEnabled) {
//       serviceEnabled = await location.requestService();
//       if (!serviceEnabled) return;
//     }
//     PermissionStatus permissionGranted = await location.hasPermission();
//     if (permissionGranted == PermissionStatus.denied) {
//       permissionGranted = await location.requestPermission();
//       if (permissionGranted != PermissionStatus.granted) return;
//     }
//     final userLocation = await location.getLocation();
//     setState(() {
//       _currentLocation =
//           LatLng(userLocation.latitude!, userLocation.longitude!);
//     });
//   }

//   /// Search Places using OpenStreetMap (Nominatim API)
//   Future<void> _searchPlace(String query) async {
//     EasyDebounce.debounce(
//         'my-debouncer', // <-- An ID for this particular debouncer
//         const Duration(milliseconds: 300), // <-- The debounce duration
//         () async {
//       if (query.isEmpty) {
//         setState(() {
//           _searchResults = [];
//         });
//         return;
//       }

//       final url =
//           "https://nominatim.openstreetmap.org/search?format=json&q=$query";
//       final response = await http.get(Uri.parse(url));

//       if (response.statusCode == 200) {
//         setState(() {
//           _searchResults = json.decode(response.body);
//         });
//       }
//     }
//         // <-- The target method
//         );
//   }

//   /// Move to Selected Location with Dynamic Zoom Level
//   void _moveToLocation(double lat, double lon, List<dynamic> boundingBox) {
//     double minLat = double.parse(boundingBox[0]);
//     double maxLat = double.parse(boundingBox[1]);
//     double minLon = double.parse(boundingBox[2]);
//     double maxLon = double.parse(boundingBox[3]);

//     // Calculate bounding box size
//     double latDiff = maxLat - minLat;
//     double lonDiff = maxLon - minLon;

//     // Determine appropriate zoom level
//     double zoomLevel;
//     if (latDiff < 0.01 && lonDiff < 0.01) {
//       zoomLevel = 18.0; // Buildings, small places
//     } else if (latDiff < 0.05 && lonDiff < 0.05) {
//       zoomLevel = 16.0; // Local areas
//     } else if (latDiff < 0.1 && lonDiff < 0.1) {
//       zoomLevel = 14.0; // Towns, small cities
//     } else if (latDiff < 0.5 && lonDiff < 0.5) {
//       zoomLevel = 12.0; // Large cities
//     } else {
//       zoomLevel = 10.0; // Large regions or countries
//     }

//     _mapController.move(LatLng(lat, lon), zoomLevel);

//     setState(() {
//       _searchController.text = "";
//       _searchResults = [];
//     });
//   }

//   /// Zoom In
//   void _zoomIn() {
//     _mapController.move(
//         _mapController.camera.center, _mapController.camera.zoom + 1);
//   }

//   /// Zoom Out
//   void _zoomOut() {
//     _mapController.move(
//         _mapController.camera.center, _mapController.camera.zoom - 1);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         surfaceTintColor: Colors.white,
//         title: Text("Locate Places", style: TextStyle(fontSize: 20.sp)),
//       ),
//       body: _currentLocation == null
//           ? Center(child: CircularProgressIndicator())
//           : Stack(
//               children: [
//                 /// Map Container
//                 FlutterMap(
//                   mapController: _mapController,
//                   options: MapOptions(
//                     initialCenter: _currentLocation!,
//                     initialZoom: _zoom,
//                     minZoom: 5.0,
//                   ),
//                   children: [
//                     TileLayer(
//                       urlTemplate:
//                           "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
//                       subdomains: ['a', 'b', 'c'],
//                     ),
//                     if (_currentLocation != null)
//                       CircleLayer(
//                         circles: [
//                           CircleMarker(
//                             point: _currentLocation!,
//                             radius:
//                                 _calculateRadius(), // Dynamically calculated
//                             color: Colors.green.withOpacity(0.3),
//                             borderColor: Colors.green,
//                             borderStrokeWidth: 2,
//                           ),
//                         ],
//                       ),
//                     MarkerLayer(
//                       markers: [
//                         Marker(
//                           point: _currentLocation!,
//                           width: 80.0,
//                           height: 80.0,
//                           child: Icon(Icons.location_pin,
//                               color: Colors.red, size: 40),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),

//                 /// Search Bar
//                 Positioned(
//                   top: 20,
//                   left: 20,
//                   right: 20,
//                   child: Column(
//                     children: [
//                       Container(
//                         padding: EdgeInsets.symmetric(horizontal: 12),
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(8),
//                           boxShadow: [
//                             BoxShadow(color: Colors.black26, blurRadius: 5),
//                           ],
//                         ),
//                         child: TextField(
//                           controller: _searchController,
//                           onChanged: _searchPlace,
//                           decoration: InputDecoration(
//                             hintText: "Search for places...",
//                             border: InputBorder.none,
//                             prefixIcon: Icon(Icons.search),
//                           ),
//                         ),
//                       ),

//                       /// Search Results
//                       if (_searchResults.isNotEmpty)
//                         Container(
//                           margin: EdgeInsets.only(top: 8),
//                           padding: EdgeInsets.all(8),
//                           decoration: BoxDecoration(
//                             color: Colors.white,
//                             borderRadius: BorderRadius.circular(8),
//                             boxShadow: [
//                               BoxShadow(color: Colors.black26, blurRadius: 5),
//                             ],
//                           ),
//                           child: ListView.builder(
//                             shrinkWrap: true,
//                             itemCount: _searchResults.length,
//                             itemBuilder: (context, index) {
//                               var place = _searchResults[index];
//                               return ListTile(
//                                 title: Text(place['display_name']),
//                                 onTap: () {
//                                   double lat = double.parse(place['lat']);
//                                   double lon = double.parse(place['lon']);
//                                   _moveToLocation(
//                                       lat, lon, place['boundingbox']);
//                                 },
//                               );
//                             },
//                           ),
//                         ),
//                     ],
//                   ),
//                 ),

//                 /// Zoom In/Out Buttons
//                 Positioned(
//                   bottom: 20,
//                   right: 20,
//                   child: Column(
//                     children: [
//                       FloatingActionButton(
//                         heroTag: "zoomIn",
//                         mini: true,
//                         onPressed: _zoomIn,
//                         child: Icon(Icons.add),
//                       ),
//                       SizedBox(height: 10),
//                       FloatingActionButton(
//                         heroTag: "zoomOut",
//                         mini: true,
//                         onPressed: _zoomOut,
//                         child: Icon(Icons.remove),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//     );
//   }
// }
