class InOutResult {
  double inTotal;
  double outTotal;

  InOutResult({this.inTotal = 0, this.outTotal = 0});
}

enum TransactionType {
  inTrx('in'),
  outTrx('out');

  const TransactionType(this.str);
  final String str;
}

class TransactionFilter {
  int? categoryId;
  DateTime? initialDate;
  DateTime? endDate;
  TransactionType? type;
  int? page;
  int? limit;

  TransactionFilter({
    this.categoryId,
    this.initialDate,
    this.endDate,
    this.type,
    this.page,
    this.limit,
  });
}
