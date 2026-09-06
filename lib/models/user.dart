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