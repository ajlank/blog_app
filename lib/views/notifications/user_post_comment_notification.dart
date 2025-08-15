import 'package:blog_app/base/styles/text_styles.dart';
import 'package:blog_app/controller/notification_notifier.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class UserPostCommentNotification extends StatefulWidget {
  const UserPostCommentNotification({super.key});

  @override
  State<UserPostCommentNotification> createState() =>
      _UserPostCommentNotificationState();
}

class _UserPostCommentNotificationState
    extends State<UserPostCommentNotification> {
  @override
  void initState() {
    context.read<NotificationNotifier>().setAnyNotification(false);
    super.initState();
  }

  @override
  void dispose() {
    context.read<NotificationNotifier>().setAnyNotification(false);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Reactions',
          style: TextStyles.profileHeaderText.copyWith(fontSize: 25),
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('postReactionCommentNotification')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No Notifications'));
          }
          if (snapshot.hasData) {
            final doc = snapshot.data!.docs;
            return ListView.builder(
              itemCount: doc.length,
              itemBuilder: (context, index) {
                final notif = doc[index].data();
                if (notif['notifRecieverId'] !=
                    FirebaseAuth.instance.currentUser!.uid) {
                  return SizedBox.shrink();
                }
                return Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: ListTile(
                    tileColor: const Color.fromARGB(255, 215, 209, 216),

                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(notif['notifSenderImg']),
                    ),
                    title: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                notif['notifSenderName'].toString(),
                                style: TextStyles.userTitle,
                              ),
                              SizedBox(width: 7),
                              Text(
                                'Reacted on your post',
                                style: TextStyle(fontSize: 13),
                              ),
                            ],
                          ),
                        ],
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
    );
  }
}
