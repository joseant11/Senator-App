import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const SenatorReservationsApp());
}

class SenatorReservationsApp extends StatelessWidget {
  const SenatorReservationsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Senator Reservations',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(),
    );
  }
}

