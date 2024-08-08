/// Represents a flight with its associated details.
///
/// This class holds information about a flight, including its departure and
/// destination cities, departure and arrival times, and a unique identifier.
class Flight {
  /// The unique identifier for the flight.
  ///
  /// This is an optional field that may be null when a flight is first created
  /// and hasn't been saved to a database yet.
  final int? id;

  /// The city where the flight departs from.
  final String departureCity;

  /// The city where the flight is headed.
  final String destinationCity;

  /// The time the flight departs.
  final String departureTime;

  /// The time the flight arrives at the destination.
  final String arrivalTime;

  /// Creates a new [Flight] instance.
  ///
  /// The [departureCity], [destinationCity], [departureTime], and [arrivalTime]
  /// must be provided when creating a new flight.
  Flight({
    this.id,
    required this.departureCity,
    required this.destinationCity,
    required this.departureTime,
    required this.arrivalTime,
  });

  /// Converts this [Flight] instance into a map.
  ///
  /// This method is typically used when saving the flight to a database.
  /// The keys of the map correspond to the column names in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'departureCity': departureCity,
      'destinationCity': destinationCity,
      'departureTime': departureTime,
      'arrivalTime': arrivalTime,
    };
  }
}
