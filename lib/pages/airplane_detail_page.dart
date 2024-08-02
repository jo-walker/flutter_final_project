import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/airplane.dart';
import '../provider/airplane_provider.dart';
import '../providers/airplane_provider.dart';
import 'edit_airplane_page.dart';

class AirplaneDetailPage extends StatelessWidget {
  final Airplane airplane;

  AirplaneDetailPage({required this.airplane});

  @override
  Widget build(BuildContext context) {
    final airplaneProvider = Provider.of<AirplaneProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Airplane Details'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              airplaneProvider.deleteAirplane(airplane.id!);
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Type: ${airplane.type}'),
            Text('Passenger Count: ${airplane.passengerCount}'),
            Text('Max Speed: ${airplane.maxSpeed}'),
            Text('Range: ${airplane.range}'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditAirplanePage(airplane: airplane),
                  ),
                );
              },
              child: Text('Edit Airplane'),
            ),
          ],
        ),
      ),
    );
  }
}
