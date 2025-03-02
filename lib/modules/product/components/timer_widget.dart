import 'dart:async';
import 'dart:developer';
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
  late Duration remainingTime;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    log('inputTime ${widget.inputTime}');
    _calculateTargetTime();
    _startTimer();
  }

  void _calculateTargetTime() {
    targetTime = widget.inputTime.add(const Duration(hours: 4));

    // If targetTime is in the past, move it to the next available future time
    if (targetTime.isBefore(DateTime.now())) {
      // Calculate how many 4-hour periods have passed since the inputTime
      final timeSinceInput = DateTime.now().difference(widget.inputTime);
      final periodsToAdd = (timeSinceInput.inHours / 4).ceil();

      // Add the required number of 4-hour periods to the original inputTime
      targetTime = widget.inputTime.add(Duration(hours: 4 * periodsToAdd));
    }

    remainingTime = targetTime.difference(DateTime.now());
  }

  void _startTimer() {
    if (remainingTime.isNegative) {
      remainingTime = Duration.zero;
    } else {
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          remainingTime = targetTime.difference(DateTime.now());
          if (remainingTime.isNegative) {
            remainingTime = Duration.zero;
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

    if (remainingTime == Duration.zero) {
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
