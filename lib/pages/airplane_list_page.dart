import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/airplane.dart';
import '../provider/airplane_provider.dart';
import '../providers/airplane_provider.dart';
import 'add_airplane_page.dart';
import 'airplane_detail_page.dart';
import 'edit_airplane_page.dart';

class AirplaneListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final airplaneProvider = Provider.of<AirplaneProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Airplane List'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: airplaneProvider.airplanes.length,
              itemBuilder: (context, index) {
                final airplane = airplaneProvider.airplanes[index];
                return ListTile(
                  title: Text('${airplane.type}'),
                  subtitle: Text('Passengers: ${airplane.passengerCount}'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AirplaneDetailPage(airplane: airplane),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddAirplanePage()),
                );
              },
              child: Text('Add Airplane'),
            ),
          ),
        ],
      ),
    );
  }
}
