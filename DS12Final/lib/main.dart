import 'package:flutter/material.dart';
import 'view/wearable_sensors_list_view.dart';

void main() => runApp(WearableSensorApp());

class WearableSensorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wearable Sensing',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: WearableSensorsListView(),
    );
  }
}