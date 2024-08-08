import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/reservation.dart';
import '../providers/reservation_provider.dart';
import '../providers/encrypted_preferences_provider.dart';
import '../l10n/app_localizations.dart';

class AddReservationPage extends StatefulWidget {
  AddReservationPage({Key? key}) : super(key: key);

  @override
  _AddReservationPageState createState() => _AddReservationPageState();
}

class _AddReservationPageState extends State<AddReservationPage> {
  final _formKey = GlobalKey<FormState>();

  final _customerNameController = TextEditingController();
  final _flightNumberController = TextEditingController();
  final _reservationNameController = TextEditingController();
  final _dateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadLastReservationData();
  }

  Future<void> _loadLastReservationData() async {
    final preferencesProvider = EncryptedPreferencesProvider();
    final lastCustomerName = await preferencesProvider.getData('last_customer_name');
    final lastFlightNumber = await preferencesProvider.getData('last_flight_number');
    final lastReservationName = await preferencesProvider.getData('last_reservation_name');
    final lastDate = await preferencesProvider.getData('last_date');

    if (lastCustomerName != null) _customerNameController.text = lastCustomerName;
    if (lastFlightNumber != null) _flightNumberController.text = lastFlightNumber;
    if (lastReservationName != null) _reservationNameController.text = lastReservationName;
    if (lastDate != null) _dateController.text = lastDate;
  }

  @override
  Widget build(BuildContext context) {
    final reservationProvider = Provider.of<ReservationProvider>(context);
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

                      final preferencesProvider = EncryptedPreferencesProvider();
                      await preferencesProvider.saveData('last_customer_name', _customerNameController.text);
                      await preferencesProvider.saveData('last_flight_number', _flightNumberController.text);
                      await preferencesProvider.saveData('last_reservation_name', _reservationNameController.text);
                      await preferencesProvider.saveData('last_date', _dateController.text);

                      Navigator.pop(context);
                    }
                  },
                  child: Text(localizations?.translate('add') ?? 'Add'),
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
