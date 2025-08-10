import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FollowersView extends StatelessWidget {
  const FollowersView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('All followers'), centerTitle: true),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("followingNotifications")
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
                  contentPadding: EdgeInsets.all(12),
                  onTap: () {
                    // context
                    //     .read<HomeUserProfileNotifier>()
                    //     .setAllMessageSpecificUserId(data['senderId']);
                    // context.read<HomeUserProfileNotifier>().setSenderName(
                    //   data['senderName'],
                    // );
                    // Navigator.of(context).pushNamed(chatWithSenderRoute);
                  },
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(data['notifSenderImg'] ?? ''),
                  ),
                  title: Text(data['notifSenderName']),
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
