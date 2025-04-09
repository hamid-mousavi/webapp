import 'package:flutter/material.dart';
import 'package:flutter_web_app/models/UserProfile.dart';
import '../../services/user_service.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  final _service = UserService();
  List<UserProfile> _users = [];

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    final users = await _service.getAllUsers();
    setState(() => _users = users);
  }

  void _showEditDialog(UserProfile user) {
    final nameCtrl = TextEditingController(text: user.fullName);
    final phoneCtrl = TextEditingController(text: user.phone);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('ویرایش کاربر'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
                controller: nameCtrl,
                decoration: InputDecoration(labelText: 'نام')),
            TextField(
                controller: phoneCtrl,
                decoration: InputDecoration(labelText: 'تلفن')),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () async {
              final updated = UserProfile(
                id: user.id,
                fullName: nameCtrl.text,
                phone: phoneCtrl.text,
              );
              await _service.updateUser(user.id, updated);
              Navigator.pop(context);
              _loadUsers();
            },
            child: Text('ذخیره'),
          ),
        ],
      ),
    );
  }

  void _showAddUserDialog() {
    final emailCtrl = TextEditingController();
    final passCtrl = TextEditingController();
    final nameCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('افزودن کاربر جدید'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                  controller: emailCtrl,
                  decoration: InputDecoration(labelText: 'ایمیل')),
              TextField(
                  controller: passCtrl,
                  decoration: InputDecoration(labelText: 'رمز عبور')),
              TextField(
                  controller: nameCtrl,
                  decoration: InputDecoration(labelText: 'نام')),
              TextField(
                  controller: phoneCtrl,
                  decoration: InputDecoration(labelText: 'شماره تماس')),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              await _service.createUserWithProfile(
                email: emailCtrl.text,
                password: passCtrl.text,
                fullName: nameCtrl.text,
                phone: phoneCtrl.text,
              );
              Navigator.pop(context);
              _loadUsers();
            },
            child: Text('ثبت'),
          ),
        ],
      ),
    );
  }

  void _deleteUser(String id) async {
    await _service.deleteUser(id);
    _loadUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('مدیریت کاربران')),
      body: ListView.builder(
        itemCount: _users.length,
        itemBuilder: (_, index) {
          final user = _users[index];
          return ListTile(
            title: Text(user.fullName),
            subtitle: Text(user.phone),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () => _showEditDialog(user)),
                IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => _deleteUser(user.id)),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddUserDialog,
        child: Icon(Icons.add),
      ),
    );
  }
}
