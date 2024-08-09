import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'data/post_data.dart';
import 'database/database_helper.dart';
import 'feed_screen.dart';
import 'dart:typed_data';

class CertifyScreen extends StatefulWidget {
  @override
  _CertifyScreenState createState() => _CertifyScreenState();
}

class _CertifyScreenState extends State<CertifyScreen> {
  final _textController = TextEditingController();
  Uint8List? _profileImage;
  Uint8List? _feedImage;

  Future<void> _pickImage(bool isProfile) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        if (isProfile) {
          _profileImage = bytes;
        } else {
          _feedImage = bytes;
        }
      });
    }
  }

  void _submitPost() async {
    if (_textController.text.isNotEmpty) {
      // 새로운 게시글을 생성
      final newPost = PostData(
        userId: 1, // 실제 사용자 ID를 여기에 입력
        challengeId: 1, // 실제 챌린지 ID를 여기에 입력
        username: 'User', // 사용자 이름을 여기에 입력
        content: _textController.text,
        profileImage: _profileImage,
        feedImage: _feedImage,
        createAt: DateFormat('yy년 MM월 dd일 HH시 mm분 ss초').format(DateTime.now()),
      );

      // 데이터베이스에 추가
      final dbHelper = DatabaseHelper();
      await dbHelper.insertPost(newPost);

      // 콘솔에 출력
      print('Post submitted with text: ${_textController.text}');

      // FeedScreen으로 이동
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FeedScreen(
            school: "명지대학교",
            schoolImageUrl: "",
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('이번주 챌린지: 텀블러 사용'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            GestureDetector(
              onTap: () => _pickImage(false),
              child: Container(
                color: Colors.grey[300],
                height: 200,
                child: Center(
                  child: _feedImage != null
                      ? Image.memory(_feedImage!)
                      : Text('클릭하여 사진 업로드'),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _textController,
                decoration: InputDecoration(
                  hintText: '문구를 작성해주세요',
                ),
              ),
            ),
            ElevatedButton(
              onPressed: _submitPost,
              child: Text('제출'),
            ),
          ],
        ),
      ),
    );
  }
}
