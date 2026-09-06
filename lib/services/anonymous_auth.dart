import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';

class User {
  final String id;
  final String displayName;
  final String gender;
  final String? location;
  final String? madhab;
  final DateTime createdAt;
  int hasanatPoints;
  int level;
  List<String> achievements;

  User({
    required this.id,
    required this.displayName,
    required this.gender,
    this.location,
    this.madhab,
    required this.createdAt,
    required this.hasanatPoints,
    required this.level,
    required this.achievements,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'displayName': displayName,
    'gender': gender,
    'location': location,
    'madhab': madhab,
    'createdAt': createdAt.toIso8601String(),
    'hasanatPoints': hasanatPoints,
    'level': level,
    'achievements': achievements,
  };

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json['id'],
    displayName: json['displayName'],
    gender: json['gender'],
    location: json['location'],
    madhab: json['madhab'],
    createdAt: DateTime.parse(json['createdAt']),
    hasanatPoints: json['hasanatPoints'],
    level: json['level'],
    achievements: List<String>.from(json['achievements']),
  );
}

class AnonymousAuth extends ChangeNotifier {
  User? _currentUser;
  bool _isLoading = false;

  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;

  Future<void> generateAnonymousUser({
    String? gender,
    String? location,
    String? madhab,
  }) async {
    _isLoading = true;
    notifyListeners();

    final uuid = Uuid();
    final box = Hive.box('user_data');

    // Generate random Muslim name
    final name = _generateMuslimName();
    final id = uuid.v4().substring(0, 8);

    final user = User(
      id: id,
      displayName: '${name}_$id',
      gender: gender ?? 'private',
      location: location,
      madhab: madhab,
      createdAt: DateTime.now(),
      hasanatPoints: 0,
      level: 1,
      achievements: [],
    );

    // Save to local storage
    await box.put('current_user', user.toJson());

    _currentUser = user;
    _isLoading = false;
    notifyListeners();
  }

  String _generateMuslimName() {
    final names = [
      'Abdullah', 'AbdurRahman', 'Muhammad', 'Ahmad',
      'Fatima', 'Aisha', 'Maryam', 'Khadija',
      'Ali', 'Umar', 'Uthman', 'AbuBakr',
      'Yusuf', 'Ibrahim', 'Musa', 'Isa',
      'Zainab', 'Hafsah', 'Safiyyah', 'Asiyah',
    ];
    return names[DateTime.now().millisecondsSinceEpoch % names.length];
  }

  Future<void> loadExistingUser() async {
    _isLoading = true;
    notifyListeners();

    final box = Hive.box('user_data');
    final userData = box.get('current_user');

    if (userData != null) {
      _currentUser = User.fromJson(Map<String, dynamic>.from(userData));
    }

    _isLoading = false;
    notifyListeners();
  }

  void updateHasanatPoints(int points) {
    if (_currentUser != null) {
      _currentUser!.hasanatPoints += points;
      _updateLevel();
      notifyListeners();
    }
  }

  void _updateLevel() {
    if (_currentUser != null) {
      _currentUser!.level = (_currentUser!.hasanatPoints ~/ 100) + 1;
    }
  }
}