class User {

  User({required this.id, required this.firstname, required this.lastname});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      firstname: (json['firstname'] ?? '') as String,
      lastname: (json['lastname'] ?? '') as String,
    );
  }
  final int id;
  final String firstname;
  final String lastname;
}
