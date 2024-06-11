import 'package:go_router/go_router.dart';
import 'package:farm_app/misc/constants.dart';
import 'package:farm_app/pages/home/landing_page.dart';


final List<GoRoute> routes = [
  GoRoute(
    path: Pages.home.path,
    name: Pages.home,
    builder: (_, __) => const LandingPage(),
  )
];
