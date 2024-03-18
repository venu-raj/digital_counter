import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:digital_counter/utils/enums/testimoni_type.dart';

class TestimonisModel {
  final String text;
  final List<String> hashtags;
  final String link;
  final String imageLinks;
  final String uid;
  final String userName;
  final String profilePic;
  final TestimoniType testimoniType;
  final DateTime createdAt;
  final List<String> likes;
  final List<String> commentIds;
  final String id;
  final int shareCount;
  const TestimonisModel({
    required this.text,
    required this.hashtags,
    required this.link,
    required this.imageLinks,
    required this.uid,
    required this.userName,
    required this.profilePic,
    required this.testimoniType,
    required this.createdAt,
    required this.likes,
    required this.commentIds,
    required this.id,
    required this.shareCount,
  });

  TestimonisModel copyWith({
    String? text,
    List<String>? hashtags,
    String? link,
    String? imageLinks,
    String? uid,
    String? userName,
    String? profilePic,
    TestimoniType? testimoniType,
    DateTime? createdAt,
    List<String>? likes,
    List<String>? commentIds,
    String? id,
    int? shareCount,
  }) {
    return TestimonisModel(
      text: text ?? this.text,
      hashtags: hashtags ?? this.hashtags,
      link: link ?? this.link,
      imageLinks: imageLinks ?? this.imageLinks,
      uid: uid ?? this.uid,
      userName: uid ?? this.userName,
      profilePic: uid ?? this.profilePic,
      testimoniType: testimoniType ?? this.testimoniType,
      createdAt: createdAt ?? this.createdAt,
      likes: likes ?? this.likes,
      commentIds: commentIds ?? this.commentIds,
      id: id ?? this.id,
      shareCount: shareCount ?? this.shareCount,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'text': text});
    result.addAll({'hashtags': hashtags});
    result.addAll({'link': link});
    result.addAll({'imageLinks': imageLinks});
    result.addAll({'uid': uid});
    result.addAll({'userName': userName});
    result.addAll({'profilePic': profilePic});
    result.addAll({'testimoniType': testimoniType.type});
    result.addAll({'createdAt': createdAt.millisecondsSinceEpoch});
    result.addAll({'likes': likes});
    result.addAll({'commentIds': commentIds});
    result.addAll({'id': id});
    result.addAll({'shareCount': shareCount});

    return result;
  }

  factory TestimonisModel.fromMap(Map<String, dynamic> map) {
    return TestimonisModel(
      text: map['text'] ?? '',
      hashtags: List<String>.from(map['hashtags']),
      link: map['link'] ?? '',
      imageLinks: map['imageLinks'] ?? '',
      uid: map['uid'] ?? '',
      userName: map['userName'] ?? '',
      profilePic: map['profilePic'] ?? '',
      testimoniType: (map['testimoniType'] as String).toTweetTypeEnum(),
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      likes: List<String>.from(map['likes']),
      commentIds: List<String>.from(map['commentIds']),
      id: map['id'] ?? '',
      shareCount: map['shareCount']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory TestimonisModel.fromJson(String source) =>
      TestimonisModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'TestimonisModel(text: $text, hashtags: $hashtags, link: $link, imageLinks: $imageLinks, uid: $uid, userName: $userName, profilePic: $profilePic, testimoniType: $testimoniType, createdAt: $createdAt, likes: $likes, commentIds: $commentIds, id: $id, shareCount: $shareCount)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TestimonisModel &&
        other.text == text &&
        listEquals(other.hashtags, hashtags) &&
        other.link == link &&
        other.imageLinks == imageLinks &&
        other.uid == uid &&
        other.testimoniType == testimoniType &&
        other.createdAt == createdAt &&
        listEquals(other.likes, likes) &&
        listEquals(other.commentIds, commentIds) &&
        other.id == id &&
        other.shareCount == shareCount;
  }

  @override
  int get hashCode {
    return text.hashCode ^
        hashtags.hashCode ^
        link.hashCode ^
        imageLinks.hashCode ^
        uid.hashCode ^
        testimoniType.hashCode ^
        createdAt.hashCode ^
        likes.hashCode ^
        commentIds.hashCode ^
        id.hashCode ^
        shareCount.hashCode;
  }
}
