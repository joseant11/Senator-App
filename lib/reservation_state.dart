// reservation_state.dart
import '../models/reservation.dart';

class ReservationState {
  static List<Reservation> reservations = [];
  static Function? onReservationsChanged;
}
