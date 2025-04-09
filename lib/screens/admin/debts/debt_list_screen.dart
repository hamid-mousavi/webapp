import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_web_app/blocs/debt_bloc/debt_bloc.dart';
import 'package:flutter_web_app/blocs/debt_bloc/debt_event.dart';
import 'package:flutter_web_app/blocs/debt_bloc/debt_state.dart';

class DebtListScreen extends StatelessWidget {
  const DebtListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('لیست بدهی‌ها')),
      body: BlocBuilder<DebtBloc, DebtState>(
        builder: (context, state) {
          if (state is DebtLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is DebtLoaded) {
            if (state.debts.isEmpty) {
              return const Center(child: Text('هیچ بدهی‌ای ثبت نشده.'));
            }

            return LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth > 600;

                return ListView.builder(
                  itemCount: state.debts.length,
                  itemBuilder: (context, index) {
                    final debt = state.debts[index];
                    final name = debt['profiles']?['full_name'] ?? '---';
                    final item = debt['debt_items']?['title'] ?? '---';
                    final amount = debt['amount'];
                    final dueDate =
                        debt['due_date'].toString().substring(0, 10);

                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      child: ListTile(
                        title: Text('$name - $item'),
                        subtitle:
                            Text('مبلغ: $amount تومان\nتاریخ سررسید: $dueDate'),
                        isThreeLine: true,
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () {
                                // برو به صفحه ویرایش (می‌سازیمش)
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                context
                                    .read<DebtBloc>()
                                    .add(DeleteDebt(debt['id']));
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            );
          } else if (state is DebtError) {
            return Center(child: Text(state.message));
          }

          return const SizedBox();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // رفتن به صفحه افزودن بدهی
          Navigator.pushNamed(context, '/add-debt'); // route باید تعریف بشه
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
