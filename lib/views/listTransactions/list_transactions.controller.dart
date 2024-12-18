import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_solidart/flutter_solidart.dart';
import 'package:getwidget/getwidget.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:money_pocket_flow/dto/settings.repository.dart';
import 'package:money_pocket_flow/dto/transaction.repository.dart';
import 'package:money_pocket_flow/models/index.dart';
import 'package:money_pocket_flow/models/utilities_class.dart';

class ListTransactionsController {
  final repository = TransactionRepository();
  final formKeyFilter = GlobalKey<FormBuilderState>();
  final currentPage = Signal<int>(0);
  late TransactionFilter filter;
  late Resource<Settings> resourceSettings;
  final pageSize = 20;

  final PagingController<int, TransactionModel> pagingController =
      PagingController(firstPageKey: 0);

  List<Category> get categories => repository.listCategories;

  ListTransactionsController() {
    resourceSettings = Resource(fetcher: loadSettings);
    pagingController.addPageRequestListener(fetchTrxs);
    filter = TransactionFilter(limit: pageSize);
  }

  Future<Settings> loadSettings() async {
    return await SettingsRepository().getSettings();
  }

  void dispose() {
    pagingController.dispose();
  }

  Future<void> fetchTrxs(int pageKey) async {
    try {
      filter.page = pageKey;
      final newItems = await repository.getTransactions(filter);
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

  void resetFilters(BuildContext context) {
    filter.type = null;
    filter.categoryId = null;
    filter.initialDate = null;
    filter.endDate = null;
    pagingController.refresh();
    context.pop();
  }

  void setFilters(BuildContext context) {
    try {
      if (formKeyFilter.currentState!.saveAndValidate()) {
        Map<String, dynamic> values = formKeyFilter.currentState!.value;
        filter.type = values['type'];
        filter.categoryId = values['categoryId'];
        if (values['date'] is DateTimeRange) {
          final dateRange = values['date'] as DateTimeRange;
          filter.initialDate = dateRange.start;
          filter.endDate = dateRange.end;
        } else {
          filter.initialDate = null;
          filter.endDate = null;
        }
        pagingController.refresh();
        context.pop();
      }
    } catch (e) {
      GFToast.showToast(
        'Hubo un error al guardar tus cambios.',
        context,
        toastPosition: GFToastPosition.BOTTOM,
        textStyle: const TextStyle(fontSize: 16, color: GFColors.WHITE),
        backgroundColor: GFColors.DANGER,
        trailing: const Icon(
          Icons.error,
          color: GFColors.WHITE,
        ),
      );
    }
  }

  void navigateDetails(TransactionModel trx, BuildContext context) {
    context.push('/edit-trx/${trx.id}').then((value) {
      if (value == true) {
        pagingController.refresh();
      }
    });
  }
}
