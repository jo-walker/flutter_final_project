import 'package:floor/floor.dart';

@entity
class Airplane {
  @primaryKey
  final int? id; // nullable because it will be auto-generated
  final String type;
  final int passengerCount;
  final double maxSpeed;
  final double range;

  Airplane({
    required this.id,
    required this.type,
    required this.passengerCount,
    required this.maxSpeed,
    required this.range,
  });
}
