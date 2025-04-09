abstract class DebtEvent {}

class LoadDebts extends DebtEvent {}

class AddDebt extends DebtEvent {
  final Map<String, dynamic> debt;
  AddDebt(this.debt);
}

class UpdateDebt extends DebtEvent {
  final String id;
  final Map<String, dynamic> updatedDebt;
  UpdateDebt({required this.id, required this.updatedDebt});
}

class DeleteDebt extends DebtEvent {
  final String id;
  DeleteDebt(this.id);
}
