import '../database/database_helper.dart';
import '../models/user.dart';
import 'package:uuid/uuid.dart';

class UserService {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  final Uuid _uuid = const Uuid();

  // Create a new user
  Future<User> createUser({
    required String fullName,
    required String email,
    String? phone,
    DateTime? dateOfBirth,
    String? gender,
    String? address,
    String? wilaya,
    String? commune,
    String? profileImage,
  }) async {
    final now = DateTime.now();
    final user = User(
      uuid: _uuid.v4(),
      fullName: fullName,
      email: email,
      phone: phone,
      dateOfBirth: dateOfBirth,
      gender: gender,
      address: address,
      wilaya: wilaya,
      commune: commune,
      profileImage: profileImage,
      createdAt: now,
      updatedAt: now,
    );

    await _dbHelper.insert('users', user.toMap());
    return user;
  }

  // Get user by UUID
  Future<User?> getUserByUuid(String uuid) async {
    final results = await _dbHelper.query(
      'users',
      where: 'uuid = ?',
      whereArgs: [uuid],
      limit: 1,
    );

    if (results.isNotEmpty) {
      return User.fromMap(results.first);
    }
    return null;
  }

  // Get user by email
  Future<User?> getUserByEmail(String email) async {
    final results = await _dbHelper.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
      limit: 1,
    );

    if (results.isNotEmpty) {
      return User.fromMap(results.first);
    }
    return null;
  }

  // Update user
  Future<bool> updateUser(User user) async {
    final updatedUser = user.copyWith(updatedAt: DateTime.now());
    final result = await _dbHelper.update(
      'users',
      updatedUser.toMap(),
      where: 'uuid = ?',
      whereArgs: [user.uuid],
    );
    return result > 0;
  }

  // Delete user
  Future<bool> deleteUser(String uuid) async {
    final result = await _dbHelper.delete(
      'users',
      where: 'uuid = ?',
      whereArgs: [uuid],
    );
    return result > 0;
  }

  // Get all users (for admin purposes)
  Future<List<User>> getAllUsers() async {
    final results = await _dbHelper.query(
      'users',
      orderBy: 'created_at DESC',
    );

    return results.map((map) => User.fromMap(map)).toList();
  }

  // Check if email exists
  Future<bool> emailExists(String email) async {
    final results = await _dbHelper.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
      limit: 1,
    );
    return results.isNotEmpty;
  }

  // Update user profile image
  Future<bool> updateProfileImage(String uuid, String imagePath) async {
    final result = await _dbHelper.update(
      'users',
      {
        'profile_image': imagePath,
        'updated_at': DateTime.now().toIso8601String(),
      },
      where: 'uuid = ?',
      whereArgs: [uuid],
    );
    return result > 0;
  }

  // Search users by name or email
  Future<List<User>> searchUsers(String query) async {
    final results = await _dbHelper.query(
      'users',
      where: 'full_name LIKE ? OR email LIKE ?',
      whereArgs: ['%$query%', '%$query%'],
      orderBy: 'full_name ASC',
    );

    return results.map((map) => User.fromMap(map)).toList();
  }
}
