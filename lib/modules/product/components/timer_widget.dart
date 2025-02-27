import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:simple_ui/ui_utils/text_widgets.dart';

class TimerWidget extends StatefulWidget {
  final DateTime inputTime;

  const TimerWidget({super.key, required this.inputTime});

  @override
  _TimerWidgetState createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  late DateTime targetTime;
  Duration remainingTime = Duration.zero;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    targetTime = widget.inputTime.add(const Duration(hours: 4));
    _startTimer();
  }

  void _startTimer() {
    if (DateTime.now().isBefore(targetTime)) {
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          remainingTime = targetTime.difference(DateTime.now());
          if (remainingTime.isNegative) {
            _timer?.cancel();
          }
        });
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int hours = remainingTime.inHours;
    int minutes = remainingTime.inMinutes.remainder(60);
    int seconds = remainingTime.inSeconds.remainder(60);
    if (_timer != null && hours == 0 && minutes == 0 && seconds == 0) {
      return const BricolageText(
        text: "Time Over",
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.red,
        ),
      );
    }

    return BricolageText(
      text:
          '${hours.toString().padLeft(2, '0')} : ${minutes.toString().padLeft(2, '0')} : ${seconds.toString().padLeft(2, '0')}',
      style: TextStyle(
        fontSize: 24.sp,
        fontWeight: FontWeight.bold,
        color: const Color.fromARGB(255, 255, 30, 0),
      ),
    );
  }
}
