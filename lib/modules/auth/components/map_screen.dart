import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:simple_ui/modules/auth/auth_controller.dart';
import 'package:simple_ui/ui_utils/app_colors.dart';

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

  Future<void> _searchAddress(String query) async {
    EasyDebounce.debounce('search-debouncer', const Duration(milliseconds: 300),
        () async {
      if (query.isEmpty) {
        setState(() => _searchResults = []);
        return;
      }

      final url =
          "https://nominatim.openstreetmap.org/search?format=json&q=$query";
      final response = await http.get(Uri.parse(url));

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
    final response = await http.get(
      Uri.parse(
          'https://nominatim.openstreetmap.org/reverse?lat=${latLng.latitude}&lon=${latLng.longitude}&format=json'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      locationController.setLocation(latLng, data['display_name']);
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
                    LatLng(20.5937, 78.9629),
                initialZoom: 5,
                onTap: (_, latLng) => _onMapTap(latLng),
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                  subdomains: ['a', 'b', 'c'],
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
              top: 60,
              left: 20,
              right: 20,
              child: GestureDetector(
                onTap: _onSearchFieldTap, // Recenter to last confirmed location
                child: Material(
                  elevation: 10,
                  borderRadius: BorderRadius.circular(30),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                        )
                      ],
                    ),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.search, color: Colors.grey),
                        hintText: "Search location...",
                        border: InputBorder.none,
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                      ),
                      onChanged: (value) => _searchAddress(value),
                    ),
                  ),
                ),
              ),
            ),

            /// Suggestions List
            if (_showSearchResults)
              Positioned(
                top: 120,
                left: 20,
                right: 20,
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
                            title: Text(_searchResults[index]['display_name']),
                            onTap: () =>
                                _onSuggestionTap(_searchResults[index]),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),

            /// Floating Confirm Button
            Positioned(
              bottom: 40,
              left: 20,
              right: 20,
              child: AnimatedOpacity(
                opacity:
                    locationController.selectedLatLng.value != null ? 1.0 : 0.0,
                duration: Duration(milliseconds: 300),
                child: SizedBox(
                  height: 50,
                  child: FloatingActionButton.extended(
                    backgroundColor: AppColors.primaryColor,
                    onPressed: _onConfirmLocation,
                    icon: Icon(Icons.check, color: Colors.white),
                    label: Text("Confirm Location",
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
              ),
            ),

            /// Bottom Sheet for Selected Address
            if (locationController.selectedAddress.isNotEmpty)
              Positioned(
                bottom: 100,
                left: 20,
                right: 20,
                child: Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.95),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                      )
                    ],
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.location_on, color: Colors.redAccent),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          locationController.selectedAddress.value,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
