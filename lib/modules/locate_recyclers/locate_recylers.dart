import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:simple_ui/models/product_details_model.dart';
import 'package:simple_ui/modules/categories/categories_controller.dart';
import 'package:simple_ui/modules/locate_recyclers/locate_recyclers_controller.dart';
import 'package:simple_ui/ui_utils/button_widgets.dart';
import 'package:simple_ui/ui_utils/text_widgets.dart';
import 'dart:math' as math;

class LocateRecyclers extends StatefulWidget {
  @override
  _LocateRecyclersState createState() => _LocateRecyclersState();
}

class _LocateRecyclersState extends State<LocateRecyclers> {
  final MapController _mapController = MapController();
  final double fixedRadiusMeters = 4000;
  double _zoom = 12.0;
  int _selectedRecyclerIndex = 0; // Default to first recycler

  @override
  void initState() {
    super.initState();
    Get.put(LocateRecyclersController(
        productId: Get.find<CategoriesController>()
            .selectedSubCategory
            ?.productId
            .toString()));
    _mapController.mapEventStream.listen((event) {
      if (event is MapEventMove) {
        setState(() {
          _zoom = event.camera.zoom;
        });
      }
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
    if (_selectedRecyclerIndex <
        Get.find<LocateRecyclersController>().inventories.length - 1) {
      _selectRecycler(_selectedRecyclerIndex + 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    LocateRecyclersController locationController =
        Get.find<LocateRecyclersController>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(
        () => locationController.isLoading.value
            ? Center(child: CircularProgressIndicator())
            : Stack(
                children: [
                  FlutterMap(
                    mapController: _mapController,
                    options: MapOptions(
                      initialCenter: locationController.currentLocation.value ??
                          LatLng(0, 0),
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
                      if (locationController.currentLocation.value != null)
                        CircleLayer(
                          circles: [
                            CircleMarker(
                              point: locationController.currentLocation.value!,
                              radius: (fixedRadiusMeters / 156543.03392) *
                                  math.pow(2, _zoom), // Dynamically calculated
                              color: const Color.fromARGB(47, 76, 175, 79),
                              borderColor: Colors.green,
                              borderStrokeWidth: 2,
                            ),
                          ],
                        ),
                      MarkerLayer(
                        markers: locationController.inventories
                            .asMap()
                            .entries
                            .map((entry) {
                          int index = entry.key;
                          ProductDetailsModel recycler = entry.value;
                          return Marker(
                            point: locationController
                                .recyclersIdsAndLocations[recycler.userId]!,
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
                                          : Colors.white.withOpacity(
                                              0.7), // Default color
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      recycler.price.toString(),
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
                                      '${locationController.inventories.length} recyclers around you'),
                            ),
                            AppBarButton(
                              iconData: CupertinoIcons.refresh_thin,
                              bgColor: Colors.white,
                              onTap: () => _mapController.moveAndRotate(
                                locationController.currentLocation.value!,
                                12, // Zoom level
                                0.0, // Bearing (rotation) reset to 0
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  locationController.inventories.isEmpty
                      ? SizedBox()
                      : Align(
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
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(25)),
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
                                              iconData:
                                                  Icons.arrow_back_ios_new,
                                              onTap: _prevRecycler,
                                              iconColor:
                                                  _selectedRecyclerIndex == 0
                                                      ? Colors.grey
                                                      : Colors.black,
                                              bgColor:
                                                  _selectedRecyclerIndex == 0
                                                      ? const Color.fromARGB(
                                                          222, 249, 249, 249)
                                                      : Colors.white,
                                            ),
                                            SizedBox(
                                              width: 10.w,
                                            ),
                                            CustomIconButton(
                                              iconData: Icons.arrow_forward_ios,
                                              iconColor:
                                                  _selectedRecyclerIndex ==
                                                          locationController
                                                                  .inventories
                                                                  .length -
                                                              1
                                                      ? Colors.grey
                                                      : Colors.black,
                                              onTap: _nextRecycler,
                                              bgColor: _selectedRecyclerIndex ==
                                                      locationController
                                                              .inventories
                                                              .length -
                                                          1
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
                                            borderRadius:
                                                BorderRadius.circular(100),
                                            color: Colors.grey,
                                          ),
                                        ),
                                        SizedBox(width: 4),
                                        BricolageText(text: "Lithium Ion"),
                                      ],
                                    ),
                                    SizedBox(height: 12),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        BricolageText(
                                          text: "Price",
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                        BricolageText(
                                            text: locationController
                                                .selectedRecycler.value.price
                                                .toString()),
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
      ),
    );
  }
}
