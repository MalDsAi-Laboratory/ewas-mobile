import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:simple_ui/models/nearby_recycler_mode.dart';

class NearbyRecyclerWidget extends StatelessWidget {
  final Recycler recycler;
  const NearbyRecyclerWidget({super.key, required this.recycler});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            recycler.name,
            style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(recycler.address, style: TextStyle(fontSize: 16.sp)),
          SizedBox(height: 8),
          Text("📞 Contact: ${recycler.contact}",
              style: TextStyle(fontSize: 16.sp, color: Colors.blue)),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              // Navigator.pop(context);
              // _getRoute(recycler.location);
            },
            child: Text("Get Directions"),
          ),
        ],
      ),
    );
  }
}
