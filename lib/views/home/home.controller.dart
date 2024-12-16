import 'package:flutter_solidart/flutter_solidart.dart';
import 'package:money_pocket_flow/dto/settings.repository.dart';
import 'package:money_pocket_flow/dto/transaction.repository.dart';
import 'package:money_pocket_flow/models/index.dart';
import 'package:money_pocket_flow/models/utilities_class.dart';

class HomeController {
  Signal<int> totalExpends = Signal(0);
  Signal<Settings> settings = Signal(Settings());
  Signal<List<bool>> listSelectedOption = Signal([true, false, false]);
  late Resource<Settings> resourceSettings;
  late Resource<InOutResult> resourceInOut;
  late Resource<List<Category>> resourceCategories;
  final settingRepo = SettingsRepository();
  final transactionsRepo = TransactionRepository();

  HomeController() {
    resourceSettings = Resource(fetcher: loadSettings);
    resourceInOut = Resource(fetcher: getTotals, source: listSelectedOption);
    resourceCategories =
        Resource(fetcher: getTotalsByCategory, source: listSelectedOption);
    getTotalsByCategory();
  }

  FilterDateType get filterDate {
    final listValues = listSelectedOption.value;
    if (listValues[0]) {
      return FilterDateType.currentMonth;
    } else if (listValues[1]) {
      return FilterDateType.lastWeek;
    }
    return FilterDateType.today;
  }

  Future<Settings> loadSettings() async {
    return await settingRepo.getSettings();
  }

  Future<InOutResult> getTotals() async {
    return await transactionsRepo.getTotalsFiltered(type: filterDate);
  }

  Future<List<Category>> getTotalsByCategory() async {
    return await transactionsRepo.getTotalsByCategory(type: filterDate);
  }

  void setSelectedOption(int index) {
    listSelectedOption.value = [
      0 == index,
      1 == index,
      2 == index,
    ];
  }
}
