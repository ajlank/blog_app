import 'package:blog_app/base/styles/text_styles.dart';
import 'package:blog_app/controller/home_user_profile_notifier.dart';
import 'package:blog_app/controller/notification_notifier.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserNotification extends StatelessWidget {
  const UserNotification({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Notifications',
          style: TextStyles.profileHeaderText.copyWith(fontSize: 25),
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('followingNotifications')
            .where(
              'notifRecieverId',
              isEqualTo: context.watch<NotificationNotifier>().notifRecieverId,
            )
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
                return Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: ListTile(
                    tileColor: const Color.fromARGB(255, 215, 209, 216),
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(notif['notifSenderImg']),
                    ),
                    title: Row(
                      children: [
                        Text(
                          notif['notifSenderName'].toString(),
                          style: TextStyles.userTitle,
                        ),
                        SizedBox(width: 8),
                        Text('is following you'),
                      ],
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
