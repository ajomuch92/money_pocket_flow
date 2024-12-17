import 'package:flutter_solidart/flutter_solidart.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:money_pocket_flow/dto/settings.repository.dart';
import 'package:money_pocket_flow/dto/transaction.repository.dart';
import 'package:money_pocket_flow/models/index.dart';
import 'package:money_pocket_flow/models/utilities_class.dart';

class ListTransactionsController {
  final repository = TransactionRepository();
  final currentPage = Signal<int>(0);
  TransactionFilter filter = TransactionFilter();
  late Resource<Settings> resourceSettings;
  final pageSize = 20;

  final PagingController<int, TransactionModel> pagingController =
      PagingController(firstPageKey: 0);

  ListTransactionsController() {
    resourceSettings = Resource(fetcher: loadSettings);
    pagingController.addPageRequestListener(fetchTrxs);
  }

  Future<Settings> loadSettings() async {
    return await SettingsRepository().getSettings();
  }

  void dispose() {
    pagingController.dispose();
  }

  Future<void> fetchTrxs(int pageKey) async {
    try {
      final newItems = await repository
          .getTransactions(TransactionFilter(page: pageKey, limit: pageSize));
      final isLastPage = newItems.length < pageSize;
      if (isLastPage) {
        pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + newItems.length;
        pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      pagingController.error = error;
    }
  }
}
