import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'flight_repository.dart'; // Adjust import as per your project structure
import 'flight.dart'; // Adjust import as per your project structure

class UpdateFlightPage extends StatefulWidget {
  final Flight flight;

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

  @override
  void initState() {
    super.initState();
    _departureCityController = TextEditingController(text: widget.flight.departureCity);
    _destinationCityController = TextEditingController(text: widget.flight.destinationCity);
    _departureTimeController = TextEditingController(text: widget.flight.departureTime);
    _arrivalTimeController = TextEditingController(text: widget.flight.arrivalTime);
  }

  @override
  Widget build(BuildContext context) {
    final flightRepo = Provider.of<FlightRepository>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Update Flight'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _departureCityController,
                decoration: InputDecoration(labelText: 'Departure City'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter departure city';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _destinationCityController,
                decoration: InputDecoration(labelText: 'Destination City'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter destination city';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _departureTimeController,
                decoration: InputDecoration(labelText: 'Departure Time'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter departure time';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _arrivalTimeController,
                decoration: InputDecoration(labelText: 'Arrival Time'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter arrival time';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final updatedFlight = Flight(
                      id: widget.flight.id,
                      departureCity: _departureCityController.text,
                      destinationCity: _destinationCityController.text,
                      departureTime: _departureTimeController.text,
                      arrivalTime: _arrivalTimeController.text,
                    );
                    flightRepo.updateFlight(updatedFlight);
                    Navigator.pop(context); // Return to previous screen
                  }
                },
                child: Text('Update Flight'),
              ),
              ElevatedButton(
                onPressed: () {
                  flightRepo.deleteFlight(widget.flight.id!);
                  Navigator.pop(context); // Return to previous screen
                },
                child: Text('Delete Flight'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
