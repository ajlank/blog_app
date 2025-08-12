import 'dart:convert';
import 'dart:io';
import 'package:blog_app/utils/constants/app_routes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';

class ProfileSettings extends StatefulWidget {
  const ProfileSettings({super.key});

  @override
  State<ProfileSettings> createState() => _ProfileSettingsState();
}

class _ProfileSettingsState extends State<ProfileSettings> {
  late final TextEditingController _titleController;
  late final TextEditingController _aboutController;

  File? coverFile;
  File? profile;

  @override
  void initState() {
    _titleController = TextEditingController();
    _aboutController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _aboutController.dispose();
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

  Future<void> profileUpdate() async {
    try {
      String? coverImageUrl;
      String? profileImageUrl;

      if (coverFile != null) {
        coverImageUrl = await uploadToCloudinary(coverFile!);
      }
      if (profile != null) {
        profileImageUrl = await uploadToCloudinary(profile!);
      }

      await FirebaseFirestore.instance.collection("profilesettings").add({
        "userId": FirebaseAuth.instance.currentUser!.uid,
        "name": _titleController.text.trim(),
        "about": _aboutController.text.trim(),
        "postedAt": FieldValue.serverTimestamp(),
        "profileImageUrl": profileImageUrl ?? "",
        "coverImageUrl": coverImageUrl ?? "",
      });

      await FirebaseFirestore.instance
          .collection('curentUser')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('user')
          .add({
            "userId": FirebaseAuth.instance.currentUser!.uid,
            "name": _titleController.text.trim(),
            "profileImageUrl": profileImageUrl ?? "",
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
          Text('Cover:'),
          GestureDetector(
            onTap: () async {
              final image = await selectImage();
              setState(() {
                coverFile = image;
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
                child: coverFile != null
                    ? Image.file(coverFile!)
                    : const Center(
                        child: Icon(Icons.camera_alt_outlined, size: 40),
                      ),
              ),
            ),
          ),
          Text('Profile'),
          GestureDetector(
            onTap: () async {
              final image = await selectImage();
              setState(() {
                profile = image;
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
                child: profile != null
                    ? Image.file(profile!)
                    : const Center(
                        child: Icon(Icons.camera_alt_outlined, size: 40),
                      ),
              ),
            ),
          ),
          TextFormField(
            controller: _titleController,
            decoration: InputDecoration(hintText: 'Your name?'),
          ),
          TextFormField(
            controller: _aboutController,
            decoration: InputDecoration(hintText: 'About yourself....'),
          ),

          TextButton(
            onPressed: () async {
              await profileUpdate();
              GetStorage().write(
                'userConfirmed',
                FirebaseAuth.instance.currentUser!.uid,
              );
              Navigator.of(
                context,
              ).pushNamedAndRemoveUntil(profileRoute, (_) => false);
            },
            child: const Text('Save Profile'),
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
