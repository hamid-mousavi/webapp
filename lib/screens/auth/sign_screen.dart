import 'package:flutter/material.dart';
import 'package:flutter_web_app/screens/admin/debts/add_debt_screen.dart';
import 'package:flutter_web_app/screens/admin/users_screen.dart';
import 'package:flutter_web_app/services/auth_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<SignUpScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();

  Future<void> _signUp() async {
    try {
      final response = await _authService.signUp(
        _emailController.text,
        _passwordController.text,
      );

      if (response.user != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('ثبت نام با موفقیت انجام شد')),
        );
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
            ElevatedButton(onPressed: _signUp, child: Text('ورود')),
          ],
        ),
      ),
    );
  }
}
