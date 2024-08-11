import 'package:flutter/material.dart';
import 'data/post_data.dart';

class PostCard extends StatelessWidget {
  final PostData post;

  const PostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    // createAt 필드가 문자열로 되어 있다면, 이 문자열을 날짜 형식으로 변환
    String formattedDate = post.createAt;

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
