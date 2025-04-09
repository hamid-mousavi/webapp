class Debt {
  final String id;
  final String userId;
  final String debtItemId;
  final double amount;
  final DateTime dueDate;
  final bool isPaid;

  Debt({
    required this.id,
    required this.userId,
    required this.debtItemId,
    required this.amount,
    required this.dueDate,
    this.isPaid = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'debt_item_id': debtItemId,
      'amount': amount,
      'due_date': dueDate.toIso8601String(),
      'is_paid': isPaid,
    };
  }
}
