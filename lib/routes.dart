import 'package:go_router/go_router.dart';
import 'package:money_pocket_flow/views/index/index.view.dart';

final routes = GoRouter(routes: [
  GoRoute(
    path: '/',
    builder: (context, state) => const Index(),
  ),
], initialLocation: '/');
