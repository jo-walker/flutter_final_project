import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/reservation.dart';
import '../providers/reservation_provider.dart';
import '../l10n/app_localizations.dart';

class EditReservationPage extends StatefulWidget {
  final Reservation reservation;

  EditReservationPage({Key? key, required this.reservation}) : super(key: key);

  @override
  _EditReservationPageState createState() => _EditReservationPageState();
}

class _EditReservationPageState extends State<EditReservationPage> {
  final _formKey = GlobalKey<FormState>();

  final _customerNameController = TextEditingController();
  final _flightNumberController = TextEditingController();
  final _reservationNameController = TextEditingController();
  final _dateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _customerNameController.text = widget.reservation.customerName;
    _flightNumberController.text = widget.reservation.flightNumber;
    _reservationNameController.text = widget.reservation.reservationName;
    _dateController.text = widget.reservation.date.toIso8601String().split('T').first; // Format date to YYYY-MM-DD
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _customerNameController,
                  decoration: InputDecoration(
                    labelText: localizations?.translate('customer_name') ?? 'Customer Name',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.blue[50],
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return localizations?.translate('customer_name') ?? 'Please enter customer name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _flightNumberController,
                  decoration: InputDecoration(
                    labelText: localizations?.translate('flight_number') ?? 'Flight Number',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.blue[50],
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return localizations?.translate('flight_number') ?? 'Please enter flight number';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _reservationNameController,
                  decoration: InputDecoration(
                    labelText: localizations?.translate('reservation_name') ?? 'Reservation Name',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.blue[50],
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return localizations?.translate('reservation_name') ?? 'Please enter reservation name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _dateController,
                  decoration: InputDecoration(
                    labelText: localizations?.translate('date') ?? 'Date (YYYY-MM-DD)',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.blue[50],
                  ),
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
                        id: widget.reservation.id,
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
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue, // Use backgroundColor instead of primary
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    textStyle: TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
