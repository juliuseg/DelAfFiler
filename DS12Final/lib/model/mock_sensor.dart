import 'sensor.dart';
import 'dart:async';
import 'dart:math';

class MockSensor extends Sensor {
  final _heartRateController = StreamController<int>.broadcast();
  final _batteryController = StreamController<String>.broadcast();


  @override
  String get name => 'Mock Wearable Sensor';

  @override
  String get address => 'qwertyui'; 

  @override
  Stream<String> get batteryStatus => _batteryController.stream;

  bool _isConnected = false;
  @override
  bool get isConnected => _isConnected;

  final _activeStatusController = StreamController<bool>.broadcast();
  @override
  Stream<bool> get isActive => _activeStatusController.stream;

  bool _active = false;

  @override
  Stream<int> get heartRate => _heartRateController.stream;


  @override
  Future<bool> get hasPermissions async => false;

  @override
  Future<void> requestPermissions() async{
    _activeStatusController.add(true);

  }

  @override
  Future<void> connect() async{
    _isConnected = true;

    _batteryController.add("${_random.nextInt(101)}%");
  }

  @override
  Future<void> disconnect(String deviceId) async{
    _isConnected = false;
    _batteryController.add("no data");
  }
  

  @override
  void start() {
    _activeStatusController.add(true);
    _active = true;
    startStream();

  }

  @override
  void stop() {
    _activeStatusController.add(false);
    _active = false;
  }

  final _random = Random();
  void startStream() async {
    if (_isConnected){
      while (_isConnected && _active) {
        await Future.delayed(Duration(seconds: 1));
        _heartRateController.add(60 + _random.nextInt(41));
        _batteryController.add("${_random.nextInt(101)}%");

      }
    }
  }
}