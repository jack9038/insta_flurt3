import 'package:flutter/material.dart';
import 'package:instaflurt3/firebase_resources/authentication.dart';
import 'package:instaflurt3/models/users.dart';

class UserProvider with ChangeNotifier {
  User? _user;
  final Authentication _authmethods = Authentication();

  User? get getUser => _user!;

  Future<void> refreshUser() async {
    User user = await _authmethods.getUserDetails();
    _user = user;
    notifyListeners();
  }

  Future<void> fetchUserData() async {
    try {
      // Fetch user from Firestore or Auth
      _user = await _authmethods.getUserDetails();
      notifyListeners();
    } catch (e) {
      print("Error fetching user: $e");
    }
  }
}
