import 'package:flutter/material.dart';
import '../../services/payment_service.dart';
import '../../models/payment.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddPaymentScreen extends StatefulWidget {
  const AddPaymentScreen({super.key});

  @override
  State<AddPaymentScreen> createState() => _AddPaymentScreenState();
}

class _AddPaymentScreenState extends State<AddPaymentScreen> {
  final _amountController = TextEditingController();
  DateTime? _paymentDate;
  String? _selectedUserId;
  String? _selectedDebtId;

  final _service = PaymentService();
  List<Map<String, dynamic>> _users = [];
  List<Map<String, dynamic>> _debts = [];

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    final users = await _service.getUsers();
    setState(() => _users = users);
  }

  Future<void> _loadDebts(String userId) async {
    final debts = await _service.getOpenDebtsForUser(userId);
    setState(() => _debts = debts);
  }

  Future<void> _submit() async {
    if (_selectedUserId != null &&
        _selectedDebtId != null &&
        _paymentDate != null) {
      final currentUserId = Supabase.instance.client.auth.currentUser?.id ?? '';

      final payment = Payment(
        userId: _selectedUserId!,
        debtId: _selectedDebtId!,
        amount: double.parse(_amountController.text),
        paymentDate: _paymentDate!,
        createdBy: currentUserId,
      );

      await _service.addPayment(payment);

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('پرداخت ثبت شد')));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('ثبت پرداخت')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              items: _users
                  .map((user) => DropdownMenuItem<String>(
                      value: user['id'] as String,
                      child: Text(user['full_name'])))
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedUserId = value);
                  _loadDebts(value);
                }
              },
              decoration: InputDecoration(labelText: 'کاربر'),
            ),
            DropdownButtonFormField(
              items: _debts
                  .map((debt) => DropdownMenuItem(
                        value: debt['id'],
                        child: Text(
                            'مبلغ: ${debt['amount']} | سررسید: ${debt['due_date']}'),
                      ))
                  .toList(),
              onChanged: (value) =>
                  setState(() => _selectedDebtId = value as String?),
              decoration: InputDecoration(labelText: 'بدهی'),
            ),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'مبلغ پرداختی'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2100),
                );
                if (picked != null) {
                  setState(() => _paymentDate = picked);
                }
              },
              child: Text(_paymentDate == null
                  ? 'انتخاب تاریخ پرداخت'
                  : _paymentDate.toString().substring(0, 10)),
            ),
            SizedBox(height: 20),
            ElevatedButton(onPressed: _submit, child: Text('ثبت پرداخت')),
          ],
        ),
      ),
    );
  }
}
