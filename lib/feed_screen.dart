import 'package:flutter/material.dart';
import 'data/post_data.dart';
import 'database/database_helper.dart';
import 'home_screen.dart';
import 'post_card.dart';

class FeedScreen extends StatefulWidget {
  final String school;
  final String schoolImageUrl;

  FeedScreen({required this.school, required this.schoolImageUrl});

  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  List<PostData> posts = [];

  @override
  void initState() {
    super.initState();
    _loadPosts();
  }

  Future<void> _loadPosts() async {
    final dbHelper = DatabaseHelper();
    final loadedPosts = await dbHelper.getPosts();
    setState(() {
      posts = loadedPosts;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            leading: IconButton(
              icon: Icon(Icons.home),
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                  (Route<dynamic> route) => false,
                );
              },
            ),
            expandedHeight: 200.0,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true, // 제목을 가운데 정렬
              title: Text(widget.school),
              background: Container(
                color: Colors.white,
                child: Center(
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage('assets/mju.jpg'),
                  ),
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return PostCard(
                  post: posts[index],
                );
              },
              childCount: posts.length,
            ),
          ),
        ],
      ),
    );
  }
}
