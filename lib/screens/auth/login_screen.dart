import 'package:flutter/material.dart';
import 'package:flutter_web_app/screens/admin/debts/add_debt_screen.dart';
import 'package:flutter_web_app/screens/admin/users_screen.dart';
import 'package:flutter_web_app/services/auth_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();

  Future<void> _login() async {
    try {
      final response = await _authService.signIn(
        _emailController.text,
        _passwordController.text,
      );

      if (response.user != null) {
        // رفتن به صفحه بعدی

        final user = Supabase.instance.client.auth.currentUser;
        if (user != null) {
          final data = await Supabase.instance.client
              .from('profiles')
              .select()
              .eq('id', user.id)
              .single();

          final role = data['role'];
          if (role == 'admin') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => UsersScreen()),
            );
          } else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (_) => LoginScreen()), // یا DebtListScreen
            );
          }
        }

        Navigator.pushReplacementNamed(context, '/home');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('خطا: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('ورود')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'ایمیل')),
            TextField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'رمز عبور'),
                obscureText: true),
            SizedBox(height: 20),
            ElevatedButton(onPressed: _login, child: Text('ورود')),
          ],
        ),
      ),
    );
  }
}
