import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/reservation.dart';
import '../providers/reservation_provider.dart';
import 'edit_reservation_page.dart';

class ReservationDetailPage extends StatelessWidget {
  final Reservation reservation;

  ReservationDetailPage({Key? key, required this.reservation}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final reservationProvider = Provider.of<ReservationProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Reservation Details'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Delete Reservation'),
                    content: Text('Are you sure you want to delete this reservation?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          reservationProvider.deleteReservation(reservation);
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        },
                        child: Text('Delete'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Customer Name: ${reservation.customerName}'),
            Text('Flight Number: ${reservation.flightNumber}'),
            Text('Reservation Name: ${reservation.reservationName}'),
            Text('Date: ${reservation.date.toLocal()}'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditReservationPage(reservation: reservation),
                  ),
                );
              },
              child: Text('Edit Reservation'),
            ),
          ],
        ),
      ),
    );
  }
}
