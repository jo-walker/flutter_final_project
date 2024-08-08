import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../provider/airplane_provider.dart';
import '../providers/airplane_provider.dart';
import '../models/airplane.dart';

class AddAirplanePage extends StatefulWidget {
  @override
  _AddAirplanePageState createState() => _AddAirplanePageState();
}

class _AddAirplanePageState extends State<AddAirplanePage> {
  final _formKey = GlobalKey<FormState>();
  final _typeController = TextEditingController();
  final _passengerCountController = TextEditingController();
  final _maxSpeedController = TextEditingController();
  final _rangeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadFormData();
  }

  Future<void> _loadFormData() async {
    final prefs = await SharedPreferences.getInstance();
    _typeController.text = prefs.getString('type') ?? '';
    _passengerCountController.text = prefs.getString('passengerCount') ?? '';
    _maxSpeedController.text = prefs.getString('maxSpeed') ?? '';
    _rangeController.text = prefs.getString('range') ?? '';
  }

  Future<void> _saveFormData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('type', _typeController.text);
    await prefs.setString('passengerCount', _passengerCountController.text);
    await prefs.setString('maxSpeed', _maxSpeedController.text);
    await prefs.setString('range', _rangeController.text);
  }

  void _showSnackbar(String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    final airplaneProvider = Provider.of<AirplaneProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Add Airplane'),
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
                    final airplane = Airplane(
                      id: null,
                      type: _typeController.text,
                      passengerCount: int.parse(_passengerCountController.text),
                      maxSpeed: double.parse(_maxSpeedController.text),
                      range: double.parse(_rangeController.text),
                    );
                    airplaneProvider.addAirplane(airplane);
                    _saveFormData();
                    _showSnackbar('Airplane added successfully!');
                    Navigator.pop(context);
                  } else {
                    _showSnackbar('Please fill all fields correctly.');
                  }
                },
                child: Text('Add Airplane'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
