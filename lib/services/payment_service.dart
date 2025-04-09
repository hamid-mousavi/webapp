import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/payment.dart';

class PaymentService {
  final _client = Supabase.instance.client;

  Future<void> addPayment(Payment payment) async {
    await _client.from('payments').insert(payment.toMap());

    // به‌روزرسانی بدهی به پرداخت‌شده اگر پرداخت کامل بود
    final debt = await _client
        .from('debts')
        .select('amount')
        .eq('id', payment.debtId)
        .single();

    final totalPaid = await _client
        .from('payments')
        .select('amount')
        .eq('debt_id', payment.debtId)
        .then((list) => list.fold(
            0.0, (sum, row) => sum + (row['amount'] as num).toDouble()));

    if (totalPaid >= (debt['amount'] as num).toDouble()) {
      await _client
          .from('debts')
          .update({'is_paid': true}).eq('id', payment.debtId);
    }
  }

  Future<List<Map<String, dynamic>>> getUsers() async {
    return await _client.from('profiles').select('id, full_name');
  }

  Future<List<Map<String, dynamic>>> getOpenDebtsForUser(String userId) async {
    return await _client
        .from('debts')
        .select('id, amount, due_date')
        .eq('user_id', userId)
        .eq('is_paid', false);
  }
}
