import 'package:equatable/equatable.dart';

class Animal extends Equatable {
  final String name;
  final String brand;
  final int temperature;

  const Animal({
    this.name = "",
    this.brand = "",
    this.temperature = 25,
  });

  @override
  List<Object?> get props => [name, brand];
}
