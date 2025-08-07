import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import 'user_service.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final UserService _userService = UserService();

  // Keys for SharedPreferences
  static const String _isLoggedInKey = 'is_logged_in';
  static const String _currentUserIdKey = 'current_user_id';
  static const String _userEmailKey = 'user_email';
  static const String _loginTimeKey = 'login_time';

  // Current user state
  User? _currentUser;
  bool _isLoggedIn = false;

  // Getters
  bool get isLoggedIn => _isLoggedIn;
  User? get currentUser => _currentUser;
  String? get currentUserId => _currentUser?.uuid;

  /// Initialize auth service and check if user is already logged in
  Future<void> initialize() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _isLoggedIn = prefs.getBool(_isLoggedInKey) ?? false;

      if (_isLoggedIn) {
        final userId = prefs.getString(_currentUserIdKey);
        if (userId != null) {
          _currentUser = await _userService.getUserByUuid(userId);
          if (_currentUser == null) {
            // User not found, clear auth data
            await logout();
          }
        } else {
          await logout();
        }
      }

      debugPrint('Auth service initialized. Logged in: $_isLoggedIn');
    } catch (e) {
      debugPrint('Error initializing auth service: $e');
      await logout();
    }
  }

  /// Login with email and password
  Future<bool> login(String email, String password) async {
    try {
      // TODO: Implement actual authentication logic
      // For now, we'll use a simple check

      if (email.isEmpty || password.isEmpty) {
        return false;
      }

      // Mock authentication - in real app, this would call an API
      if (email == 'ahmed.alarabi@example.com' && password == 'password123') {
        // Get user data
        _currentUser = await _userService.getUserByEmail(email);

        if (_currentUser != null) {
          _isLoggedIn = true;
          await _saveAuthData();
          debugPrint('Login successful for user: ${_currentUser!.fullName}');
          return true;
        }
      }

      return false;
    } catch (e) {
      debugPrint('Login error: $e');
      return false;
    }
  }

  /// Register new user
  Future<bool> register({
    required String fullName,
    required String email,
    required String password,
    String? phone,
  }) async {
    try {
      // Check if user already exists
      final existingUser = await _userService.getUserByEmail(email);
      if (existingUser != null) {
        debugPrint('User already exists with email: $email');
        return false;
      }

      // Create new user

      await _userService.createUser(
        fullName: fullName,
        email: email,
        phone: phone,
      );
      // Auto-login after registration
      return await login(email, password);
    } catch (e) {
      debugPrint('Registration error: $e');
      return false;
    }
  }

  /// Logout current user
  Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Clear all auth data
      await prefs.remove(_isLoggedInKey);
      await prefs.remove(_currentUserIdKey);
      await prefs.remove(_userEmailKey);
      await prefs.remove(_loginTimeKey);

      // Clear in-memory data
      _currentUser = null;
      _isLoggedIn = false;

      debugPrint('User logged out successfully');
    } catch (e) {
      debugPrint('Logout error: $e');
    }
  }

  /// Save authentication data to SharedPreferences
  Future<void> _saveAuthData() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      await prefs.setBool(_isLoggedInKey, true);
      await prefs.setString(_currentUserIdKey, _currentUser!.uuid);
      await prefs.setString(_userEmailKey, _currentUser!.email);
      await prefs.setString(_loginTimeKey, DateTime.now().toIso8601String());

      debugPrint('Auth data saved successfully');
    } catch (e) {
      debugPrint('Error saving auth data: $e');
    }
  }

  /// Check if user session is still valid
  Future<bool> isSessionValid() async {
    try {
      if (!_isLoggedIn || _currentUser == null) {
        return false;
      }

      final prefs = await SharedPreferences.getInstance();
      final loginTimeString = prefs.getString(_loginTimeKey);

      if (loginTimeString != null) {
        final loginTime = DateTime.parse(loginTimeString);
        final now = DateTime.now();
        final sessionDuration = now.difference(loginTime);

        // Session expires after 30 days
        if (sessionDuration.inDays > 30) {
          await logout();
          return false;
        }
      }

      return true;
    } catch (e) {
      debugPrint('Error checking session validity: $e');
      return false;
    }
  }

  /// Update current user data
  Future<void> updateCurrentUser(User updatedUser) async {
    try {
      _currentUser = updatedUser;
      await _saveAuthData();
      debugPrint('Current user data updated');
    } catch (e) {
      debugPrint('Error updating current user: $e');
    }
  }

  /// Get user login status
  Future<Map<String, dynamic>> getLoginStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final loginTimeString = prefs.getString(_loginTimeKey);

      return {
        'isLoggedIn': _isLoggedIn,
        'userId': _currentUser?.uuid,
        'userEmail': _currentUser?.email,
        'userName': _currentUser?.fullName,
        'loginTime': loginTimeString,
      };
    } catch (e) {
      debugPrint('Error getting login status: $e');
      return {'isLoggedIn': false, 'error': e.toString()};
    }
  }

  /// Change password
  Future<bool> changePassword(
    String currentPassword,
    String newPassword,
  ) async {
    try {
      // TODO: Implement password change logic
      // This would typically involve:
      // 1. Verify current password
      // 2. Hash new password
      // 3. Update in database
      // 4. Optionally logout all other sessions

      debugPrint('Password change requested for user: ${_currentUser?.email}');

      // Mock implementation
      await Future.delayed(const Duration(seconds: 1));
      return true;
    } catch (e) {
      debugPrint('Error changing password: $e');
      return false;
    }
  }

  /// Reset password
  Future<bool> resetPassword(String email) async {
    try {
      // TODO: Implement password reset logic
      // This would typically involve:
      // 1. Check if user exists
      // 2. Generate reset token
      // 3. Send reset email

      final user = await _userService.getUserByEmail(email);
      if (user == null) {
        return false;
      }

      debugPrint('Password reset requested for: $email');

      // Mock implementation
      await Future.delayed(const Duration(seconds: 1));
      return true;
    } catch (e) {
      debugPrint('Error resetting password: $e');
      return false;
    }
  }

  /// Delete user account
  Future<bool> deleteAccount() async {
    try {
      if (_currentUser == null) {
        return false;
      }

      // TODO: Implement account deletion logic
      // This would typically involve:
      // 1. Delete user data from database
      // 2. Clear all user-related data
      // 3. Logout user

      final success = await _userService.deleteUser(_currentUser!.uuid);
      if (success) {
        await logout();
        debugPrint('User account deleted successfully');
        return true;
      }

      return false;
    } catch (e) {
      debugPrint('Error deleting account: $e');
      return false;
    }
  }
}
