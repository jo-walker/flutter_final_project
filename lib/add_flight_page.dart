import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'app_localizations.dart';
import 'flight_repository.dart';
import 'flight.dart';
import 'app_localizations.dart';

/// A stateful widget that provides an interface for adding a flight.
///
/// The `AddFlightPage` allows users to enter details about a flight, such as the
/// departure city, destination city, departure time, and arrival time. These details
/// are saved securely using `FlutterSecureStorage` and can be submitted to add a new
/// flight to the list.
class AddFlightPage extends StatefulWidget {
  @override
  _AddFlightPageState createState() => _AddFlightPageState();
}

class _AddFlightPageState extends State<AddFlightPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _departureCityController = TextEditingController();
  final TextEditingController _destinationCityController = TextEditingController();
  final TextEditingController _departureTimeController = TextEditingController();
  final TextEditingController _arrivalTimeController = TextEditingController();
  final _storage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _loadSavedData(); // Load saved data when the page is initialized
  }

  /// Loads previously saved flight details from secure storage.
  ///
  /// This method is called during the initialization of the page. It populates
  /// the text fields with any saved data, if available.
  void _loadSavedData() async {
    _departureCityController.text = await _storage.read(key: 'departureCity') ?? '';
    _destinationCityController.text = await _storage.read(key: 'destinationCity') ?? '';
    _departureTimeController.text = await _storage.read(key: 'departureTime') ?? '';
    _arrivalTimeController.text = await _storage.read(key: 'arrivalTime') ?? '';
  }

  /// Saves the current flight details to secure storage.
  ///
  /// This method is called whenever the user modifies any of the text fields,
  /// ensuring that the data is preserved between sessions.
  void _saveData() {
    _storage.write(key: 'departureCity', value: _departureCityController.text);
    _storage.write(key: 'destinationCity', value: _destinationCityController.text);
    _storage.write(key: 'departureTime', value: _departureTimeController.text);
    _storage.write(key: 'arrivalTime', value: _arrivalTimeController.text);
  }

  @override
  Widget build(BuildContext context) {
    final flightRepo = Provider.of<FlightRepository>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.translate('add_flight')!,
          style: TextStyle(fontFamily: 'Lato', fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue,
        elevation: 5.0,
        actions: [
          IconButton(
            icon: Icon(Icons.info_outline),
            onPressed: () {
              _showInstructionsDialog(context);
            },
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.flight, size: 100, color: Colors.blue),
                SizedBox(height: 20.0),
                _buildTextFormField(
                  context,
                  controller: _departureCityController,
                  labelText: AppLocalizations.of(context)!.translate('departure_city'),
                ),
                SizedBox(height: 20.0),
                _buildTextFormField(
                  context,
                  controller: _destinationCityController,
                  labelText: AppLocalizations.of(context)!.translate('destination_city'),
                ),
                SizedBox(height: 20.0),
                _buildTextFormField(
                  context,
                  controller: _departureTimeController,
                  labelText: AppLocalizations.of(context)!.translate('departure_time'),
                ),
                SizedBox(height: 20.0),
                _buildTextFormField(
                  context,
                  controller: _arrivalTimeController,
                  labelText: AppLocalizations.of(context)!.translate('arrival_time'),
                ),
                SizedBox(height: 20.0),
                _buildActionButton(
                  context,
                  text: AppLocalizations.of(context)!.translate('add_flight')!,
                  color: Colors.blue,
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _saveData();  // Save data when the flight is added
                      final newFlight = Flight(
                        departureCity: _departureCityController.text,
                        destinationCity: _destinationCityController.text,
                        departureTime: _departureTimeController.text,
                        arrivalTime: _arrivalTimeController.text,
                      );
                      flightRepo.addFlight(newFlight);
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(AppLocalizations.of(context)!.translate('flight_added_successfully')!, style: TextStyle(fontFamily: 'Lato')))
                      );
                      Navigator.pop(context); // Return to previous screen
                    } else {
                      _showInputErrorDialog(context);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Builds a text form field for user input.
  ///
  /// This method takes the [context], a [TextEditingController] for the field, and
  /// the [labelText] to be displayed as a placeholder.
  ///
  /// [context] is the BuildContext.
  /// [controller] is the TextEditingController for the text field.
  /// [labelText] is the label text for the field.
  Widget _buildTextFormField(BuildContext context, {
    required TextEditingController controller,
    required String? labelText,
  }) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: 500),  // Increased the width
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: TextStyle(fontFamily: 'Lato', color: Color(0xFF333333)),
          filled: true,
          fillColor: Colors.grey[200],
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          contentPadding: EdgeInsets.all(16.0),  // Increased the padding
        ),
        onChanged: (text) => _saveData(),  // Save data whenever it changes
        validator: (value) {
          if (value == null || value.isEmpty) {
            return AppLocalizations.of(context)!.translate('input_error');
          }
          return null;
        },
      ),
    );
  }

  /// Builds an action button for the form.
  ///
  /// This method takes the [context], the button [text], [color], and the [onPressed] callback.
  ///
  /// [context] is the BuildContext.
  /// [text] is the text to display on the button.
  /// [color] is the color of the button.
  /// [onPressed] is the callback function to be executed when the button is pressed.
  Widget _buildActionButton(BuildContext context, {
    required String text,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return ConstrainedBox(
      constraints: BoxConstraints.tightFor(width: 220, height: 60),  // Increased button size
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(text, style: TextStyle(fontFamily: 'Lato', fontWeight: FontWeight.bold)),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
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
          content: Text(
            '1. ${AppLocalizations.of(context)!.translate('enter_flight_details')}.\n'
                '2. ${AppLocalizations.of(context)!.translate('press_add_flight_button')}.\n'
                '3. ${AppLocalizations.of(context)!.translate('tap_flight_update_or_delete')}.\n'
                '4. ${AppLocalizations.of(context)!.translate('use_plus_button')}',
            style: TextStyle(fontFamily: 'Lato'),
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

  /// Displays an error dialog when the user inputs invalid data.
  ///
  /// This method is called when the user submits the form with invalid or incomplete data.
  void _showInputErrorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog          (
          title: Text(
            AppLocalizations.of(context)!.translate('input_error')!,
            style: TextStyle(color: Colors.red, fontFamily: 'Lato', fontWeight: FontWeight.bold),
          ),
          content: Text(
            AppLocalizations.of(context)!.translate('enter_flight_details_format')!,
            style: TextStyle(fontFamily: 'Lato'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('OK', style: TextStyle(fontFamily: 'Lato')),
            ),
          ],
        );
      },
    );
  }
}

