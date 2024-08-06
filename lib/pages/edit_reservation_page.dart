import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/reservation.dart';
import '../providers/reservation_provider.dart';
import '../l10n/app_localizations.dart';

/// The `EditReservationPage` class is responsible for allowing users to edit an existing reservation.
class EditReservationPage extends StatelessWidget {
  /// The reservation being edited.
  final Reservation reservation;

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

  /// Constructs an `EditReservationPage`.
  ///
  /// Sets the initial values of the text field controllers to the values of the given reservation.
  EditReservationPage({Key? key, required this.reservation}) : super(key: key) {
    _customerNameController.text = reservation.customerName;
    _flightNumberController.text = reservation.flightNumber;
    _reservationNameController.text = reservation.reservationName;
    _dateController.text = reservation.date.toIso8601String().split('T').first; // Format date to YYYY-MM-DD
  }

  @override
  Widget build(BuildContext context) {
    final reservationProvider = Provider.of<ReservationProvider>(context);
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations?.translate('edit_reservation') ?? 'Edit Reservation'),
        actions: [
          IconButton(
            icon: Icon(Icons.info),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Instructions'),
                  content: Text('Edit the details and click Update to update the reservation.'),
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
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final updatedReservation = Reservation(
                      id: reservation.id,
                      customerName: _customerNameController.text,
                      flightNumber: _flightNumberController.text,
                      reservationName: _reservationNameController.text,
                      date: DateTime.parse(_dateController.text),
                    );
                    reservationProvider.updateReservation(updatedReservation);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Reservation Updated')),
                    );
                    Navigator.pop(context);
                  }
                },
                child: Text(localizations?.translate('update_reservation') ?? 'Update Reservation'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
