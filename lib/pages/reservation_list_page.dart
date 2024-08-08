import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/reservation.dart';
import '../providers/reservation_provider.dart';
import '../providers/locale_provider.dart';
import 'reservation_detail_page.dart';
import 'add_reservation_page.dart';
import '../l10n/app_localizations.dart';

class ReservationListPage extends StatefulWidget {
  ReservationListPage({Key? key}) : super(key: key);

  @override
  _ReservationListPageState createState() => _ReservationListPageState();
}

class _ReservationListPageState extends State<ReservationListPage> {
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final reservationProvider = Provider.of<ReservationProvider>(context);
    final localeProvider = Provider.of<LocaleProvider>(context);
    final localizations = AppLocalizations.of(context);

    List<Reservation> filteredReservations = reservationProvider.searchReservations(_searchQuery);

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
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: localizations?.translate('search') ?? 'Search',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (query) {
                setState(() {
                  _searchQuery = query;
                });
              },
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: filteredReservations.length,
              itemBuilder: (context, index) {
                final reservation = filteredReservations[index];
                return Card(
                  margin: EdgeInsets.all(8.0),
                  child: ListTile(
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
                  ),
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
