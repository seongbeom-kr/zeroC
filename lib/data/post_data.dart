import 'dart:convert';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';

class PostData {
  String? feedId;
  final String userId;
  final String challengeId;
  final String username;
  final String content;
  final Uint8List? profileImage;
  final Uint8List? feedImage;
  final String createAt;

  PostData({
    this.feedId,
    required this.userId,
    required this.challengeId,
    required this.username,
    required this.content,
    this.profileImage,
    this.feedImage,
    required this.createAt,
  });

  @override
  String toString() {
    return 'feedId: $feedId, userId: $userId, challengeId: $challengeId, username: $username, content: $content, createAt: $createAt';
  }

  Map<String, Object?> toMap() {
    return {
      'feed_id': feedId,
      'user_id': userId,
      'challenge_id': challengeId,
      'username': username,
      'content': content,
      'profile_image': profileImage,
      'feed_image': feedImage,
      'create_at': createAt,
    };
  }

  // Firestore에 저장할 때 사용할 메서드
  Map<String, dynamic> toFirestore() {
    return {
      'user_id': userId,
      'challenge_id': challengeId,
      'username': username,
      'content': content,
      'profile_image': profileImage != null ? base64Encode(profileImage!) : null,
      'feed_image': feedImage != null ? base64Encode(feedImage!) : null,
      'create_at': createAt,
    };
  }

  // Firestore에서 데이터를 가져올 때 사용할 메서드
  factory PostData.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return PostData(
      feedId: doc.id,  // 자동 생성된 문서 ID를 feedId로 설정
      userId: data['user_id'],
      challengeId: data['challenge_id'],
      username: data['username'],
      content: data['content'],
      profileImage: data['profile_image'] != null ? base64Decode(data['profile_image']) : null,
      feedImage: data['feed_image'] != null ? base64Decode(data['feed_image']) : null,
      createAt: data['create_at'],
    );
  }
}
