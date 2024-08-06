import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/reservation.dart';
import '../providers/reservation_provider.dart';
import '../providers/locale_provider.dart';
import 'reservation_detail_page.dart';
import '../l10n/app_localizations.dart';

/// The `ReservationListPage` class displays the list of reservations.
class ReservationListPage extends StatelessWidget {
  /// Constructs a `ReservationListPage`.
  ReservationListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final reservationProvider = Provider.of<ReservationProvider>(context);
    final localeProvider = Provider.of<LocaleProvider>(context);
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations?.translate('reservation_list') ?? 'Reservation List'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'en') {
                localeProvider.setLocale(Locale('en'));
              } else if (value == 'es') {
                localeProvider.setLocale(Locale('es'));
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  value: 'en',
                  child: Text('English'),
                ),
                PopupMenuItem(
                  value: 'es',
                  child: Text('Español'),
                ),
              ];
            },
          ),
        ],
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
              child: Text(localizations?.translate('add_reservation') ?? 'Add Reservation'),
            ),
          ),
        ],
      ),
    );
  }
}
