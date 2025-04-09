import 'package:flutter_web_app/models/UserProfile.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserService {
  final supabase =
      SupabaseClient('https://stmuqtudlxowcyctcfov.supabase.co', '');
  // final _client = Supabase.instance.client;

  Future<List<UserProfile>> getAllUsers() async {
    final response =
        await supabase.from('profiles').select('id, full_name, phone');
    return (response as List).map((map) => UserProfile.fromMap(map)).toList();
  }

  Future<void> updateUser(String id, UserProfile user) async {
    await supabase.from('profiles').update(user.toMap()).eq('id', id);
  }

  Future<void> deleteUser(String id) async {
    // حذف از auth.users به صورت دستی ممکن نیست، فقط از API Admin امکان‌پذیره.
    // پس فقط از جدول profiles حذف می‌کنیم.
    await supabase.from('profiles').delete().eq('id', id);
  }

  Future<UserResponse?> createUserWithProfile({
    required String email,
    required String password,
    required String fullName,
    required String phone,
  }) async {
    final res = await supabase.auth.admin.createUser(AdminUserAttributes(
      email: email,
      password: password,
      userMetadata: {'name': fullName, 'phone': phone},
      emailConfirm: false,
    ));
  }
}
