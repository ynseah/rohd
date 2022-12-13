abstract class RohdException implements Exception {
  ///
  late String message;

  @override
  String toString() => message;
}
