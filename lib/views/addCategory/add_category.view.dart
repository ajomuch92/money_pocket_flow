import 'package:dotted_border/dotted_border.dart';
import 'package:fluentui_emoji_icon/fluentui_emoji_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_color/flutter_color.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_solidart/flutter_solidart.dart';
import 'package:form_builder_extra_fields/form_builder_extra_fields.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:getwidget/getwidget.dart';
import 'package:go_router/go_router.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:money_pocket_flow/shared/ErrorEmpty.dart';
import 'package:money_pocket_flow/views/addCategory/add_category.controller.dart';

class AddCategory extends StatefulWidget {
  final int? categoryId;
  const AddCategory({super.key, this.categoryId});

  @override
  State<AddCategory> createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  final AddCategoryController controller = AddCategoryController()..categoryId;

  @override
  void initState() {
    controller.setCategoryId(widget.categoryId);
    super.initState();
  }

  Future<String?> showIconSelector(BuildContext context) async {
    var result = await showModalBottomSheet<String>(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return SizedBox(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Flexible(
                          child: GFTypography(
                            text: 'Escoge el icono de tu categoría',
                          ),
                        ),
                        Flexible(
                          child: IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(Icons.close),
                          ),
                        ),
                      ],
                    ),
                  ),
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Buscar...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onChanged: controller.onSearch,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    child: SignalBuilder(
                        signal: controller.listIcon,
                        builder: (context, listIcons, _) {
                          if (listIcons.isEmpty) {
                            return const ErrorEmpty(
                              message: 'Sin coincidencias para tu búsqueda',
                              fullHeight: false,
                              child: FluentUiEmojiIcon(
                                fl: Fluents.flSadButRelievedFace,
                                w: 50,
                                h: 50,
                              ),
                            );
                          }
                          return GridView.count(
                            crossAxisCount: 3,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10,
                            children: listIcons.map((iconKey) {
                              return Stack(
                                children: [
                                  SignalBuilder(
                                      signal: controller.selectedIcon,
                                      builder: (context, value, _) {
                                        return Visibility(
                                          visible: value == iconKey,
                                          child: const Positioned(
                                            right: 10,
                                            top: 10,
                                            child: Icon(
                                              Icons.check_circle,
                                              color: Colors.green,
                                            ),
                                          ),
                                        );
                                      }),
                                  InkWell(
                                    onTap: () {
                                      controller.setActiveIcon(iconKey);
                                      context.pop(iconKey);
                                    },
                                    child: Container(
                                      width:
                                          MediaQuery.of(context).size.width / 3,
                                      height:
                                          MediaQuery.of(context).size.width / 3,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color:
                                                Colors.black.withOpacity(0.5)),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            MdiIcons.fromString(iconKey),
                                            size: 32,
                                          ),
                                          Text(
                                            iconKey,
                                            textAlign: TextAlign.center,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }).toList(),
                          );
                        }),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.categoryId != null
            ? 'Editar categoría'
            : 'Agregar categoría'),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            context.pop(false);
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: ResourceBuilder(
              resource: controller.resource,
              builder: (context, resourceState) {
                return resourceState.on(
                    ready: (category) {
                      return FormBuilder(
                        key: controller.formKey,
                        initialValue: {
                          'name': category.name,
                          'icon': category.icon,
                          'color': category.color != null
                              ? HexColor(category.color!)
                              : null,
                        },
                        child: Column(
                          children: [
                            const GFTypography(
                              text: 'Nombre categoría',
                              type: GFTypographyType.typo5,
                              showDivider: false,
                            ),
                            FormBuilderTextField(
                              name: 'name',
                              textCapitalization: TextCapitalization.words,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8)),
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
                              height: 10,
                            ),
                            const GFTypography(
                              text: 'Color',
                              type: GFTypographyType.typo5,
                              showDivider: false,
                            ),
                            FormBuilderColorPickerField(
                              name: 'color',
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8)),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.never,
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 15,
                                  horizontal: 10,
                                ),
                              ),
                              colorPickerType: ColorPickerType.materialPicker,
                              valueTransformer: (color) {
                                if (color != null) {
                                  return color.asHexString;
                                }
                                return '';
                              },
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const GFTypography(
                              text: 'Icono',
                              type: GFTypographyType.typo5,
                              showDivider: false,
                            ),
                            FormBuilderField(
                              name: "icon",
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(),
                              ]),
                              builder: (FormFieldState<dynamic> field) {
                                return InkWell(
                                  onTap: () async {
                                    controller
                                        .setActiveIcon(category.icon ?? '');
                                    controller.onSearch('');
                                    final result =
                                        await showIconSelector(context);
                                    field.didChange(result);
                                  },
                                  child: DottedBorder(
                                    color: Colors.blueGrey,
                                    strokeWidth: 3.0,
                                    borderType: BorderType.RRect,
                                    radius: const Radius.circular(10),
                                    child: SignalBuilder(
                                      signal: controller.selectedIcon,
                                      builder: (context, selectedIcon, _) {
                                        return Container(
                                          width: 150,
                                          height: 150,
                                          decoration: BoxDecoration(
                                            color: selectedIcon.isNotEmpty
                                                ? Colors.white10
                                                : Colors.grey.withOpacity(0.5),
                                            borderRadius:
                                                BorderRadius.circular(7),
                                          ),
                                          child: selectedIcon.isNotEmpty
                                              ? Icon(
                                                  MdiIcons.fromString(
                                                      selectedIcon),
                                                  size: 64,
                                                )
                                              : Container(),
                                        );
                                      },
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      );
                    },
                    error: (e, t) => const ErrorEmpty(
                        message: 'Hubo un error al cargar la categoría'),
                    loading: () => const Center(
                          child: GFLoader(),
                        ));
              }),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(10),
        child: GFButton(
          onPressed: () {
            controller.saveChanges(context);
          },
          text: 'Guardar cambios',
          size: 48,
        ),
      ),
    );
  }
}
