import 'package:flutter/foundation.dart';
import '../features/authentication/models/user.model.dart';


class UserState with ChangeNotifier {
  Users? _user;

  Users? get user => _user;

  // Set the user when logged in
  Future<void> setUser(Users user) async {
    _user = user;
    notifyListeners();
  }

  // Clear the user and subscription when logged out
  Future<void> logout() async {
    _user = null;
    notifyListeners();
  }

  // Update user profile details
  Future<void> updateUserProfile(Users user) async {
    _user = user;
    notifyListeners();
  }
}
