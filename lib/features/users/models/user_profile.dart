class UserProfile {
  const UserProfile({
    required this.id,
    required this.email,
    required this.fullName,
    this.phone,
    this.avatarUrl,
    this.isActive = true,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String email;
  final String fullName;
  final String? phone;
  final String? avatarUrl;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as String,
      email: json['email'] as String,
      fullName: json['full_name'] as String,
      phone: json['phone'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      isActive: json['is_active'] as bool? ?? true,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'full_name': fullName,
      'phone': phone,
      'avatar_url': avatarUrl,
      'is_active': isActive,
    };
  }

  UserProfile copyWith({
    String? id,
    String? email,
    String? fullName,
    String? phone,
    String? avatarUrl,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserProfile(
      id: id ?? this.id,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
