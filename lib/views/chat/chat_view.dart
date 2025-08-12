import 'package:blog_app/controller/home_user_profile_notifier.dart';
import 'package:blog_app/controller/notification_notifier.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatView extends StatelessWidget {
  ChatView({super.key, required this.chatRoomId});

  final String chatRoomId;
  final TextEditingController _message = TextEditingController();

  void onSendMessage() async {
    if (_message.text.isNotEmpty) {
      Map<String, dynamic> messages = {
        "senderId": FirebaseAuth.instance.currentUser!.uid,
        "message": _message.text,
        "time": FieldValue.serverTimestamp(),
      };

      await FirebaseFirestore.instance
          .collection('chatroom')
          .doc(chatRoomId)
          .collection('chats')
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
            Text('Chatting with', style: TextStyle(fontSize: 13)),
            SizedBox(width: 5),
            Text(
              context.watch<HomeUserProfileNotifier>().homeUserName,
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      resizeToAvoidBottomInset: true,
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('chatroom')
                  .doc(chatRoomId)
                  .collection('chats')
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
                      return Align(
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
                            color: isMe ? Color(0xFF0084FF) : Color(0xFFE4E6EB),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15),
                              bottomRight: Radius.circular(15),
                            ),
                          ),
                          child: Text(
                            msg['message'],
                            style: TextStyle(
                              color: isMe ? Colors.white : Colors.black,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
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
                  onPressed: onSendMessage,
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
