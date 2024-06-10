import 'package:equatable/equatable.dart';

class Cow extends Equatable {

  final String id;
  final String name;
  final String brand;
  final int temperature;

  const Cow({
    this.id = "",
    this.name = "",
    this.brand = "",
    this.temperature = 25,
  });

  @override
  List<Object?> get props => [id];
}
