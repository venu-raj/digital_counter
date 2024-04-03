class DailyVerseModel {
  final String docId;
  final String desc;
  final DateTime createdAt;

  DailyVerseModel({
    required this.docId,
    required this.desc,
    required this.createdAt,
  });

  DailyVerseModel copyWith({
    String? docId,
    String? desc,
    DateTime? createdAt,
  }) {
    return DailyVerseModel(
      docId: docId ?? this.docId,
      desc: desc ?? this.desc,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'docId': docId});
    result.addAll({'desc': desc});
    result.addAll({'createdAt': createdAt.millisecondsSinceEpoch});

    return result;
  }

  factory DailyVerseModel.fromMap(Map<String, dynamic> map) {
    return DailyVerseModel(
      docId: map['docId'] ?? '',
      desc: map['desc'] ?? '',
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
    );
  }
}
