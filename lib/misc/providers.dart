import 'package:farm_app/components/animal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final StateProvider<Animal> animalProvider = StateProvider(
  (ref) => const Animal(
    name: "Cody",
    brand: "Large White",
    temperature: 30,
  ),
);
