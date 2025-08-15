import 'package:blog_app/controller/profile_settings_notifier.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GlobalChatView extends StatelessWidget {
  final TextEditingController _message = TextEditingController();

  GlobalChatView({super.key});

  void onSendMessage(BuildContext context) async {
    if (_message.text.isNotEmpty) {
      Map<String, dynamic> messages = {
        "senderId": FirebaseAuth.instance.currentUser!.uid,
        "senderName": Provider.of<ProfileSettingsNotifier>(
          context,
          listen: false,
        ).userName,
        "img": Provider.of<ProfileSettingsNotifier>(
          context,
          listen: false,
        ).profileImageUrl,
        "message": _message.text,
        "time": FieldValue.serverTimestamp(),
      };

      await FirebaseFirestore.instance
          .collection('globalChatroom')
          .add(messages);
      _message.clear();
    } else {
      print('Please enter some text');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text('Global chatroom', style: TextStyle(fontSize: 13)),
            SizedBox(width: 5),
          ],
        ),
      ),
      resizeToAvoidBottomInset: true,
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('globalChatroom')
                  .orderBy('time', descending: false)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Text('No data');
                }
                if (snapshot.hasData) {
                  final messages = snapshot.data!.docs;

                  return ListView.builder(
                    reverse: false,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final msg = messages[index];
                      bool isMe =
                          msg['senderId'] ==
                          FirebaseAuth.instance.currentUser!.uid;
                      return Column(
                        children: [
                          Align(
                            alignment: isMe
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 14),
                              child: Row(
                                children: [
                                  isMe
                                      ? SizedBox.shrink()
                                      : CircleAvatar(
                                          radius: 20,
                                          backgroundImage: NetworkImage(
                                            msg['img'],
                                          ),
                                        ),
                                  SizedBox(width: 10),
                                  isMe
                                      ? Text('')
                                      : Text(
                                          msg['senderName'],
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                ],
                              ),
                            ),
                          ),

                          Align(
                            alignment: isMe
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 12,
                              ),
                              margin: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                color: Color(0xFFE4E6EB),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(15),
                                  bottomRight: Radius.circular(15),
                                ),
                              ),
                              child: Text(
                                msg['message'],
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                }
                return CircularProgressIndicator();
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _message,
              decoration: InputDecoration(
                hintText: 'Write your message',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  onPressed: () {
                    onSendMessage(context);
                  },
                  icon: const Icon(Icons.send, color: Colors.blue),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
