class CommentModel {
  final String userName;
  final String userUid;
  final String text;
  final String commentId;
  final String profilePic;
  final DateTime datePublished;
  final List<String> likes;

  CommentModel({
    required this.userName,
    required this.userUid,
    required this.text,
    required this.commentId,
    required this.profilePic,
    required this.datePublished,
    required this.likes,
  });

  CommentModel copyWith({
    String? userName,
    String? userUid,
    String? text,
    String? commentId,
    String? profilePic,
    DateTime? datePublished,
    List<String>? likes,
  }) {
    return CommentModel(
      userName: userName ?? this.userName,
      userUid: userUid ?? this.userUid,
      text: text ?? this.text,
      commentId: commentId ?? this.commentId,
      profilePic: profilePic ?? this.profilePic,
      datePublished: datePublished ?? this.datePublished,
      likes: likes ?? this.likes,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'userName': userName});
    result.addAll({'userUid': userUid});
    result.addAll({'text': text});
    result.addAll({'commentId': commentId});
    result.addAll({'profilePic': profilePic});
    result.addAll({'datePublished': datePublished.millisecondsSinceEpoch});
    result.addAll({'likes': likes});

    return result;
  }

  factory CommentModel.fromMap(Map<String, dynamic> map) {
    return CommentModel(
      userName: map['userName'] ?? '',
      userUid: map['userUid'] ?? '',
      text: map['text'] ?? '',
      commentId: map['commentId'] ?? '',
      profilePic: map['profilePic'] ?? '',
      datePublished: DateTime.fromMillisecondsSinceEpoch(map['datePublished']),
      likes: List<String>.from(map['likes']),
    );
  }
}
