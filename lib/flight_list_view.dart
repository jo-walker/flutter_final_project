import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'flight_repository.dart';
import 'flight.dart';
import 'update_flight_page.dart';
import 'add_flight_page.dart';
import 'app_localizations.dart';
import 'main1.dart';

/// A stateful widget that displays a list of flights.
///
/// The `FlightListView` provides an interface for users to view a list of flights,
/// search for specific flights, and navigate to add or update flight details.
class FlightListView extends StatefulWidget {
  @override
  _FlightListViewState createState() => _FlightListViewState();
}

class _FlightListViewState extends State<FlightListView> {
  final TextEditingController _itemController = TextEditingController();
  final _storage = FlutterSecureStorage();
  String _searchQuery = ''; // Add this state variable to manage search input

  @override
  void initState() {
    super.initState();
    _loadSavedData();
  }

  /// Loads previously saved search query from secure storage.
  ///
  /// This method is called during the initialization of the page. It populates
  /// the search field with any saved data, if available.
  void _loadSavedData() async {
    String? savedText = await _storage.read(key: 'flightDetails');
    if (savedText != null) {
      setState(() {
        _itemController.text = savedText;
      });
    }
  }

  /// Saves the current search query to secure storage.
  ///
  /// This method is called whenever the user modifies the search input field,
  /// ensuring that the search query is preserved between sessions.
  void _saveData(String text) async {
    await _storage.write(key: 'flightDetails', value: text);
  }

  /// Clears the saved search query from secure storage.
  ///
  /// This method is typically called after a flight is deleted, ensuring that
  /// the search query is reset.
  void _clearSavedData() async {
    await _storage.delete(key: 'flightDetails');
  }

  @override
  Widget build(BuildContext context) {
    final flightRepo = Provider.of<FlightRepository>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.translate('title')!,
          style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Lato'),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: Icon(Icons.language),
            onPressed: () {
              _showLanguageDialog(context);
            },
          ),
          IconButton(
            icon: Icon(Icons.info_outline),
            onPressed: () {
              _showInstructionsDialog(context);
            },
          ),
        ],
      ),
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _itemController,
                    decoration: InputDecoration(
                      hintText: AppLocalizations.of(context)!.translate('enter_flight_details'),
                      hintStyle: TextStyle(fontFamily: 'Lato', color: Colors.grey),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onChanged: (text) {
                      setState(() {
                        _searchQuery = text; // Update the search query on text change
                      });
                      _saveData(text);
                    },
                  ),
                ),
                SizedBox(width: 8.0),
                ElevatedButton(
                  onPressed: () {
                    _navigateToAddFlight(context); // Navigate to AddFlightPage
                  },
                  child: Text(
                    AppLocalizations.of(context)!.translate('add_flight')!,
                    style: TextStyle(fontFamily: 'Lato', fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            Expanded(
              child: FutureBuilder<List<Flight>?>(
                future: flightRepo.getFlights(),
                builder: (context, AsyncSnapshot<List<Flight>?> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        AppLocalizations.of(context)!.translate('error_fetching_flights')!,
                        style: TextStyle(color: Colors.red, fontSize: 18, fontFamily: 'Lato'),
                      ),
                    );
                  } else if (snapshot.data == null || snapshot.data!.isEmpty) {
                    return Center(
                      child: Text(
                        AppLocalizations.of(context)!.translate('no_flights_available')!,
                        style: TextStyle(fontSize: 18, color: Colors.grey, fontFamily: 'Lato'),
                      ),
                    );
                  } else {
                    var flights = snapshot.data!;
                    // Filter flights based on the search query
                    var filteredFlights = flights.where((flight) {
                      return flight.departureCity.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                          flight.destinationCity.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                          flight.departureTime.contains(_searchQuery) ||
                          flight.arrivalTime.contains(_searchQuery);
                    }).toList();

                    return ListView.builder(
                      itemCount: filteredFlights.length,
                      itemBuilder: (context, index) {
                        var flight = filteredFlights[index];
                        return Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          child: ListTile(
                            leading: Icon(Icons.flight, color: Colors.blue, size: 30),
                            title: Text(
                              '${flight.departureCity} - ${flight.destinationCity}',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Lato'),
                            ),
                            subtitle: Text(
                              '${flight.departureTime} - ${flight.arrivalTime}',
                              style: TextStyle(fontSize: 16, fontFamily: 'Lato'),
                            ),
                            onTap: () {
                              _navigateToUpdateFlight(context, flight);
                            },
                            trailing: IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                _showDeleteDialog(context, flight.id!);
                              },
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _navigateToAddFlight(context);
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }

  /// Navigates to the `UpdateFlightPage` to update the selected flight's details.
  ///
  /// [context] is the BuildContext.
  /// [flight] is the `Flight` object containing the details of the flight to be updated.
  void _navigateToUpdateFlight(BuildContext context, Flight flight) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => UpdateFlightPage(flight: flight),
      ),
    );
  }

  /// Navigates to the `AddFlightPage` to add a new flight.
  ///
  /// [context] is the BuildContext.
  void _navigateToAddFlight(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddFlightPage(),
      ),
    );
  }

  /// Displays an instructions dialog to the user.
  ///
  /// This method is called when the user presses the information icon in the app bar.
  void _showInstructionsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            AppLocalizations.of(context)!.translate('instructions')!,
            style: TextStyle(fontFamily: 'Lato', fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  AppLocalizations.of(context)!.translate('instructions_enter_flight_details')!,
                  style: TextStyle(fontFamily: 'Lato'),
                ),
                SizedBox(height: 8.0),
                Text(
                  AppLocalizations.of(context)!.translate('instructions_add_flight')!,
                  style: TextStyle(fontFamily: 'Lato'),
                ),
                SizedBox(height: 8.0),
                Text(
                  AppLocalizations.of(context)!.translate('instructions_view_flights')!,
                  style: TextStyle(fontFamily: 'Lato'),
                ),
                SizedBox(height: 8.0),
                Text(
                  AppLocalizations.of(context)!.translate('instructions_edit_flight')!,
                  style: TextStyle(fontFamily: 'Lato'),
                ),
                SizedBox(height: 8.0),
                Text(
                  AppLocalizations.of(context)!.translate('instructions_delete_flight')!,
                  style: TextStyle(fontFamily: 'Lato'),
                ),
                SizedBox(height: 8.0),
                Text(
                  AppLocalizations.of(context)!.translate('instructions_switch_language')!,
                  style: TextStyle(fontFamily: 'Lato'),
                ),
                SizedBox(height: 8.0),
                Text(
                  AppLocalizations.of(context)!.translate('instructions_view_instructions')!,
                  style: TextStyle(fontFamily: 'Lato'),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text(AppLocalizations.of(context)!.translate('close')!, style: TextStyle(fontFamily: 'Lato')),
            ),
          ],
        );
      },
    );
  }

  /// Displays a confirmation dialog to delete a flight.
  ///
  /// This method is called when the user presses the delete icon on a flight in the list.
  ///
  /// [context] is the BuildContext.
  /// [flightId] is the ID of the flight to be deleted.
  void _showDeleteDialog(BuildContext context, int flightId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            AppLocalizations.of(context)!.translate('delete_flight')!,
            style: TextStyle(color: Colors.red, fontFamily: 'Lato', fontWeight: FontWeight.bold),
          ),
          content: Text(
            AppLocalizations.of(context)!.translate('delete_confirmation')!,
            style: TextStyle(fontFamily: 'Lato'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text(AppLocalizations.of(context)!.translate('cancel')!, style: TextStyle(fontFamily: 'Lato')),
            ),
            TextButton(
              onPressed: () {
                Provider.of<FlightRepository>(context, listen: false).deleteFlight(flightId);
                _clearSavedData(); // Clear saved data after deletion
                Navigator.of(context).pop(); // Close the dialog
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      AppLocalizations.of(context)!.translate('flight_deleted_successfully')!,
                      style: TextStyle(fontFamily: 'Lato'),
                    ),
                  ),
                );
                setState(() {});
              },
              child: Text(
                AppLocalizations.of(context)!.translate('delete')!,
                style: TextStyle(color: Colors.red, fontFamily: 'Lato', fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }

  /// Displays a language selection dialog to the user.
  ///
  /// This method is called when the user presses the language icon in the app bar.
  ///
  /// [context] is the BuildContext.
  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            AppLocalizations.of(context)!.translate('choose_language')!,
            style: TextStyle(fontFamily: 'Lato', fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                title: Text('English', style: TextStyle(fontFamily: 'Lato')),
                onTap: () {
                  MyApp.setLocale(context, Locale('en', 'US'));
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: Text('Français', style: TextStyle(fontFamily: 'Lato')),
                onTap: () {
                  MyApp.setLocale(context, Locale('fr', 'FR'));
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

