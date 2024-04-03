class UserModel {
  final String phoneNumber;
  final String uid;
  final String name;
  final String? profilePic;
  final bool isAdmin;
  UserModel({
    required this.phoneNumber,
    required this.uid,
    required this.name,
    this.profilePic,
    this.isAdmin = false,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'phoneNumber': phoneNumber});
    result.addAll({'uid': uid});
    result.addAll({'name': name});
    if (profilePic != null) {
      result.addAll({'profilePic': profilePic});
    }
    result.addAll({'isAdmin': isAdmin});

    return result;
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      phoneNumber: map['phoneNumber'] ?? '',
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      profilePic: map['profilePic'],
      isAdmin: map['isAdmin'] ?? false,
    );
  }
}
