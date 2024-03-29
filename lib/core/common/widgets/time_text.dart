import 'dart:async';

import 'package:flutter/material.dart';
import 'package:social_ease_app/core/extensions/date_time_extension.dart';
import 'package:social_ease_app/core/res/colors.dart';
import 'package:social_ease_app/core/res/fonts.dart';

class TimeText extends StatefulWidget {
  const TimeText({
    super.key,
    required this.time,
    this.prefixText,
    this.style,
    this.maxLines,
    this.overflow,
  });

  final DateTime time;
  final String? prefixText;
  final TextStyle? style;
  final int? maxLines;
  final TextOverflow? overflow;

  @override
  State<TimeText> createState() => _TimeTextState();
}

class _TimeTextState extends State<TimeText> {
  Timer? timer;
  late String timeAgo;

  @override
  void initState() {
    super.initState();
    timeAgo = widget.time.timeAgo;
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        if (timeAgo != widget.time.timeAgo) {
          setState(() {
            timeAgo = widget.time.timeAgo;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      '${widget.prefixText != null ? '${widget.prefixText}' : ''} $timeAgo',
      maxLines: widget.maxLines,
      overflow: widget.overflow,
      style: widget.style ??
          TextStyle(
            fontSize: 12,
            color: AppColors.secondaryTextColor,
            fontFamily: Fonts.poppins,
          ),
    );
  }
}
