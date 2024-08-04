import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/reservation.dart';
import '../providers/reservation_provider.dart';
import 'reservation_detail_page.dart';

class ReservationListPage extends StatelessWidget {
  ReservationListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final reservationProvider = Provider.of<ReservationProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Reservation List'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: reservationProvider.reservations.length,
              itemBuilder: (context, index) {
                final reservation = reservationProvider.reservations[index];
                return ListTile(
                  title: Text(reservation.reservationName),
                  subtitle: Text('Customer: ${reservation.customerName}'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ReservationDetailPage(reservation: reservation),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/add');
              },

              child: Text('Add Reservation'),
            ),
          ),
        ],
      ),
    );
  }
}
