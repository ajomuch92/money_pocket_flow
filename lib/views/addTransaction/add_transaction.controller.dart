import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_solidart/flutter_solidart.dart';
import 'package:getwidget/getwidget.dart';
import 'package:go_router/go_router.dart';
import 'package:money_pocket_flow/dto/category.repository.dart';
import 'package:money_pocket_flow/dto/transaction.repository.dart';
import 'package:money_pocket_flow/models/index.dart';

class AddTransactionController {
  final repository = TransactionRepository();
  Signal<int?> transactionId = Signal(null);
  late Resource<TransactionModel> resourceTrx;
  late Signal<List<Category>> listCategories = Signal([]);
  final formKey = GlobalKey<FormBuilderState>();

  AddTransactionController() {
    getCategories();
    resourceTrx = Resource(
      fetcher: getTransaction,
      source: transactionId,
    );
  }

  Future<TransactionModel> getTransaction() async {
    if (transactionId.value != null) {
      return await repository.getTransaction(transactionId.value!);
    }
    return TransactionModel();
  }

  Future<void> getCategories() async {
    listCategories.value = await CategoryRepository().getCategories();
  }

  void setTransactionId(int? trxId) {
    transactionId.value = trxId;
  }

  Future<void> saveChanges(BuildContext context) async {
    try {
      if (formKey.currentState!.saveAndValidate()) {
        Map<String, dynamic> values = formKey.currentState!.value;
        TransactionModel trx = TransactionModel.fromJson(values);
        trx.id = transactionId.value;
        if (trx.id == null) {
          trx.date = DateTime.now();
        }
        await repository.saveTransaction(trx);
        if (!context.mounted) return;
        context.pop(true);
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
      } else {
        GFToast.showToast(
          'Ingresa todos los campos para continuar',
          context,
          toastPosition: GFToastPosition.BOTTOM,
          textStyle: const TextStyle(fontSize: 16, color: GFColors.DARK),
          backgroundColor: GFColors.WARNING,
          trailing: const Icon(
            Icons.warning,
          ),
        );
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
}
