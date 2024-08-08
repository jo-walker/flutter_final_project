import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import 'app_localizations.dart';
import '../models/airplane.dart';
import '../provider/airplane_provider.dart';
import 'add_airplane_page.dart';
import 'airplane_detail_page.dart';
import '../pages/app_localizations.dart';  // Make sure to import AppLocalizations



class AirplaneListPage extends StatelessWidget {
  void _showAddAirplaneDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Airplane'),
          content: Text(
              '1. Use the "Add Airplane" button to add a new airplane.\n'
                  '2. Tap on an airplane in the list to view details.\n'
                  '3. Use the "Edit" option to update airplane details.\n'
                  '4. You can also remove airplanes from the list.'
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddAirplanePage()),
                );
              },
              child: Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('No'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final airplaneProvider = Provider.of<AirplaneProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate('title') ?? 'Airplane List'),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: (String languageCode) {
              MyApp.setLocale(context, Locale(languageCode));
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: 'en',
                child: Text('English'),
              ),
              PopupMenuItem<String>(
                value: 'es',
                child: Text('Spanish'),
              ),
              // Add more languages as needed
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: airplaneProvider.airplanes.length,
              itemBuilder: (context, index) {
                final airplane = airplaneProvider.airplanes[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  elevation: 5,
                  child: ListTile(
                    leading: Image.asset(
                      'assets/images/airplane.png', // Use an appropriate image file name
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                    title: Text('${airplane.type}', style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(AppLocalizations.of(context).translate('passengers') ?? 'Passengers: ${airplane.passengerCount}'),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.redAccent),
                      onPressed: () {
                        _showDeleteConfirmationDialog(context, airplane, airplaneProvider);
                      },
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AirplaneDetailPage(airplane: airplane),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                _showAddAirplaneDialog(context);
              },
              child: Text(AppLocalizations.of(context).translate('add_airplane') ?? 'Add Airplane'),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, Airplane airplane, AirplaneProvider airplaneProvider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context).translate('delete_airplane') ?? 'Delete Airplane'),
          content: Text(AppLocalizations.of(context).translate('delete_confirm') ?? 'Are you sure you want to delete ${airplane.type}?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text(AppLocalizations.of(context).translate('cancel') ?? 'Cancel'),
            ),
            TextButton(
              onPressed: () async {
                if (airplane.id != null) {
                  await airplaneProvider.deleteAirplane(airplane.id!);
                  Navigator.of(context).pop(); // Close the dialog
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${airplane.type} deleted')),
                  );
                } else {
                  Navigator.of(context).pop(); // Close the dialog
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to delete ${airplane.type}')),
                  );
                }
              },
              child: Text(AppLocalizations.of(context).translate('delete') ?? 'Delete'),
            ),
          ],
        );
      },
    );
  }
}



class _MyAppState {
  void changeLanguage(Locale newLocale) {}
}
