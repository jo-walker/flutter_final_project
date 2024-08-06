import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/reservation.dart';
import '../providers/reservation_provider.dart';
import '../providers/encrypted_preferences_provider.dart';
import '../l10n/app_localizations.dart';

/// The `AddReservationPage` class is responsible for allowing users to add a new reservation.
class AddReservationPage extends StatelessWidget {
  /// A global key for the form.
  final _formKey = GlobalKey<FormState>();

  /// Controller for the customer name text field.
  final _customerNameController = TextEditingController();

  /// Controller for the flight number text field.
  final _flightNumberController = TextEditingController();

  /// Controller for the reservation name text field.
  final _reservationNameController = TextEditingController();

  /// Controller for the date text field.
  final _dateController = TextEditingController();

  /// Constructs an `AddReservationPage`.
  AddReservationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final reservationProvider = Provider.of<ReservationProvider>(context);
    final preferencesProvider = EncryptedPreferencesProvider();
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations?.translate('add_reservation') ?? 'Add Reservation'),
        actions: [
          IconButton(
            icon: Icon(Icons.info),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Instructions'),
                  content: Text('Fill in the details and click Add to add a reservation.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text('OK'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _customerNameController,
                decoration: InputDecoration(labelText: localizations?.translate('customer_name') ?? 'Customer Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return localizations?.translate('customer_name') ?? 'Please enter customer name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _flightNumberController,
                decoration: InputDecoration(labelText: localizations?.translate('flight_number') ?? 'Flight Number'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return localizations?.translate('flight_number') ?? 'Please enter flight number';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _reservationNameController,
                decoration: InputDecoration(labelText: localizations?.translate('reservation_name') ?? 'Reservation Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return localizations?.translate('reservation_name') ?? 'Please enter reservation name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _dateController,
                decoration: InputDecoration(labelText: localizations?.translate('date') ?? 'Date (YYYY-MM-DD)'),
                keyboardType: TextInputType.datetime,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return localizations?.translate('date') ?? 'Please enter date';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final reservation = Reservation(
                      id: null,
                      customerName: _customerNameController.text,
                      flightNumber: _flightNumberController.text,
                      reservationName: _reservationNameController.text,
                      date: DateTime.parse(_dateController.text),
                    );
                    reservationProvider.addReservation(reservation);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Reservation Added')),
                    );

                    await preferencesProvider.saveData('last_reservation', _reservationNameController.text);

                    Navigator.pop(context);
                  }
                },
                child: Text(localizations?.translate('add') ?? 'Add'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
