import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/airplane_provider.dart';

import '../models/airplane.dart';
import '../providers/airplane_provider.dart';

class EditAirplanePage extends StatelessWidget {
  final Airplane airplane;
  final _formKey = GlobalKey<FormState>();
  final _typeController = TextEditingController();
  final _passengerCountController = TextEditingController();
  final _maxSpeedController = TextEditingController();
  final _rangeController = TextEditingController();

  EditAirplanePage({required this.airplane}) {
    _typeController.text = airplane.type;
    _passengerCountController.text = airplane.passengerCount.toString();
    _maxSpeedController.text = airplane.maxSpeed.toString();
    _rangeController.text = airplane.range.toString();
  }

  @override
  Widget build(BuildContext context) {
    final airplaneProvider = Provider.of<AirplaneProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Airplane'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _typeController,
                decoration: InputDecoration(labelText: 'Type'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter airplane type';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passengerCountController,
                decoration: InputDecoration(labelText: 'Passenger Count'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter passenger count';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _maxSpeedController,
                decoration: InputDecoration(labelText: 'Max Speed'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter max speed';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _rangeController,
                decoration: InputDecoration(labelText: 'Range'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter range';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final updatedAirplane = Airplane(
                      id: airplane.id,
                      type: _typeController.text,
                      passengerCount: int.parse(_passengerCountController.text),
                      maxSpeed: double.parse(_maxSpeedController.text),
                      range: double.parse(_rangeController.text),
                    );
                    airplaneProvider.updateAirplane(updatedAirplane);
                    Navigator.pop(context);
                  }
                },
                child: Text('Update Airplane'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
