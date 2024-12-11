import 'package:go_router/go_router.dart';
import 'package:money_pocket_flow/views/addCategory/add_category.view.dart';
import 'package:money_pocket_flow/views/index/index.view.dart';

final routes = GoRouter(routes: [
  GoRoute(
    path: '/',
    builder: (context, state) => const Index(),
  ),
  GoRoute(
    path: '/new-category',
    builder: (context, state) => const AddCategory(),
  ),
], initialLocation: '/');
