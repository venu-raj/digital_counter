class UserModel {
  final String phoneNumber;
  final String uid;
  final String name;
  final String? profilePic;
  UserModel({
    required this.phoneNumber,
    required this.uid,
    required this.name,
    this.profilePic,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'phoneNumber': phoneNumber});
    result.addAll({'uid': uid});
    result.addAll({'name': name});
    result.addAll({'profilePic': profilePic});

    return result;
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      phoneNumber: map['phoneNumber'] ?? '',
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      profilePic: map['profilePic'] ?? '',
    );
  }

  UserModel copyWith({
    String? phoneNumber,
    String? uid,
    String? name,
  }) {
    return UserModel(
      phoneNumber: phoneNumber ?? this.phoneNumber,
      uid: uid ?? this.uid,
      name: name ?? this.name,
      profilePic: profilePic,
    );
  }
}
