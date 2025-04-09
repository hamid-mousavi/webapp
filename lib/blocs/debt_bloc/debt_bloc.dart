import 'package:flutter_bloc/flutter_bloc.dart';
import 'debt_event.dart';
import 'debt_state.dart';
import '../../services/debt_service.dart';

class DebtBloc extends Bloc<DebtEvent, DebtState> {
  final DebtService _debtService;

  DebtBloc(this._debtService) : super(DebtInitial()) {
    on<LoadDebts>((event, emit) async {
      emit(DebtLoading());
      try {
        final debts =
            await _debtService.getAllDebts(); // باید به سرویس اضافه شه
        emit(DebtLoaded(debts));
      } catch (e) {
        emit(DebtError('خطا در بارگذاری بدهی‌ها'));
      }
    });

    on<AddDebt>((event, emit) async {
      try {
        await _debtService.addDebtFromMap(event.debt); // باید اضافه شه
        add(LoadDebts()); // رفرش کن
      } catch (_) {
        emit(DebtError('خطا در افزودن بدهی'));
      }
    });

    on<UpdateDebt>((event, emit) async {
      try {
        await _debtService.updateDebt(
            event.id, event.updatedDebt); // باید اضافه شه
        add(LoadDebts());
      } catch (_) {
        emit(DebtError('خطا در ویرایش بدهی'));
      }
    });

    on<DeleteDebt>((event, emit) async {
      try {
        await _debtService.deleteDebt(event.id); // باید اضافه شه
        add(LoadDebts());
      } catch (_) {
        emit(DebtError('خطا در حذف بدهی'));
      }
    });
  }
}
