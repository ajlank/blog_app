import 'package:blog_app/controller/home_user_profile_notifier.dart';
import 'package:blog_app/views/chat/chat_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MessagesView extends StatelessWidget {
  const MessagesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('All messages'), centerTitle: true),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('allChats')
            .where(
              'recieverId',
              isEqualTo: FirebaseAuth.instance.currentUser!.uid,
            )
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }
          if (snapshot.hasData) {
            final docs = snapshot.data!.docs;

            return ListView.builder(
              itemCount: docs.length,
              itemBuilder: (context, index) {
                final data = docs[index].data();

                return ListTile(
                  onTap: () {
                    context.read<HomeUserProfileNotifier>().setHomeUserName(
                      data['senderName'],
                    );
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => ChatView(
                          chatRoomId: data['roomId'],
                          senderName: data['senderName'],
                          imgUrl: data['img'],
                          recieverId: FirebaseAuth.instance.currentUser!.uid,
                        ),
                      ),
                    );
                  },
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(data['img'] ?? ''),
                  ),
                  title: Text(data['senderName'] ?? ''),
                  subtitle: Text(data['message'] ?? ''),
                  splashColor: const Color.fromARGB(255, 226, 221, 202),
                );
              },
            );
          }
          return CircularProgressIndicator();
        },
      ),
    );
  }
}
