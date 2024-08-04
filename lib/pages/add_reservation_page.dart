import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/reservation.dart';
import '../providers/reservation_provider.dart';

class AddReservationPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _customerNameController = TextEditingController();
  final _flightNumberController = TextEditingController();
  final _reservationNameController = TextEditingController();
  final _dateController = TextEditingController();

  AddReservationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final reservationProvider = Provider.of<ReservationProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Add Reservation'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _customerNameController,
                decoration: InputDecoration(labelText: 'Customer Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter customer name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _flightNumberController,
                decoration: InputDecoration(labelText: 'Flight Number'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter flight number';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _reservationNameController,
                decoration: InputDecoration(labelText: 'Reservation Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter reservation name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _dateController,
                decoration: InputDecoration(labelText: 'Date (YYYY-MM-DD)'),
                keyboardType: TextInputType.datetime,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter date';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final reservation = Reservation(
                      id: null,
                      customerName: _customerNameController.text,
                      flightNumber: _flightNumberController.text,
                      reservationName: _reservationNameController.text,
                      date: DateTime.parse(_dateController.text),
                    );
                    reservationProvider.addReservation(reservation);

                    Navigator.pop(context);
                  }
                },
                child: Text('Add Reservation'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
