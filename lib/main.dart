import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:userportal/providers/ticket_provider.dart';
import 'package:userportal/providers/user_provider.dart';
import 'package:userportal/resources/routes_manager.dart';
import 'package:userportal/services/network_handler/app_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  AppPreferences.init();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserProvider>(
          create: (_) => UserProvider(),
        ),
        ChangeNotifierProvider<TicketProvider>(create: (_) => TicketProvider())
      ],
      child: GetMaterialApp(
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: [const Locale('hr')],
        debugShowCheckedModeBanner: false,
        title: 'Korisnički portal - IN2',
        theme: ThemeData(
          primarySwatch: Colors.red,
        ),
        initialRoute: Routes.home,
        getPages: RoutesPages.pages,
        defaultTransition: Transition.noTransition,
      ),
    );
  }
}
