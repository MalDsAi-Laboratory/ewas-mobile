import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:simple_ui/components/header.dart';
import 'package:simple_ui/components/carousal.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple UI',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 2;

  // Footer Tab Index Mapping
  final List<Widget> _tabContents = [
    Center(
      child: Text(
        'Categories Tab',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    ),
    Center(
      child: Text(
        'Create Order Tab',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    ),
    HomePage(),
    Center(
      child: Text(
        'Notifications Tab',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    ),
  ];

  void _onTabSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: Header(),
      ),
      body: _tabContents[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onTabSelected,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle),
            label: 'Create Order',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
        ],
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 2,
          child: CarouselWithSlider(),
        ),
        Expanded(
          flex: 3,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    print('Sell your E-Waste button pressed');
                  },
                  child: Text('Sell your E-Waste'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(200, 50),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    print('View E-Waste Around You button pressed');
                  },
                  child: Text('View E-Waste Around You'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(200, 50),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OpenStreetMapPage(),
                      ),
                    );
                  },
                  child: Text('Open Map'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(200, 50),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class OpenStreetMapPage extends StatefulWidget {
  @override
  _OpenStreetMapPageState createState() => _OpenStreetMapPageState();
}

class _OpenStreetMapPageState extends State<OpenStreetMapPage> {
  LatLng? _currentLocation;

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  Future<void> _getUserLocation() async {
    Location location = Location();

    // Check if location service is enabled
    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    // Check for location permissions
    PermissionStatus permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    // Get current location
    final userLocation = await location.getLocation();
    setState(() {
      _currentLocation = LatLng(userLocation.latitude!, userLocation.longitude!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('OpenStreetMap'),
      ),
      body: _currentLocation == null
    ? Center(child: CircularProgressIndicator())
    : FlutterMap(
        options: MapOptions(
          initialCenter: _currentLocation ?? LatLng(0, 0), // Provide a fallback for safety
          minZoom: 5.0,
        ),
        children: [
          TileLayer(
            urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
            subdomains: ['a', 'b', 'c'],
          ),
          if (_currentLocation != null) // Ensure the location is non-null
            MarkerLayer(
  markers: [
    Marker(
      point: _currentLocation!,
      width: 80.0, // Specify the width of the marker
      height: 80.0, // Specify the height of the marker
      child: Icon(
        Icons.location_pin,
        color: Colors.red,
        size: 40,
                    ),
                    ),
                  ],
                ),
              ],
            ),
    );
  }
}







