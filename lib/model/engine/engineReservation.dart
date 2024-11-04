// ignore_for_file: file_names, non_constant_identifier_names

class Engine {
  final String engine_name;
  final String engine_desc;
  const Engine({required this.engine_name, required this.engine_desc});
}

class EngineReservation {
  final String engine;
  final String notify;
  final DateTime date;
  final String desc;
  const EngineReservation({
    required this.engine,
    required this.notify,
    required this.date,
    required this.desc,
  });
}
