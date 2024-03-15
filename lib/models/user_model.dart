class UserModel {
  final String phoneNumber;
  final String uid;
  final String name;
  UserModel({
    required this.phoneNumber,
    required this.uid,
    required this.name,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'phoneNumber': phoneNumber});
    result.addAll({'uid': uid});
    result.addAll({'name': name});

    return result;
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      phoneNumber: map['phoneNumber'] ?? '',
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
    );
  }
}
