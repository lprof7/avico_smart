/// User Model - Represents the logged-in user
class UserModel {
  /// User's display name
  final String name;

  /// User's email
  final String email;

  /// Path to profile image asset
  final String profileImage;

  UserModel({
    required this.name,
    required this.email,
    this.profileImage = 'assets/images/profile.jpg',
  });

  /// Copy with updated values
  UserModel copyWith({String? name, String? email, String? profileImage}) {
    return UserModel(
      name: name ?? this.name,
      email: email ?? this.email,
      profileImage: profileImage ?? this.profileImage,
    );
  }
}
