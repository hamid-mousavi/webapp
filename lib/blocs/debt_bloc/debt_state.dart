abstract class DebtState {}

class DebtInitial extends DebtState {}

class DebtLoading extends DebtState {}

class DebtLoaded extends DebtState {
  final List<Map<String, dynamic>> debts;
  DebtLoaded(this.debts);
}

class DebtError extends DebtState {
  final String message;
  DebtError(this.message);
}
