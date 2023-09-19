class UserFields {
  static final String id = 'ID';
  static final String name = 'Name';
  static final String email = 'email';
  static final String isPadawan = 'isPadawan';

  static List<String> getFields() => [id, name, email, isPadawan];
}

class User {
  final int? id;
  final String name;
  final String email;
  final bool isPadawan;

  User(
      {required this.id,
      required this.name,
      required this.email,
      required this.isPadawan});

  Map<String, dynamic> toJson() {
    return {
      UserFields.id: id,
      UserFields.name: name,
      UserFields.email: email,
      UserFields.isPadawan: isPadawan,
    };
  }
}
