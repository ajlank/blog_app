import 'dart:convert';
import 'dart:io';
import 'package:blog_app/controller/profile_settings_notifier.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:provider/provider.dart';

class CreatePost extends StatefulWidget {
  const CreatePost({super.key});

  @override
  State<CreatePost> createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  late final TextEditingController _titleController;
  late final TextEditingController _postController;
  late final TextEditingController _commentController;
  String nm = '';
  String img = '';

  File? postImageFile;

  @override
  void initState() {
    _titleController = TextEditingController();
    _postController = TextEditingController();
    _commentController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _postController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  Future<String?> uploadToCloudinary(File file) async {
    final cloudName = 'dyn1z1hjj';
    final uploadPreset = 'flutter_upload';

    final url = Uri.parse(
      'https://api.cloudinary.com/v1_1/$cloudName/image/upload',
    );

    final mimeType = lookupMimeType(file.path)!.split('/');

    final request = http.MultipartRequest('POST', url)
      ..fields['upload_preset'] = uploadPreset
      ..files.add(
        await http.MultipartFile.fromPath(
          'file',
          file.path,
          contentType: MediaType(mimeType[0], mimeType[1]),
        ),
      );

    final response = await request.send();

    if (response.statusCode == 200) {
      final resData = await http.Response.fromStream(response);
      final jsonData = jsonDecode(resData.body);
      return jsonData['secure_url'];
    } else {
      print('Cloudinary upload failed: ${response.statusCode}');
      return null;
    }
  }

  Future<void> userPost() async {
    try {
      String? postImageUrl;

      if (postImageFile != null) {
        postImageUrl = await uploadToCloudinary(postImageFile!);
      }

      final profile = Provider.of<ProfileSettingsNotifier>(
        context,
        listen: false,
      );
      final userName = profile.userName;
      final userImageUrl = profile.profileImageUrl;

      if (userName.isEmpty || userImageUrl.isEmpty) {
        print("User data not loaded.");
        // Optional: fetch from Firestore fallback
        return;
      }

      final postDoc = FirebaseFirestore.instance.collection("posts").doc();
      await postDoc.set({
        "documentId": postDoc.id,
        "userId": FirebaseAuth.instance.currentUser!.uid,
        "userName": userName,
        "userPostText": _postController.text,
        "userImageUrl": userImageUrl ?? "",
        "postImageUrl": postImageUrl ?? "",
        "postedAt": FieldValue.serverTimestamp(),
        "updatedAt": FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          GestureDetector(
            onTap: () async {
              final image = await selectImage();
              setState(() {
                postImageFile = image;
              });
            },
            child: DottedBorder(
              // borderType: BorderType.RRect,
              // radius: const Radius.circular(10),
              // dashPattern: const [10, 4],
              // strokeCap: StrokeCap.round,
              child: Container(
                width: double.infinity,
                height: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: postImageFile != null
                    ? Image.file(postImageFile!)
                    : const Center(
                        child: Icon(Icons.camera_alt_outlined, size: 40),
                      ),
              ),
            ),
          ),
          TextFormField(
            controller: _postController,
            decoration: InputDecoration(hintText: 'Write your post...'),
          ),
          // TextFormField(
          //   controller: _commentController,
          //   decoration: InputDecoration(hintText: 'Write a comment..'),
          // ),
          TextButton(
            onPressed: () async {
              await userPost();
            },
            child: const Text('Post'),
          ),
        ],
      ),
    );
  }
}

Future<File?> selectImage() async {
  final imagePicker = ImagePicker();
  XFile? file = await imagePicker.pickImage(source: ImageSource.gallery);
  if (file != null) {
    return File(file.path);
  }
  return null;
}
