import 'package:flutter/material.dart';
import 'feed_screen.dart';

class RankScreen extends StatelessWidget {
  final List<Map<String, String>> data = [
    {
      'rank': '1위 명지대학교',
      'carbonSavings': '1000kg 탄소 절약',
      'imageUrl': 'assets/mju.jpg'
    },
    // 다른 순위 데이터는 생략
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('이번주 챌린지: 텀블러 사용'),
      ),
      body: Column(
        children: [
          Container(
            color: Colors.grey[200],
            padding: EdgeInsets.all(16.0),
            child: Center(
              child: Text(
                '순위',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(data[index]['rank']!),
                  trailing: Text(data[index]['carbonSavings']!),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FeedScreen(
                          school:
                              data[index]['rank']!.split(' ')[1], // 학교 이름만 전달
                          schoolImageUrl: data[index]['imageUrl']!,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
