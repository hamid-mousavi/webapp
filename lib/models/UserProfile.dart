class UserProfile {
  final String id;
  final String fullName;
  final String phone;

  UserProfile({
    required this.id,
    required this.fullName,
    required this.phone,
  });

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      id: map['id'],
      fullName: map['full_name'] ?? '',
      phone: map['phone'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'full_name': fullName,
      'phone': phone,
    };
  }
}
