import 'package:latlong2/latlong.dart';

class Recycler {
  final String name;
  final String address;
  final String contact;
  final String price;
  final LatLng location;

  Recycler(
      {required this.name,
      required this.address,
      required this.price,
      required this.contact,
      required this.location});
}
