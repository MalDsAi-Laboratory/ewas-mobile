import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class CustomShimmer extends StatelessWidget {
  final double? height;
  final double? width;
  const CustomShimmer({super.key, this.height = 80, this.width = 80});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color.fromARGB(255, 252, 252, 252),
      highlightColor: const Color.fromARGB(255, 233, 233, 233),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.w),
        ),
      ),
    );
  }
}
