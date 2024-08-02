import 'package:flutter_localizations/flutter_localizations.dart';
import 'AppLocalizations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/customer_provider.dart';
import 'pages/customer_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale = Locale('de'); // Set the default locale to German

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CustomerProvider(),
      child: MaterialApp(
        title: 'Final Project',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        locale: _locale,
        supportedLocales: [
          Locale('en', 'US'),
          Locale('de', 'DE'),
        ],
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        home: MainPage(
          onLocaleChange: setLocale,
        ),
        routes: {
          '/customer': (context) => CustomerListPage(),
        },
      ),
    );
  }
}

class MainPage extends StatelessWidget {
  final Function(Locale) onLocaleChange;

  MainPage({required this.onLocaleChange});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.translate('main_page') ?? 'Main Page'),
        actions: [
          DropdownButton<Locale>(
            icon: Icon(Icons.language),
            onChanged: (Locale? locale) {
              if (locale != null) {
                onLocaleChange(locale);
              }
            },
            items: [
              DropdownMenuItem(
                value: Locale('en', 'US'),
                child: Text('English'),
              ),
              DropdownMenuItem(
                value: Locale('de', 'DE'),
                child: Text('Deutsch'),
              ),
            ],
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/customer');
              },
              child: Text(AppLocalizations.of(context)!.translate('customer_list') ?? 'Customer List'),
            ),
            // SizedBox(height: 20),
            // ElevatedButton(
            //   onPressed: () {
            //     onLocaleChange(Locale('en', 'US'));
            //   },
            //   child: Text('Switch to English'),
            // ),
            // ElevatedButton(
            //   onPressed: () {
            //     onLocaleChange(Locale('de', 'DE'));
            //   },
            //   child: Text('Switch to Deutsch'),
            // ),
          ],
        ),
      ),
    );
  }
}