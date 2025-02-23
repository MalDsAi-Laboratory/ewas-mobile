import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:simple_ui/models/nearby_recycler_mode.dart';
import 'package:simple_ui/ui_utils/button_widgets.dart';
import 'package:simple_ui/ui_utils/text_widgets.dart';
import 'dart:math' as math;

class LocateRecyclers extends StatefulWidget {
  @override
  _LocateRecyclersState createState() => _LocateRecyclersState();
}

class _LocateRecyclersState extends State<LocateRecyclers> {
  LatLng? _currentLocation;
  final MapController _mapController = MapController();
  final double fixedRadiusMeters = 4000;
  double _zoom = 12.0;
  int _selectedRecyclerIndex = 0; // Default to first recycler

  final List<Recycler> recyclers = [
    Recycler(
      name: "Recycle Hub",
      address: "456 Clean Road, New Delhi",
      contact: "+91 8765432109",
      price: "Rs 10",
      location: LatLng(28.692635, 77.103316),
    ),
    Recycler(
      name: "Eco Waste Solutions",
      address: "789 Green Lane, New Delhi",
      price: "Rs 12",
      contact: "+91 7654321098",
      location: LatLng(28.690040, 77.136315),
    ),
    Recycler(
      name: "Eco Waste Solutions",
      address: "789 Green Lane, New Delhi",
      price: "Rs 12",
      contact: "+91 7654321098",
      location: LatLng(28.690040, 77.136315),
    ),
    Recycler(
      name: "Eco Waste Solutions",
      address: "789 Green Lane, New Delhi",
      price: "Rs 12",
      contact: "+91 7654321098",
      location: LatLng(28.690040, 77.136315),
    ),
    Recycler(
      name: "Eco Waste Solutions",
      address: "789 Green Lane, New Delhi",
      price: "Rs 12",
      contact: "+91 7654321098",
      location: LatLng(28.690040, 77.136315),
    ),
    Recycler(
      name: "Eco Waste Solutions",
      address: "789 Green Lane, New Delhi",
      price: "Rs 12",
      contact: "+91 7654321098",
      location: LatLng(28.690040, 77.136315),
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

  void _selectRecycler(int index) {
    setState(() {
      _selectedRecyclerIndex = index;
    });
  }

  void _prevRecycler() {
    if (_selectedRecyclerIndex > 0) {
      _selectRecycler(_selectedRecyclerIndex - 1);
    }
  }

  void _nextRecycler() {
    if (_selectedRecyclerIndex < recyclers.length - 1) {
      _selectRecycler(_selectedRecyclerIndex + 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    Recycler selectedRecycler = recyclers[_selectedRecyclerIndex];

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
                            radius: (fixedRadiusMeters / 156543.03392) *
                                math.pow(2, _zoom), // Dynamically calculated
                            color: const Color.fromARGB(47, 76, 175, 79),
                            borderColor: Colors.green,
                            borderStrokeWidth: 2,
                          ),
                        ],
                      ),
                    MarkerLayer(
                      markers: recyclers.asMap().entries.map((entry) {
                        int index = entry.key;
                        Recycler recycler = entry.value;
                        return Marker(
                          point: recycler.location,
                          width: 80.0,
                          height: 80.0,
                          child: GestureDetector(
                            onTap: () => _selectRecycler(index),
                            child: Column(
                              children: [
                                // Floating Price Container
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: index == _selectedRecyclerIndex
                                        ? Colors.green.withOpacity(
                                            0.7) // Highlighted for selected recycler
                                        : Colors.white
                                            .withOpacity(0.7), // Default color
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    recycler.price,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),

                                SizedBox(
                                    height:
                                        4), // Spacing between price and icon
                                // Recycler Icon
                                Icon(
                                  Icons.recycling,
                                  color: index == _selectedRecyclerIndex
                                      ? Colors.green
                                      : Colors.blue,
                                  size: 40,
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
                Positioned(
                  top: 0,
                  child: SafeArea(
                    child: Container(
                      margin: EdgeInsets.only(top: 16),
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AppBarButton(bgColor: Colors.white),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: BricolageText(
                                text:
                                    '${recyclers.length} recyclers around you'),
                          ),
                          AppBarButton(
                            iconData: CupertinoIcons.refresh_thin,
                            bgColor: Colors.white,
                            onTap: () => _mapController.moveAndRotate(
                              _currentLocation!,
                              12, // Zoom level
                              0.0, // Bearing (rotation) reset to 0
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: DraggableScrollableSheet(
                    expand: false,
                    shouldCloseOnMinExtent: false,
                    initialChildSize: 0.2,
                    minChildSize: 0.1,
                    maxChildSize: 0.2,
                    builder: (context, scrollController) {
                      return Container(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(25)),
                        ),
                        child: Column(
                          children: [
                            SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Row(
                                  children: [
                                    CustomIconButton(
                                      iconData: Icons.arrow_back_ios_new,
                                      onTap: _prevRecycler,
                                      iconColor: _selectedRecyclerIndex == 0
                                          ? Colors.grey
                                          : Colors.black,
                                      bgColor: _selectedRecyclerIndex == 0
                                          ? const Color.fromARGB(
                                              222, 249, 249, 249)
                                          : Colors.white,
                                    ),
                                    SizedBox(
                                      width: 10.w,
                                    ),
                                    CustomIconButton(
                                      iconData: Icons.arrow_forward_ios,
                                      iconColor: _selectedRecyclerIndex ==
                                              recyclers.length - 1
                                          ? Colors.grey
                                          : Colors.black,
                                      onTap: _nextRecycler,
                                      bgColor: _selectedRecyclerIndex ==
                                              recyclers.length - 1
                                          ? const Color.fromARGB(
                                              222, 249, 249, 249)
                                          : Colors.white,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 12),
                            Row(
                              children: [
                                BricolageText(text: "Battery"),
                                SizedBox(width: 4),
                                Container(
                                  width: 3,
                                  height: 3,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    color: Colors.grey,
                                  ),
                                ),
                                SizedBox(width: 4),
                                BricolageText(text: "Lithium Ion"),
                              ],
                            ),
                            SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                BricolageText(
                                  text: "Price",
                                  style: TextStyle(color: Colors.grey),
                                ),
                                BricolageText(text: selectedRecycler.price),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
