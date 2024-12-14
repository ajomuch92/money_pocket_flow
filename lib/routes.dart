import 'package:go_router/go_router.dart';
import 'package:money_pocket_flow/views/addCategory/add_category.view.dart';
import 'package:money_pocket_flow/views/addTransaction/add_transaction.view.dart';
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
  GoRoute(
    path: '/edit-category/:categoryId',
    builder: (context, state) => AddCategory(
      categoryId: int.tryParse(state.pathParameters['categoryId'] ?? ''),
    ),
  ),
  GoRoute(
    path: '/new-trx',
    builder: (context, state) => const AddTransaction(),
  ),
  GoRoute(
    path: '/edit-trx/:transactionId',
    builder: (context, state) => AddTransaction(
      transactionId: int.tryParse(state.pathParameters['transactionId'] ?? ''),
    ),
  ),
], initialLocation: '/');
