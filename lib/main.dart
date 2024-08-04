import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/reservation_provider.dart';
import 'pages/reservation_list_page.dart';
import 'pages/add_reservation_page.dart';
import 'pages/edit_reservation_page.dart';
import 'pages/reservation_detail_page.dart';
import 'models/reservation.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ReservationProvider()),
      ],
      child: MaterialApp(
        title: 'Reservation App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => ReservationListPage(),
          '/add': (context) => AddReservationPage(),
        },
        onGenerateRoute: (settings) {
          if (settings.name == '/edit') {
            final Reservation reservation = settings.arguments as Reservation;
            return MaterialPageRoute(
              builder: (context) {
                return EditReservationPage(reservation: reservation);
              },
            );
          } else if (settings.name == '/detail') {
            final Reservation reservation = settings.arguments as Reservation;
            return MaterialPageRoute(
              builder: (context) {
                return ReservationDetailPage(reservation: reservation);
              },
            );
          }
          return null;
        },
      ),
    );
  }


}
