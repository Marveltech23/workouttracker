import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:workout_tracker/date_time/date_time.dart';

class MyheatMap extends StatelessWidget {
  final Map<DateTime, int>? datasets;
  final String startDateYYYYMMDD;
  const MyheatMap({
    Key? key,
    this.datasets,
    required this.startDateYYYYMMDD,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(25),
        child: HeatMap(
          datasets: datasets,
          colorMode: ColorMode.color,
          defaultColor: Colors.grey,
          textColor: Colors.black,
          showColorTip: false,
          showText: true,
          scrollable: true,
          size: 30,
          startDate: CreateDateTimeOblect(startDateYYYYMMDD),
          endDate: DateTime.now().add(Duration(days: 0)),
          colorsets: {
            1: Colors.green,
          },
        ));
  }
}
