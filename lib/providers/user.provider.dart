import 'package:flutter/foundation.dart';
import 'package:mtmeru_afya_yangu/features/authentication/controllers/user.controller.dart';
import 'package:mtmeru_afya_yangu/features/packages/controller/subscription.dart';
import 'package:mtmeru_afya_yangu/features/packages/model/subscriptions.dart';
import '../features/authentication/models/user.model.dart';


class UserProvider with ChangeNotifier {
  Users? _user;
  Subscriptions? _subscription; // Store the subscription details
  final DatabaseHelper _dbHelper = DatabaseHelper();
  final PackagesController _controller = PackagesController();

  Users? get user => _user;
  Subscriptions? get subscription => _subscription;

  // Set the user when logged in
  Future<void> setUser(Users user) async {
    _user = user;
    await loadSubscriptionForUser(user.userId); // Load subscriptions for the user
    notifyListeners();
  }

  // Load user from SQLite on app start
  Future<void> loadUserFromDatabase() async {
    final userData = await _dbHelper.loadUser();
    if (userData != null) {
      _user = Users(
        userId: userData[DatabaseHelper.columnUserId],
        name: userData[DatabaseHelper.columnName],
        email: userData[DatabaseHelper.columnEmail],
        phone: userData[DatabaseHelper.columnPhone],
        dob: userData[DatabaseHelper.columnDob] ?? "",
        gender: userData[DatabaseHelper.columnGender] ?? "",
        title: userData[DatabaseHelper.columnTitle] ?? "",
        password: userData[DatabaseHelper.columnPassword],
      );
      await loadSubscriptionForUser(_user!.userId); // Load subscriptions for the user
      notifyListeners();
    }
  }

  // Load subscription details for the user
  Future<void> loadSubscriptionForUser(int userId) async {
    final subscriptionData = await _controller.loadSubscription(userId);
    if (subscriptionData != null) {
      _subscription = Subscriptions(
        packageId: subscriptionData['packageId'],
        date: subscriptionData['date'],
        validity: subscriptionData['validity'],
        userId: subscriptionData['userId'],
      );
      notifyListeners();
    }
  }

  // Update subscription details
  Future<void> updateSubscription(Subscriptions subscription) async {
    _subscription = subscription;
    await _controller.updateSubscription(subscription.toMap());
    notifyListeners();
  }

  // Clear the user and subscription when logged out
  Future<void> logout() async {
    _user = null;
    _subscription = null;
    notifyListeners();
  }

  // Update user profile details
  Future<void> updateUserProfile(Users user) async {
    _user = user;
    notifyListeners();
  }
}
