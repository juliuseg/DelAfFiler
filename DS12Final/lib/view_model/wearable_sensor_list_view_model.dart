import '../model/sensor.dart';
import '../model/mock_sensor.dart';
import '../model/polar_sensor.dart';

class WearableSensorListViewModel {
  List<Sensor> get sensors => [
    MockSensor(),
    PolarSensor('CE4EBF22'),
  ];
}