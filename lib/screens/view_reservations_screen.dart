import 'package:flutter/material.dart';
import '../models/reservation.dart';
import '../reservation_state.dart'; 

class ViewReservationsScreen extends StatefulWidget {
  const ViewReservationsScreen({super.key});

  @override
  _ViewReservationsScreenState createState() => _ViewReservationsScreenState();
}

class _ViewReservationsScreenState extends State<ViewReservationsScreen> with SingleTickerProviderStateMixin {
  List<Reservation> reservations = ReservationState.reservations;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    ReservationState.onReservationsChanged = () {
      setState(() {
        reservations = ReservationState.reservations;
      });
    };
  }

  @override
  void dispose() {
    _tabController.dispose();
    ReservationState.onReservationsChanged = null;
    super.dispose();
  }

  List<Reservation> viewReservations(String timeSlot) {
    return reservations.where((r) => r.timeSlot == timeSlot).toList();
  }

  void _showDeleteConfirmation(Reservation reservation) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Eliminar Reservación'),
          content: Text('¿Estás seguro de que quieres eliminar la reservación de ${reservation.personName}?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _deleteReservation(reservation);
              },
              child: const Text('Eliminar'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
          ],
        );
      },
    );
  }

  void _deleteReservation(Reservation reservation) {
    setState(() {
      ReservationState.reservations.remove(reservation);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Reservación eliminada exitosamente.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ver Reservaciones'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: '6 - 8 pm'),
            Tab(text: '8 - 10 pm'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildReservationsList('6 - 8 pm'),
          _buildReservationsList('8 - 10 pm'),
        ],
      ),
    );
  }

  Widget _buildReservationsList(String timeSlot) {
    List<Reservation> reservationsForSlot = viewReservations(timeSlot);
    return reservationsForSlot.isEmpty
        ? Center(
            child: Text(
              'No hay reservaciones disponibles en este horario.',
              style: TextStyle(color: Colors.grey[600]),
            ),
          )
        : ListView.separated(
            padding: const EdgeInsets.all(16.0),
            itemCount: reservationsForSlot.length,
            separatorBuilder: (context, index) => const Divider(),
            itemBuilder: (context, index) {
              final res = reservationsForSlot[index];
              return Card(
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 5),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  leading: const Icon(Icons.restaurant, color: Colors.blueAccent),
                  title: Text(res.personName, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('${res.groupSize} personas en ${res.restaurantName}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _showDeleteConfirmation(res),
                  ),
                ),
              );
            },
          );
  }
}
