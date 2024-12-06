import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_solidart/flutter_solidart.dart';
import 'package:getwidget/getwidget.dart';
import 'package:money_pocket_flow/dto/settings.repository.dart';
import 'package:money_pocket_flow/models/index.dart';
import 'package:money_pocket_flow/utils/bus.dart';

class SettingsController {
  Signal<bool> isEditting = Signal(false);
  Signal<bool> isSaving = Signal(false);
  final formKey = GlobalKey<FormBuilderState>();
  final SettingsRepository repository = SettingsRepository();
  final eventBus = EventModel.eventBus;

  late StreamSubscription eventSubscription;
  late Resource<Settings> resource;

  SettingsController() {
    eventSubscription = eventBus.on<EventModel>().listen((event) {
      if (event.name == 'begin-edit-settings') {
        isEditting.value = true;
        getSettings();
      } else if (event.name == 'cancel-edit-settings') {
        isEditting.value = false;
      }
    });
    resource = Resource<Settings>(fetcher: getSettings);
  }

  Future<Settings> getSettings() async {
    try {
      final setting = await repository.getSettings();
      return setting;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> saveSettings(BuildContext context) async {
    isSaving.value = true;
    try {
      if (formKey.currentState!.saveAndValidate()) {
        Map<String, dynamic> values = formKey.currentState!.value;
        Settings newSettings = Settings.fromJson(values);
        newSettings.id = resource.state.value!.id;
        await repository.saveSettings(newSettings);
        await resource.refresh();
        eventBus.fire(EventModel(name: 'settings-saved'));
        GFToast.showToast(
          'Cambios guardados.',
          context,
          toastPosition: GFToastPosition.BOTTOM,
          textStyle: const TextStyle(fontSize: 16, color: GFColors.DARK),
          backgroundColor: GFColors.LIGHT,
          trailing: const Icon(
            Icons.check,
          ),
        );
      }
    } catch (e) {
      GFToast.showToast(
        'Hubo un error al guardar tus cambios.',
        context,
        toastPosition: GFToastPosition.BOTTOM,
        textStyle: const TextStyle(fontSize: 16, color: GFColors.DARK),
        backgroundColor: GFColors.DANGER,
        trailing: const Icon(
          Icons.error,
        ),
      );
    } finally {
      isSaving.value = false;
      isEditting.value = false;
    }
  }

  void dispose() async {
    await eventSubscription.cancel();
  }
}
