import 'package:farm_app/components/cow.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


final StateProvider<int> dashboardIndexProvider = StateProvider((ref) => 1);
final StateProvider<List<Cow>> sickCowsProvider = StateProvider((ref) => []);
final StateProvider<List<Cow>> hungryCowsProvider = StateProvider((ref) => []);


void logout(WidgetRef ref) {
  ref.invalidate(sickCowsProvider);
  ref.invalidate(hungryCowsProvider);
  ref.invalidate(dashboardIndexProvider);
}
