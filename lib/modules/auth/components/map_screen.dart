import 'dart:developer';

import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:geolocator/geolocator.dart';

import 'package:simple_ui/modules/auth/auth_controller.dart';
import 'package:simple_ui/ui_utils/app_colors.dart';
import 'package:simple_ui/ui_utils/button_widgets.dart';
import 'package:simple_ui/ui_utils/text_widgets.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  TextEditingController _searchController = TextEditingController();
  List<dynamic> _searchResults = [];

  final MapController _mapController = MapController();
  bool _showSearchResults = false;
  final AuthController locationController = Get.find<AuthController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(Duration(milliseconds: 10), () {
        if (locationController.selectedLatLng.value != null) {
          _mapController.move(locationController.selectedLatLng.value!, 15);
        }
      });
    });
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    print('serviceEnabled ${serviceEnabled}');

    // Check and request permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        // Permission denied — cannot get location
        return;
      }
    }

    // Get the current position (latitude and longitude)
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    // Set the location controller values
    final currentLatLng = LatLng(position.latitude, position.longitude);
    locationController.setLocation(currentLatLng, '');

    // Move the map to the current location
    _mapController.move(currentLatLng, 15);

    // Fetch the address for the current location
    final address = await _getAddressFromLatLng(currentLatLng);
    locationController.setLocation(currentLatLng, address);
  }

  Future<String> _getAddressFromLatLng(LatLng latLng) async {
    try {
      final response = await http.get(
          Uri.parse(
              'https://nominatim.openstreetmap.org/reverse?lat=${latLng.latitude}&lon=${latLng.longitude}&format=json'),
          headers: {'User-Agent': 'ScrapIt/1.0 (com.ewaste.ewas)'});
      print("response: " + response.body);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['display_name'] ?? 'Unknown Location';
      } else {
        return 'Address not found';
      }
    } catch (e) {
      log("error in getting location");
      return 'Address not found';
    }
  }

  Future<void> _searchAddress(String query) async {
    EasyDebounce.debounce('search-debouncer', const Duration(milliseconds: 300),
        () async {
      if (query.isEmpty) {
        setState(() => _searchResults = []);
        return;
      }

      final url =
          "https://nominatim.openstreetmap.org/search?format=json&q=$query";
      final response = await http.get(Uri.parse(url),
          headers: {'User-Agent': 'ScrapIt/1.0 (com.ewaste.ewas)'});

      if (response.statusCode == 200) {
        setState(() {
          _searchResults = json.decode(response.body);
          _showSearchResults = true;
        });
      }
    });
  }

  void _onSuggestionTap(dynamic suggestion) {
    final double lat = double.parse(suggestion['lat']);
    final double lon = double.parse(suggestion['lon']);
    final LatLng newLocation = LatLng(lat, lon);

    setState(() {
      locationController.setLocation(newLocation, suggestion['display_name']);
      _searchResults = [];
      _searchController.clear();
      _showSearchResults = false;
    });

    _mapController.move(newLocation, 15.0);
  }

  void _onMapTap(LatLng latLng) async {
    try {
      final response = await http.get(
        Uri.parse(
            'https://nominatim.openstreetmap.org/reverse.php?lat=${latLng.latitude}&lon=${latLng.longitude}&format=jsonv2'),
        headers: {'User-Agent': 'ScrapIt/1.0 (com.ewaste.ewas)'},
      );
      print("response lcation ${response.statusCode}");
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        locationController.setLocation(latLng, data['display_name']);
      }
    } catch (e) {
      log("error in _onMapTap $e");
    }
  }

  void _onConfirmLocation() {
    Navigator.pop(context, {
      'address': locationController.selectedAddress.value,
      'lat': locationController.selectedLatLng.value!.latitude,
      'lon': locationController.selectedLatLng.value!.longitude,
    });
  }

  void _onSearchFieldTap() {
    // if (_lastConfirmedLocation != null) {
    //   _mapController.move(_lastConfirmedLocation!, 15.0);
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Obx(
        () => Stack(
          children: [
            FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: locationController.selectedLatLng.value ??
                    LatLng(20.5937, 78.9629), // Centre of India
                initialZoom: 5,
                minZoom: 4,   // can't zoom out past country level
                maxZoom: 18,
                // Lock camera so user can never pan outside India
                cameraConstraint: CameraConstraint.containCenter(
                  bounds: LatLngBounds(
                    LatLng(6.5, 68.0),   // SW — tip of Kerala / Lakshadweep
                    LatLng(37.5, 97.5),  // NE — Arunachal Pradesh
                  ),
                ),
                onTap: (_, latLng) => _onMapTap(latLng),
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                  subdomains: ['a', 'b', 'c'],
                  // Required by OSM tile usage policy — without this tiles return 403
                  userAgentPackageName: 'com.ewaste.ewas',
                ),
                if (locationController.selectedLatLng.value != null)
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: locationController.selectedLatLng.value!,
                        width: 50,
                        height: 50,
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          child: Icon(Icons.location_on,
                              color: Colors.red, size: 40),
                        ),
                      ),
                    ],
                  ),
              ],
            ),

            /// Floating Search Bar with Glassmorphism
            Positioned(
              top: 60.h,
              left: 20.w,
              right: 20.w,
              child: Row(
                children: [
                  AppBarButton(),
                  SizedBox(
                    width: 10.w,
                  ),
                  GestureDetector(
                    onTap:
                        _onSearchFieldTap, // Recenter to last confirmed location
                    child: Material(
                      elevation: 10,
                      borderRadius: BorderRadius.circular(30.r),
                      child: Container(
                        width: 1.sw * 0.77,
                        // height: 50.h,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(30.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                            )
                          ],
                        ),
                        child: TextFormField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: "Search location...",
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 20.w,
                            ),
                          ),
                          onChanged: (value) => _searchAddress(value),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            /// Suggestions List
            if (_showSearchResults)
              Positioned(
                top: 140.h,
                left: 20.w,
                right: 20.w,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.95),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: SingleChildScrollView(
                    child: SizedBox(
                      height: 350
                          .h, // You can adjust the height based on your requirements
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: _searchResults.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            leading: Icon(Icons.location_pin,
                                color: AppColors.primaryColor),
                            title: InterText(
                                text: _searchResults[index]['display_name'],
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontSize: 14.sp,
                                )),
                            onTap: () =>
                                _onSuggestionTap(_searchResults[index]),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            if (locationController.selectedAddress.isNotEmpty)
              Positioned(
                bottom: 85.h,
                left: 20.w,
                right: 20.w,
                child: Container(
                  padding: EdgeInsets.all(12.r),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.95),
                    borderRadius: BorderRadius.circular(15.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10.r,
                      )
                    ],
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        color: Colors.redAccent,
                        size: 25.r,
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: InterText(
                          textAlign: TextAlign.left,
                          text: locationController.selectedAddress.value,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 14.sp, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            /// Floating Confirm Button
            Positioned(
              bottom: 25.h,
              left: 10.w,
              right: 10.w,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 50.h,
                    child: FloatingActionButton.extended(
                      heroTag: "userCurrentLocation",
                      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                      onPressed: _getCurrentLocation,
                      icon: Icon(
                        Icons.location_pin,
                        color: const Color.fromARGB(255, 0, 0, 0),
                        size: 25.r,
                      ),
                      label: InterText(
                          text: 'Use Current Location',
                          style: TextStyle(
                              color: const Color.fromARGB(255, 0, 0, 0),
                              fontSize: 14.sp)),
                    ),
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  AnimatedOpacity(
                    opacity: locationController.selectedLatLng.value != null
                        ? 1.0
                        : 0.0,
                    duration: Duration(milliseconds: 300),
                    child: SizedBox(
                      height: 50.h,
                      child: FloatingActionButton.extended(
                        heroTag: "confirmLocation",
                        backgroundColor: AppColors.primaryColor,
                        onPressed: _onConfirmLocation,
                        icon: Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 25.r,
                        ),
                        label: InterText(
                            text: 'Confirm',
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                                fontSize: 14.sp)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
