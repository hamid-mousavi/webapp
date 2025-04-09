import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../services/debt_service.dart';
import '../../../models/debt.dart';

class AddDebtScreen extends StatefulWidget {
  const AddDebtScreen({super.key});

  @override
  State<AddDebtScreen> createState() => _AddDebtScreenState();
}

class _AddDebtScreenState extends State<AddDebtScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  DateTime? _dueDate;
  String? _selectedUserId;
  String? _selectedDebtItemId;

  final _service = DebtService();
  List<Map<String, dynamic>> _users = [];
  List<Map<String, dynamic>> _debtItems = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final users = await _service.getUsers();
    final items = await _service.getDebtItems();
    setState(() {
      _users = users;
      _debtItems = items;
    });
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate() &&
        _selectedUserId != null &&
        _selectedDebtItemId != null &&
        _dueDate != null) {
      final amount = double.tryParse(_amountController.text) ?? 0.0;

      final debt = Debt(
        id: '',
        userId: _selectedUserId!,
        debtItemId: _selectedDebtItemId!,
        amount: amount,
        dueDate: _dueDate!,
      );

      await _service.addDebt(debt);

      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('بدهی ثبت شد')));

      _formKey.currentState!.reset();
      setState(() {
        _amountController.clear();
        _selectedUserId = null;
        _selectedDebtItemId = null;
        _dueDate = null;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('لطفاً همه فیلدها را کامل کنید')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ثبت بدهی')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              DropdownButtonFormField(
                value: _selectedUserId,
                items: _users
                    .map((user) => DropdownMenuItem(
                        value: user['id'], child: Text(user['full_name'])))
                    .toList(),
                onChanged: (value) =>
                    setState(() => _selectedUserId = value as String?),
                decoration: const InputDecoration(labelText: 'کاربر'),
                validator: (value) =>
                    value == null ? 'لطفاً کاربر را انتخاب کنید' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField(
                value: _selectedDebtItemId,
                items: _debtItems
                    .map((item) => DropdownMenuItem(
                        value: item['id'], child: Text(item['title'])))
                    .toList(),
                onChanged: (value) =>
                    setState(() => _selectedDebtItemId = value as String?),
                decoration: const InputDecoration(labelText: 'نوع بدهی'),
                validator: (value) =>
                    value == null ? 'لطفاً نوع بدهی را انتخاب کنید' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'مبلغ'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'مبلغ را وارد کنید';
                  }
                  if (double.tryParse(value) == null) {
                    return 'مبلغ معتبر نیست';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) {
                    setState(() => _dueDate = picked);
                  }
                },
                child: Text(_dueDate == null
                    ? 'انتخاب تاریخ سررسید'
                    : 'تاریخ سررسید: ${DateFormat('yyyy/MM/dd').format(_dueDate!)}'),
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: const Text('ثبت بدهی'),
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(48)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
