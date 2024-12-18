import 'package:flutter/material.dart';
import 'package:flutter_color/flutter_color.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_solidart/flutter_solidart.dart';
import 'package:getwidget/getwidget.dart';
import 'package:go_router/go_router.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:money_pocket_flow/shared/ErrorEmpty.dart';
import 'package:money_pocket_flow/views/addTransaction/add_transaction.controller.dart';
import 'package:separated_column/separated_column.dart';

class AddTransaction extends StatefulWidget {
  final int? transactionId;
  const AddTransaction({super.key, this.transactionId});

  @override
  State<AddTransaction> createState() => _AddTransactionState();
}

class _AddTransactionState extends State<AddTransaction> {
  final controller = AddTransactionController();

  final _inputDecoration = InputDecoration(
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
    floatingLabelBehavior: FloatingLabelBehavior.never,
    contentPadding: const EdgeInsets.symmetric(
      vertical: 15,
      horizontal: 10,
    ),
  );

  @override
  void initState() {
    controller.setTransactionId(widget.transactionId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.transactionId != null
            ? 'Editar transacción'
            : 'Agregar transacción'),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            context.pop(false);
          },
          icon: const Icon(Icons.arrow_back),
        ),
        actions: widget.transactionId != null
            ? [
                IconButton(
                    onPressed: () {
                      controller.deleteTransaction(context);
                    },
                    icon: const Icon(Icons.delete))
              ]
            : null,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: ResourceBuilder(
            resource: controller.resourceTrx,
            builder: (context, transactionState) {
              return transactionState.on(
                ready: (transaction) {
                  return FormBuilder(
                    key: controller.formKey,
                    initialValue: {
                      'amount': '${transaction.amount ?? ''}',
                      'description': transaction.description ?? '',
                      'type': transaction.type,
                      'categoryId': transaction.categoryId,
                      'date': transaction.date ?? DateTime.now(),
                    },
                    child: SeparatedColumn(
                      includeOuterSeparators: true,
                      separatorBuilder: (context, i) => SizedBox(
                        height: i % 2 == 1 ? 0 : 10,
                      ),
                      children: [
                        const GFTypography(
                          text: 'Cantidad',
                          type: GFTypographyType.typo5,
                          showDivider: false,
                        ),
                        FormBuilderTextField(
                            name: 'amount',
                            textCapitalization: TextCapitalization.sentences,
                            decoration: _inputDecoration,
                            keyboardType: const TextInputType.numberWithOptions(
                              signed: false,
                              decimal: true,
                            ),
                            validator: (val) {
                              if (val!.isEmpty) {
                                return 'This field is required';
                              }
                              return null;
                            },
                            valueTransformer: (amount) {
                              return double.tryParse(amount ?? '0');
                            }),
                        const GFTypography(
                          text: 'Descripción',
                          type: GFTypographyType.typo5,
                          showDivider: false,
                        ),
                        FormBuilderTextField(
                          name: 'description',
                          textCapitalization: TextCapitalization.sentences,
                          minLines: 2,
                          maxLines: 4,
                          decoration: _inputDecoration,
                        ),
                        const GFTypography(
                          text: 'Tipo',
                          type: GFTypographyType.typo5,
                          showDivider: false,
                        ),
                        FormBuilderDropdown<String>(
                          name: 'type',
                          decoration: _inputDecoration,
                          items: const [
                            DropdownMenuItem(
                              value: 'in',
                              child: Text('Ingreso'),
                            ),
                            DropdownMenuItem(
                              value: 'out',
                              child: Text('Gasto'),
                            ),
                          ],
                        ),
                        const GFTypography(
                          text: 'Categoría',
                          type: GFTypographyType.typo5,
                          showDivider: false,
                        ),
                        SignalBuilder(
                          signal: controller.listCategories,
                          builder: (context, categories, _) {
                            return FormBuilderDropdown<int>(
                              name: 'categoryId',
                              decoration: _inputDecoration,
                              items: categories
                                  .map((category) => DropdownMenuItem(
                                        value: category.id!,
                                        child: Row(
                                          children: [
                                            category.icon != null
                                                ? Icon(
                                                    MdiIcons.fromString(
                                                      category.icon!,
                                                    ),
                                                    color: HexColor(
                                                      category.color!,
                                                    ),
                                                  )
                                                : Container(),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Text(category.name!),
                                          ],
                                        ),
                                      ))
                                  .toList(),
                            );
                          },
                        ),
                        const GFTypography(
                          text: 'Fecha',
                          type: GFTypographyType.typo5,
                          showDivider: false,
                        ),
                        FormBuilderDateTimePicker(
                          name: 'date',
                          inputType: InputType.date,
                          decoration: _inputDecoration,
                          firstDate: DateTime(1970),
                          lastDate: DateTime.now(),
                          valueTransformer: (date) {
                            if (date != null) {
                              return date.toIso8601String();
                            }
                            return null;
                          },
                        )
                      ],
                    ),
                  );
                },
                error: (e, t) => const ErrorEmpty(
                  message: 'Hubo un error al cargar la transacción',
                ),
                loading: () => const Center(
                  child: GFLoader(),
                ),
              );
            },
          ),
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
