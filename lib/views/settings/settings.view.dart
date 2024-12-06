import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_solidart/flutter_solidart.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/getwidget.dart';
import 'package:money_pocket_flow/views/settings/settings.controller.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final controller = SettingsController();

  @override
  Widget build(BuildContext context) {
    return SignalBuilder(
        signal: controller.isEditting,
        builder: (context, isEditting, _) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: ResourceBuilder(
                  resource: controller.resource,
                  builder: (context, settingState) {
                    return settingState.on(ready: (data) {
                      return FormBuilder(
                        key: controller.formKey,
                        initialValue: {
                          'currencySymbol': data.currencySymbol,
                          'language': data.language,
                        },
                        child: Column(
                          children: [
                            const GFTypography(
                              text: 'Símbolo de moneda',
                              type: GFTypographyType.typo5,
                              showDivider: false,
                            ),
                            FormBuilderTextField(
                              name: 'currencySymbol',
                              enabled: isEditting,
                              decoration: InputDecoration(
                                hintText: '\$',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8)),
                                labelText: "Currency Symbol",
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.never,
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 15, horizontal: 10),
                              ),
                              validator: (val) {
                                if (val!.isEmpty) {
                                  return 'This field is required';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            const GFTypography(
                              text: 'Lenguaje',
                              type: GFTypographyType.typo5,
                              showDivider: false,
                            ),
                            FormBuilderDropdown<String>(
                              name: 'language',
                              enabled: isEditting,
                              items: const [
                                DropdownMenuItem(
                                  value: 'es',
                                  child: Text('Español'),
                                ),
                                DropdownMenuItem(
                                  value: 'en',
                                  child: Text('English'),
                                )
                              ],
                              decoration: InputDecoration(
                                hintText: 'English/Español',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8)),
                                labelText: "Language",
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.never,
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 15, horizontal: 10),
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            SignalBuilder(
                                signal: controller.isSaving,
                                builder: (context, saving, _) {
                                  if (saving) {
                                    return const Center(child: GFLoader());
                                  }
                                  return GFButton(
                                    onPressed: isEditting
                                        ? () {
                                            controller.saveSettings(context);
                                          }
                                        : null,
                                    text: 'Guardar cambios',
                                    fullWidthButton: true,
                                    size: GFSize.LARGE,
                                  );
                                })
                          ],
                        ),
                      );
                    }, error: (e, _) {
                      return const Center(
                        child:
                            Text('Hubo un error al cargar las configuraciones'),
                      );
                    }, loading: () {
                      return const Center(
                        child: GFLoader(),
                      );
                    });
                  }),
            ),
          );
        });
  }
}
