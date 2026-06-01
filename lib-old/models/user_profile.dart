class UserProfile {
  const UserProfile({
    required this.fullName,
    required this.email,
    required this.photoUrl,
  });

  final String fullName;
  final String email;
  final String photoUrl;

  UserProfile copyWith({String? fullName, String? email, String? photoUrl}) {
    return UserProfile(
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
    );
  }
}
