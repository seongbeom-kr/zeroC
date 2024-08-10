import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';  // fluttertoast 패키지 임포트
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'data/post_data.dart';
import 'database/firebase_helper.dart';
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

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(bool isProfile) async {
    try {
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
    } catch (e) {
      print("이미지 선택 에러: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('이미지 선택에 실패했습니다. 다시 시도해주세요.')),
      );
    }
  }

  Future<void> _submitPost() async {
    if (_textController.text.isNotEmpty && _feedImage != null) {
      final newPost = PostData(
        userId: "test", // 실제 사용자 ID를 설정
        challengeId: "4", // 실제 챌린지 ID를 설정
        username: 'User', // 실제 사용자 이름을 설정
        content: _textController.text,
        profileImage: _profileImage,
        feedImage: _feedImage,
        createAt: DateFormat('yyyy년 MM월 dd일 HH시 mm분 ss초').format(DateTime.now()),
      );

      // Firestore에 데이터 추가
      final dbHelper = DatabaseHelper();
      await dbHelper.addPost(newPost);

      // 토스트 메시지 표시
      Fluttertoast.showToast(
        msg: "제출 성공",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );

      // 콘솔에 출력
      print('포스팅 완료: ${_textController.text}');

      // FeedScreen으로 이동
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => FeedScreen(
            school: "명지대학교",
            schoolImageUrl: "",
          ),
        ),
        (Route<dynamic> route) => false,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('문구를 작성하고 사진을 업로드해주세요.')),
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
                maxLines: null, // 사용자가 여러 줄의 텍스트를 입력할 수 있도록 설정
              ),
            ),
            SizedBox(height: 20),
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
