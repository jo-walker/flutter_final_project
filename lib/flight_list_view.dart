import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'flight.dart'; // Assuming Flight model class is defined
import 'flight_repository.dart'; // Assuming FlightRepository is defined

class FlightListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flight List'),
      ),
      body: FutureBuilder<List<Flight>?>(
        future: Provider.of<FlightRepository>(context).getFlights(),
        builder: (context, AsyncSnapshot<List<Flight>?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error fetching flights'));
          } else if (snapshot.data == null || snapshot.data!.isEmpty) {
            return Center(child: Text('No flights available'));
          } else {
            var flights = snapshot.data!;
            return ListView.builder(
              itemCount: flights.length,
              itemBuilder: (context, index) {
                var flight = flights[index];
                return ListTile(
                  title: Text('${flight.departureCity} - ${flight.destinationCity}'),
                  subtitle: Text('${flight.departureTime} - ${flight.arrivalTime}'),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      if (flight.id != null) {
                        _deleteFlight(context, flight.id!);
                      } else {
                        // Handle the case where flight.id is null, if necessary
                      }
                    },
                  ),
                  onTap: () {
                    _navigateToUpdateFlight(context, flight);
                  },
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _navigateToAddFlight(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _navigateToAddFlight(BuildContext context) {
    Navigator.of(context).pushNamed('/add_flight');
  }

  void _navigateToUpdateFlight(BuildContext context, Flight flight) {
    Navigator.of(context).pushNamed('/update_flight', arguments: flight);
  }

  void _deleteFlight(BuildContext context, int flightId) {
    Provider.of<FlightRepository>(context, listen: false).deleteFlight(flightId);
  }
}
