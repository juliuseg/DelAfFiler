import 'package:flutter/material.dart';
import '../view_model/wearable_sensor_list_view_model.dart';
import '../view_model/wearable_sensor_view_model.dart';


class WearableSensorsListView extends StatelessWidget {
  final WearableSensorListViewModel viewModel = WearableSensorListViewModel();

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wearable Sensing'),
      ),
      body: ListView.builder(
        itemCount: viewModel.sensors.length,
        itemBuilder: (context, index) {
          final sensorViewModel = WearableSensorViewModel(viewModel.sensors[index]);
          
          return StreamBuilder<String>(
            stream: sensorViewModel.batteryStatus, 
            builder: (context, snapshotBat) {
              bool isConnected = snapshotBat.hasData;
              if (isConnected && snapshotBat.data == "no data") isConnected = false;
          
              return Card(
                margin: const EdgeInsets.all(10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  leading: Icon(
                    isConnected ? Icons.bluetooth_connected : Icons.bluetooth_disabled,
                    color: isConnected ? Colors.blue : Colors.grey,
                  ),
                  title: Text(sensorViewModel.sensor.name),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      StreamBuilder<String>(
                        stream: sensorViewModel.batteryStatus,
                        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                          
                          if (sensorViewModel.sensor.isConnected && snapshot.hasData) {
                            return Text('${sensorViewModel.sensor.address} - ${snapshot.data}');
                          } 
                          return const Text('No bluetooth - 0%');
                        },
                      ),
                      StreamBuilder<int>(
                        stream: sensorViewModel.heartRate,
                        builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                          String display = 'HR:';

                          if (snapshot.hasData && isConnected) {
                            display ='HR: ${snapshot.data}';
                          } else if (snapshot.hasError) {
                            display ='${snapshot.error}';
                          }

                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(Icons.favorite, color: isConnected ? Colors.red : Colors.grey), 
                              Text("  $display"), 
                            ],
                          );
                          
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Align(
                            alignment: Alignment.centerLeft,
                            child: IconButton(
                              icon: Icon(isConnected? Icons.link: Icons.link_off, color: isConnected? Colors.green: Colors.grey),
                              onPressed: () async {
                                if (isConnected){
                                  sensorViewModel.stop();
                                  await sensorViewModel.disconnect();
                                  
                                } else {
                                  await sensorViewModel.connect();
                                }
                              },
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: StreamBuilder<bool>(
                              stream: sensorViewModel.isActive,
                              builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {

                                if (snapshot.hasData && snapshot.data!){
                                  return IconButton(
                                    icon: const Icon(Icons.play_arrow, color: Colors.green),
                                    onPressed: () {
                                      sensorViewModel.stop();
                                    },
                                  );
                                } 

                                return IconButton(
                                    icon: Icon(Icons.stop, color: isConnected? Colors.red: Colors.grey,),
                                    onPressed: () {
                                      sensorViewModel.start();
                                    },
                                  );
                                
                              
                              },
                            ),
                          ),
                          
                        ],
                      ),
                      
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}