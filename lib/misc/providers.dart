import 'dart:math';

import 'package:farm_app/components/cow.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final StateProvider<int> dashboardIndexProvider = StateProvider((ref) => 1);
final StateProvider<List<Cow>> sickCowsProvider = StateProvider((ref) {
  Random random = Random(DateTime.now().millisecondsSinceEpoch);
  return List.generate(
    5,
    (index) {
      int temp = random.nextInt(90);
      return Cow(
        id: "${(index + 3) * 7}",
        name: "Cow ${(index + 3) * 7}",
        brand: "Holstein Female",
        temperature: temp < 25 ? 25 : temp,
      );
    },
  );
});
final StateProvider<List<Cow>> hungryCowsProvider = StateProvider(
  (ref) {
    Random random = Random(DateTime.now().millisecondsSinceEpoch);
    return List.generate(
      5,
      (index) {
        int temp = random.nextInt(90);
        return Cow(
          id: "${(index + 2) * 5}",
          name: "Cow ${(index + 2) * 5}",
          brand: "Holstein Male",
          temperature: temp < 25 ? 25 : temp,
        );
      }
    );
  },
);
final StateProvider<List<Cow>> allCowsProvider = StateProvider((ref) {
  List<Cow> cows = [];
  cows.addAll(ref.watch(sickCowsProvider));
  cows.addAll(ref.watch(hungryCowsProvider));
  return cows;
});

void logout(WidgetRef ref) {
  ref.invalidate(allCowsProvider);
  ref.invalidate(sickCowsProvider);
  ref.invalidate(hungryCowsProvider);
  ref.invalidate(dashboardIndexProvider);
}
