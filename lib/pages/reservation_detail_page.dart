import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/reservation.dart';
import '../providers/reservation_provider.dart';
import 'edit_reservation_page.dart';
import '../l10n/app_localizations.dart';

class ReservationDetailPage extends StatelessWidget {
  final Reservation reservation;

  ReservationDetailPage({Key? key, required this.reservation}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final reservationProvider = Provider.of<ReservationProvider>(context);
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations?.translate('reservation_details') ?? 'Reservation Details'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text(localizations?.translate('delete') ?? 'Delete Reservation'),
                    content: Text(localizations?.translate('delete_confirmation') ?? 'Are you sure you want to delete this reservation?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(localizations?.translate('cancel') ?? 'Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          reservationProvider.deleteReservation(reservation);
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        },
                        child: Text(localizations?.translate('delete') ?? 'Delete'),
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
        child: Card(
          color: Colors.blue[50],
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${localizations?.translate('customer_name') ?? 'Customer Name'}: ${reservation.customerName}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  '${localizations?.translate('flight_number') ?? 'Flight Number'}: ${reservation.flightNumber}',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 10),
                Text(
                  '${localizations?.translate('reservation_name') ?? 'Reservation Name'}: ${reservation.reservationName}',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 10),
                Text(
                  '${localizations?.translate('date') ?? 'Date'}: ${reservation.date.toLocal()}',
                  style: TextStyle(fontSize: 16),
                ),
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
                  child: Text(localizations?.translate('edit') ?? 'Edit'),
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
