import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/debt.dart';

class DebtService {
  final _client = Supabase.instance.client;

  // افزودن بدهی با مدل
  Future<void> addDebt(Debt debt) async {
    await _client.from('debts').insert(debt.toMap());
  }

  // افزودن بدهی با Map (برای استفاده در BLoC)
  Future<void> addDebtFromMap(Map<String, dynamic> data) async {
    await _client.from('debts').insert(data);
  }

  // دریافت همه بدهی‌ها (برای لیست)
  Future<List<Map<String, dynamic>>> getAllDebts() async {
    final response = await _client
        .from('debts')
        .select(
            'id, amount, due_date, user_id, debt_item_id, profiles(full_name), debt_items(title)')
        .order('due_date', ascending: false);
    return response;
  }

  // به‌روزرسانی بدهی
  Future<void> updateDebt(String id, Map<String, dynamic> data) async {
    await _client.from('debts').update(data).eq('id', id);
  }

  // حذف بدهی
  Future<void> deleteDebt(String id) async {
    await _client.from('debts').delete().eq('id', id);
  }

  // دریافت لیست کاربران
  Future<List<Map<String, dynamic>>> getUsers() async {
    final response = await _client.from('profiles').select('id, full_name');
    return response;
  }

  // دریافت آیتم‌های بدهی
  Future<List<Map<String, dynamic>>> getDebtItems() async {
    final response = await _client.from('debt_items').select('id, title');
    return response;
  }
}
