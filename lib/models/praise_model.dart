class PraiseModel {
  final String name;
  final int num;
  final String id;
  final DateTime dateCreated;
  final String uid;
  final String relation;
  final String amount;

  PraiseModel({
    required this.name,
    required this.num,
    required this.id,
    required this.dateCreated,
    required this.uid,
    required this.relation,
    required this.amount,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'name': name});
    result.addAll({'num': num});
    result.addAll({'id': id});
    result.addAll({'dateCreated': dateCreated.millisecondsSinceEpoch});
    result.addAll({'uid': uid});
    result.addAll({'relation': relation});
    result.addAll({'amount': amount});

    return result;
  }

  factory PraiseModel.fromMap(Map<String, dynamic> map) {
    return PraiseModel(
      name: map['name'] ?? '',
      num: map['num']?.toInt() ?? 0,
      id: map['id'] ?? '',
      dateCreated: DateTime.fromMillisecondsSinceEpoch(map['dateCreated']),
      uid: map['uid'] ?? '',
      relation: map['relation'] ?? '',
      amount: map['amount'] ?? '',
    );
  }
}
