import 'package:flutter/material.dart';
import 'package:appfront/utils/showSheetModal.dart';

Future<void> reservationEngine(BuildContext context) {
  return showSheetModal(context, const ReservationEngine());
}

class ReservationEngine extends StatefulWidget {
  const ReservationEngine({super.key});

  @override
  _State createState() => _State();
}

class _State extends State<ReservationEngine> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: const Text('Reservation Engine'),
    );
  }
}
