import 'package:flutter/material.dart';
import 'data/post_data.dart';

class PostCard extends StatelessWidget {
  final PostData post;

  const PostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    // createAt 필드가 문자열로 되어 있다면, 이 문자열을 날짜 형식으로 변환
    String formattedDate = post.createAt;

    // 만약 createAt이 타임스탬프이거나 특정 포맷의 문자열이라면, 이를 DateTime으로 파싱
    try {
      final DateTime parsedDate = DateTime.parse(post.createAt);
    } catch (e) {
      // 파싱 실패 시 원본 문자열 그대로 사용
    }

    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundImage: post.profileImage != null 
                ? MemoryImage(post.profileImage!)
                : const AssetImage('assets/blank.png'),
            ),
            title: Text(post.username),
            subtitle: Text(
              formattedDate,
              style: TextStyle(
                fontSize: 12.0, // 원하는 폰트 크기로 설정
                color: Colors.grey, // 원하는 색상으로 설정 (옵션)
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: post.feedImage != null
                ? Image.memory(post.feedImage!)
                : Image.asset('assets/example1.jpeg'),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(post.content),
          ),
          ButtonBar(
            children: [
              IconButton(
                icon: const Icon(Icons.thumb_up),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.comment),
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}
