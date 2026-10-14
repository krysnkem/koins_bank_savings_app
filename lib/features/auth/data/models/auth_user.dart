class AuthUser {
  final String fullName;
  final String email;
  final String phone;

  const AuthUser({
    required this.fullName,
    required this.email,
    required this.phone,
  });

  Map<String, dynamic> toJson() => {
        'fullName': fullName,
        'email': email,
        'phone': phone,
      };

  factory AuthUser.fromJson(Map<String, dynamic> json) {
    return AuthUser(
      fullName: json['fullName'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthUser &&
          runtimeType == other.runtimeType &&
          fullName == other.fullName &&
          email == other.email &&
          phone == other.phone;

  @override
  int get hashCode => fullName.hashCode ^ email.hashCode ^ phone.hashCode;
}
