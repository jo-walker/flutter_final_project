import 'package:floor/floor.dart';
import '../models/airplane.dart';

@dao
abstract class AirplaneDAO {
  @Query('SELECT * FROM Airplane')
  Future<List<Airplane>> findAllAirplanes();

  @insert
  Future<void> insertAirplane(Airplane airplane);

  @update
  Future<void> updateAirplane(Airplane airplane);

  @delete
  Future<void> deleteAirplane(Airplane airplane);
}
