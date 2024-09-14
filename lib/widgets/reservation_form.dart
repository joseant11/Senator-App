import 'package:flutter/material.dart';
import '../models/restaurant.dart';
import '../models/reservation.dart';

class ReservationForm extends StatefulWidget {
  final List<Restaurant> restaurants;
  final Function(Reservation) onSubmit;

  const ReservationForm({super.key, required this.restaurants, required this.onSubmit});

  @override
  _ReservationFormState createState() => _ReservationFormState();
}

class _ReservationFormState extends State<ReservationForm> {
  final _formKey = GlobalKey<FormState>();
  String _personName = '';
  int _groupSize = 0;
  String _selectedRestaurant = '';
  String _selectedTimeSlot = '6 - 8 pm';

  @override
  void initState() {
    super.initState();
    // Establece el restaurante seleccionado por defecto
    if (widget.restaurants.isNotEmpty) {
      _selectedRestaurant = widget.restaurants.first.name;
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final reservation = Reservation(
        _personName,
        _groupSize,
        _selectedRestaurant,
        _selectedTimeSlot,
      );
      widget.onSubmit(reservation);

      // Limpia el formulario
      _formKey.currentState!.reset();
      setState(() {
        _personName = '';
        _groupSize = 0;
        _selectedRestaurant = widget.restaurants.isNotEmpty ? widget.restaurants.first.name : '';
        _selectedTimeSlot = '6 - 8 pm';
      });

    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                initialValue: _personName,
                decoration: const InputDecoration(
                  labelText: 'Nombre de la persona',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                onChanged: (value) => _personName = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingrese el nombre.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                initialValue: _groupSize.toString(),
                decoration: const InputDecoration(
                  labelText: 'Cantidad de personas',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.group),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) => _groupSize = int.tryParse(value) ?? 1,
                validator: (value) {
                  if (value == null || int.tryParse(value) == null || int.parse(value) <= 0) {
                    return 'Ingrese una cantidad válida.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField(
                value: _selectedRestaurant,
                items: widget.restaurants
                    .map((restaurant) => DropdownMenuItem(
                          value: restaurant.name,
                          child: Text(restaurant.name),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedRestaurant = value.toString();
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'Seleccione un restaurante',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.restaurant),
                ),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField(
                value: _selectedTimeSlot,
                items: ['6 - 8 pm', '8 - 10 pm']
                    .map((slot) => DropdownMenuItem(
                          value: slot,
                          child: Text(slot),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedTimeSlot = value.toString();
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'Seleccione un horario',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.access_time),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton.icon(
                  onPressed: _submitForm,
                  icon: const Icon(Icons.add),
                  label: const Text('Agregar Reservación'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
