class Farmer {
  final int farmersID;
  final String firstName;
  final String lastName;
  final String email;
  final String password;

  Farmer({
    required this.farmersID,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
  });

  factory Farmer.fromMap(Map<String, dynamic> map) {
    return Farmer(
      farmersID: map['farmersID'] as int,
      firstName: map['firstName'] as String,
      lastName: map['lastName'] as String,
      email: map['email'] as String,
      password: map['password'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'farmersID': farmersID,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'password': password,
    };
  }
}
