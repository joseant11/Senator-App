// reservation_screen.dart
import 'package:flutter/material.dart';
import '../models/restaurant.dart';
import '../models/reservation.dart';
import '../widgets/reservation_form.dart';
import '../reservation_state.dart'; // Importa la clase de estado global

class ReservationScreen extends StatefulWidget {
  const ReservationScreen({super.key});

  @override
  _ReservationScreenState createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {
  final List<Restaurant> restaurants = [
    Restaurant('Ember', 'Carne', 3),
    Restaurant('Zao', 'Japonés', 4),
    Restaurant('Grappa', 'Italiano', 2),
    Restaurant('Larimar', 'Marisco', 3),
  ];

  // Función para agregar una nueva reservación
  void addReservation(Reservation reservation) {
    final restaurant = restaurants.firstWhere((r) => r.name == reservation.restaurantName);
    final existingReservations = ReservationState.reservations
        .where((r) => r.restaurantName == reservation.restaurantName && r.timeSlot == reservation.timeSlot)
        .toList();

    int totalGroups = existingReservations.length;

    if (totalGroups < restaurant.capacity) {
      setState(() {
        ReservationState.reservations.add(reservation);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Reservación agregada exitosamente.')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No hay disponibilidad en este restaurante para la hora seleccionada.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nueva Reservación'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ReservationForm(
            restaurants: restaurants,
            onSubmit: addReservation,
          ),
        ),
      ),
    );
  }
}
