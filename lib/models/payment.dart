class Payment {
  final String userId;
  final String debtId;
  final double amount;
  final DateTime paymentDate;
  final String createdBy;

  Payment({
    required this.userId,
    required this.debtId,
    required this.amount,
    required this.paymentDate,
    required this.createdBy,
  });

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'debt_id': debtId,
      'amount': amount,
      'payment_date': paymentDate.toIso8601String(),
      'created_by': createdBy,
    };
  }
}
