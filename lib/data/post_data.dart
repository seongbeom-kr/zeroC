import 'dart:typed_data';

class PostData {
  int? feedId;
  final int userId;
  final int challengeId;
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
}
