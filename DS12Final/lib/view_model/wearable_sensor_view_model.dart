import '../model/sensor.dart';

class WearableSensorViewModel {
  final Sensor sensor;

  WearableSensorViewModel(this.sensor);

  String get name => sensor.name;
  String get address => sensor.address; 
  Stream<String> get batteryStatus => sensor.batteryStatus; 
  Stream<int> get heartRate => sensor.heartRate;
  Stream<bool> get isActive => sensor.isActive;


  
  void start() => sensor.start();
  void stop() => sensor.stop();

  Future<void> connect() => sensor.connect();
  Future<void> disconnect() => sensor.disconnect(address);


}