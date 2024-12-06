import 'package:money_pocket_flow/data/database_manager.dart';
import 'package:money_pocket_flow/data/repository.dart';
import 'package:money_pocket_flow/models/index.dart';

class SettingsRepository {
  final DatabaseManager dbManager = DatabaseManager();
  late final settingsRepository = Repository<Settings>(
    dbManager,
    'settings',
    () => Settings(),
  );

  Future<Settings> getSettings() async {
    try {
      List<Settings> list = await settingsRepository.getAll(limit: 1);
      return list.isEmpty ? Settings() : list[0];
    } catch (e) {
      rethrow;
    }
  }

  saveSettings(Settings settings) async {
    try {
      if (settings.id != null) {
        await settingsRepository.update(settings);
      } else {
        int id = await settingsRepository.insert(settings);
        settings.id = id;
      }
    } catch (e) {
      rethrow;
    }
  }
}
