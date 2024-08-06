import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'providers/reservation_provider.dart';
import 'providers/locale_provider.dart';
import 'pages/reservation_list_page.dart';
import 'pages/add_reservation_page.dart';
import 'pages/edit_reservation_page.dart';
import 'pages/reservation_detail_page.dart';
import 'models/reservation.dart';
import 'l10n/app_localizations.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ReservationProvider()),
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
      ],
      child: Consumer<LocaleProvider>(
        builder: (context, localeProvider, child) {
          return MaterialApp(
            title: 'Reservation App',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            locale: localeProvider.locale,
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: [
              Locale('en', ''),
              Locale('es', ''),
            ],
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
          );
        },
      ),
    );
  }
}
