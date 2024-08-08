import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'flight_repository.dart';
import 'flight.dart';
import 'app_localizations.dart';

/// A stateful widget that provides an interface for updating a flight.
///
/// The `UpdateFlightPage` allows users to modify details about a flight, such as the
/// departure city, destination city, departure time, and arrival time. These details
/// are saved securely using `FlutterSecureStorage`.
class UpdateFlightPage extends StatefulWidget {
  final Flight? flight;

  /// Creates an instance of `UpdateFlightPage`.
  ///
  /// [flight] is the `Flight` object containing the details of the flight to be updated.
  UpdateFlightPage({required this.flight});

  @override
  _UpdateFlightPageState createState() => _UpdateFlightPageState();
}

class _UpdateFlightPageState extends State<UpdateFlightPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _departureCityController;
  late TextEditingController _destinationCityController;
  late TextEditingController _departureTimeController;
  late TextEditingController _arrivalTimeController;
  final _storage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();

    _departureCityController = TextEditingController(text: widget.flight?.departureCity ?? '');
    _destinationCityController = TextEditingController(text: widget.flight?.destinationCity ?? '');
    _departureTimeController = TextEditingController(text: widget.flight?.departureTime ?? '');
    _arrivalTimeController = TextEditingController(text: widget.flight?.arrivalTime ?? '');
  }

  /// Saves the current flight details to secure storage.
  ///
  /// This method is called whenever the user modifies any of the text fields,
  /// ensuring that the data is preserved between sessions.
  void _saveData() async {
    await _storage.write(key: 'departureCity', value: _departureCityController.text);
    await _storage.write(key: 'destinationCity', value: _destinationCityController.text);
    await _storage.write(key: 'departureTime', value: _departureTimeController.text);
    await _storage.write(key: 'arrivalTime', value: _arrivalTimeController.text);
  }

  @override
  Widget build(BuildContext context) {
    final flightRepo = Provider.of<FlightRepository>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.translate('update_flight')!,
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
                  text: AppLocalizations.of(context)!.translate('update_flight')!,
                  color: Colors.blue,
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final updatedFlight = Flight(
                        id: widget.flight?.id,
                        departureCity: _departureCityController.text.isNotEmpty ? _departureCityController.text : '',
                        destinationCity: _destinationCityController.text.isNotEmpty ? _destinationCityController.text : '',
                        departureTime: _departureTimeController.text.isNotEmpty ? _departureTimeController.text : '',
                        arrivalTime: _arrivalTimeController.text.isNotEmpty ? _arrivalTimeController.text : '',
                      );
                      flightRepo.updateFlight(updatedFlight);
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(AppLocalizations.of(context)!.translate('flight_updated_successfully')!, style: TextStyle(fontFamily: 'Lato')))
                      );
                      Navigator.pop(context); // Return to previous screen
                    } else {
                      _showInputErrorDialog(context);
                    }
                  },
                ),
                SizedBox(height: 10.0),
                _buildActionButton(
                  context,
                  text: AppLocalizations.of(context)!.translate('delete_flight')!,
                  color: Colors.red,
                  onPressed: () {
                    _showDeleteDialog(context);
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
        onChanged: (text) => _saveData(),
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
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  '1. ${AppLocalizations.of(context)!.translate('instructions_enter_departure_city')}',
                  style: TextStyle(fontFamily: 'Lato'),
                ),
                SizedBox(height: 8.0),
                Text(
                  '2. ${AppLocalizations.of(context)!.translate('instructions_enter_destination_city')}',
                  style: TextStyle(fontFamily: 'Lato'),
                ),
                SizedBox(height: 8.0),
                Text(
                  '3. ${AppLocalizations.of(context)!.translate('instructions_enter_departure_time')}',
                  style: TextStyle(fontFamily: 'Lato'),
                ),
                SizedBox(height: 8.0),
                Text(
                  '4. ${AppLocalizations.of(context)!.translate('instructions_enter_arrival_time')}',
                  style: TextStyle(fontFamily: 'Lato'),
                ),
                SizedBox(height: 8.0),
                Text(
                  '5. ${AppLocalizations.of(context)!.translate('instructions_press_update_flight')}',
                  style: TextStyle(fontFamily: 'Lato'),
                ),
                SizedBox(height: 8.0),
                Text(
                  '6. ${AppLocalizations.of(context)!.translate('instructions_press_delete_flight')}',
                  style: TextStyle(fontFamily: 'Lato'),
                ),
                SizedBox(height: 8.0),
                Text(
                  '7. ${AppLocalizations.of(context)!.translate('instructions_return_without_changes')}',
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

  /// Displays an error dialog when the user inputs invalid data.
  ///
  /// This method is called when the user submits the form with invalid or incomplete data.
  void _showInputErrorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
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

  /// Displays a confirmation dialog to delete the current flight.
  ///
  /// This method is called when the user presses the delete button on the form.
  void _showDeleteDialog(BuildContext context) {
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
                int id = widget.flight?.id ?? 0; // Ensure id is non-null
                Provider.of<FlightRepository>(context, listen: false).deleteFlight(id);
                Navigator.of(context).pop(); // Close the dialog
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(AppLocalizations.of(context)!.translate('flight_deleted_successfully')!, style: TextStyle(fontFamily: 'Lato'))),
                );
                Navigator.pop(context); // Return to previous screen
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
}

