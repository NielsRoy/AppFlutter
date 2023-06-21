class Transaction {
  final String accountFrom;
  final String accountTo;
  final double amount;
  final bool isPayment;

  Transaction({
    required this.accountFrom,
    required this.accountTo,
    required this.amount,
    required this.isPayment,
  });
}
