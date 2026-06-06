import 'package:flutter/material.dart';

import '../data/user_profile.dart';
import '../../../core/network/local_storage_service.dart';
import '../../../core/network/mock_data.dart';

class ProfileProvider extends ChangeNotifier {
  ProfileProvider() {
    _profile = _loadProfile();
  }

  late UserProfile _profile;

  UserProfile get profile => _profile;

  UserProfile _loadProfile() {
    final name = LocalStorageService.getProfileName();
    final email = LocalStorageService.getProfileEmail();
    final photo = LocalStorageService.getProfilePhoto();

    if (name != null && email != null && photo != null) {
      return UserProfile(fullName: name, email: email, photoUrl: photo);
    }

    return MockData.defaultProfile;
  }

  Future<void> updateProfile(UserProfile profile) async {
    _profile = profile;
    await LocalStorageService.saveProfile(
      name: profile.fullName,
      email: profile.email,
      photoUrl: profile.photoUrl,
    );
    notifyListeners();
  }
}
