import 'package:blog_app/base/styles/text_styles.dart';
import 'package:blog_app/controller/home_post_notifier.dart';
import 'package:blog_app/controller/home_user_profile_notifier.dart';
import 'package:blog_app/controller/notification_notifier.dart';
import 'package:blog_app/controller/post_comment_notifier.dart';
import 'package:blog_app/controller/profile_settings_notifier.dart';
import 'package:blog_app/utils/constants/app_routes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

enum MenuAction { delete, update }

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 225, 227, 230),
      appBar: AppBar(
        backgroundColor: Colors.white,
        actionsPadding: EdgeInsets.all(12),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(globalChatRoute);
            },
            icon: Icon(Icons.chat),
          ),
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(postCommentNotificationRoute);
            },
            icon: Icon(Icons.podcasts_sharp),
          ),
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(notificationsRoute);
            },
            icon: Icon(Icons.notifications_active),
          ),
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(profileRoute);
            },
            icon: Icon(FluentIcons.person_12_regular),
          ),

          IconButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              context.read<ProfileSettingsNotifier>().clearUserDetails();
              Navigator.of(
                context,
              ).pushNamedAndRemoveUntil(loginRoute, (_) => false);
            },
            icon: Icon(FluentIcons.arrow_exit_20_filled),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('posts')
            .orderBy("postedAt", descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: Text('Loading'));
          }
          if (snapshot.hasData) {
            final docs = snapshot.data!.docs;

            return ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: docs.length,
              itemBuilder: (context, index) {
                final postData = docs[index].data();

                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 254, 251, 251),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundImage: NetworkImage(
                              postData['userImageUrl'] ?? '',
                            ),
                            radius: 24,
                          ),
                          const SizedBox(width: 9),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  context
                                      .read<HomeUserProfileNotifier>()
                                      .setHomeUserId(postData['userId']);
                                  context
                                      .read<NotificationNotifier>()
                                      .setNotifRecieverId(postData['userId']);
                                  context
                                      .read<HomeUserProfileNotifier>()
                                      .setHomeUserName(postData['userName']);
                                  Navigator.of(
                                    context,
                                  ).pushNamed(homeUserRoute);
                                },
                                child: Text(
                                  postData['userName'] ?? '',
                                  style: TextStyles.userTitle,
                                ),
                              ),
                              Text(
                                'Posted on ${DateFormat('MMMM d, y – hh:mm a').format((postData['postedAt'] as Timestamp).toDate())}',
                                style: TextStyles.profileHeaderText.copyWith(
                                  fontWeight: FontWeight.w300,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          (postData['userId'] ==
                                  FirebaseAuth.instance.currentUser!.uid)
                              ? PopupMenuButton<MenuAction>(
                                  onSelected: (value) async {
                                    switch (value) {
                                      case MenuAction.delete:
                                        await FirebaseFirestore.instance
                                            .collection('posts')
                                            .doc(postData['documentId'])
                                            .delete();
                                        showSnckBarr(context, 'post deleted');

                                      case MenuAction.update:
                                        context
                                            .read<HomePostNotifier>()
                                            .setUserName(postData['userName']);
                                        context
                                            .read<HomePostNotifier>()
                                            .setUserImgUrl(
                                              postData['userImageUrl'],
                                            );
                                        context
                                            .read<HomePostNotifier>()
                                            .setDocId(postData['documentId']);
                                        context
                                            .read<HomePostNotifier>()
                                            .setPostImage(
                                              postData['postImageUrl'],
                                            );
                                        context
                                            .read<HomePostNotifier>()
                                            .setPostTex(
                                              postData['userPostText'],
                                            );
                                        Navigator.of(
                                          context,
                                        ).pushNamed(updatePostRoute);
                                    }
                                  },
                                  itemBuilder: (context) {
                                    return [
                                      PopupMenuItem<MenuAction>(
                                        height: 2.1,

                                        value: MenuAction.delete,
                                        child: Text('delete'),
                                      ),

                                      PopupMenuItem<MenuAction>(
                                        height: 2.1,

                                        value: MenuAction.update,
                                        child: Text('update'),
                                      ),
                                    ];
                                  },
                                )
                              : SizedBox.shrink(),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        postData['userPostText'] ?? '',
                        style: TextStyles.profileHeaderText.copyWith(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      if ((postData['postImageUrl'] ?? '').isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.network(postData['postImageUrl']),
                          ),
                        ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          !(((postData["likedBy"] ?? []) as List<dynamic>)
                                      .contains(
                                        FirebaseAuth.instance.currentUser!.uid,
                                      ) &&
                                  (((postData["isLiked"] ?? [])
                                          as List<dynamic>)
                                      .contains(
                                        FirebaseAuth.instance.currentUser!.uid,
                                      )))
                              ? GestureDetector(
                                  onTap: () async {
                                    final currentUser =
                                        FirebaseAuth.instance.currentUser!.uid;
                                    final isThatUseWhoLiked =
                                        ((postData["likedBy"] ?? [])
                                                as List<dynamic>)
                                            .contains(currentUser);

                                    if (!isThatUseWhoLiked ||
                                        isThatUseWhoLiked) {
                                      await FirebaseFirestore.instance
                                          .collection("posts")
                                          .doc(postData["documentId"])
                                          .update({
                                            'likedBy': FieldValue.arrayUnion([
                                              FirebaseAuth
                                                  .instance
                                                  .currentUser!
                                                  .uid,
                                            ]),
                                            'isLiked': FieldValue.arrayUnion([
                                              FirebaseAuth
                                                  .instance
                                                  .currentUser!
                                                  .uid,
                                            ]),
                                            'likeCount': FieldValue.increment(
                                              1,
                                            ),
                                          });
                                      await FirebaseFirestore.instance
                                          .collection(
                                            'postReactionCommentNotification',
                                          )
                                          .add({
                                            "notifSenderId": FirebaseAuth
                                                .instance
                                                .currentUser!
                                                .uid,
                                            "notifRecieverId":
                                                postData['userId'],
                                            "notifSenderImg":
                                                Provider.of<
                                                      NotificationNotifier
                                                    >(context, listen: false)
                                                    .notifSenderImage,
                                            "notifSenderName":
                                                Provider.of<
                                                      NotificationNotifier
                                                    >(context, listen: false)
                                                    .notifSenderName,
                                            "createdAt":
                                                FieldValue.serverTimestamp(),
                                          });
                                    }
                                  },
                                  child: Icon(FluentIcons.heart_16_regular),
                                )
                              : GestureDetector(
                                  onTap: () async {
                                    final currentUser =
                                        FirebaseAuth.instance.currentUser!.uid;
                                    final isThatUseWhoLiked =
                                        ((postData["likedBy"] ?? [])
                                                as List<dynamic>)
                                            .contains(currentUser);

                                    if (isThatUseWhoLiked) {
                                      await FirebaseFirestore.instance
                                          .collection("posts")
                                          .doc(postData["documentId"])
                                          .update({
                                            'likeCount': FieldValue.increment(
                                              -1,
                                            ),
                                            'isLiked': FieldValue.arrayRemove([
                                              FirebaseAuth
                                                  .instance
                                                  .currentUser!
                                                  .uid,
                                            ]),
                                          });
                                    }
                                  },
                                  child: Icon(FluentIcons.heart_16_filled),
                                ),

                          const SizedBox(width: 5),
                          Text(postData['likeCount'].toString()),
                          const SizedBox(width: 17),

                          GestureDetector(
                            onTap: () async {
                              context.read<PostCommentNotifier>().setDocId(
                                postData['documentId'],
                              );
                              showCommentsSheet(
                                context,
                                Provider.of<PostCommentNotifier>(
                                  context,
                                  listen: false,
                                ).docId,
                              );
                            },
                            child: Icon(FluentIcons.comment_28_regular),
                          ),
                          const SizedBox(width: 5),
                          Text(postData['totalComment'].toString()),
                        ],
                      ),
                    ],
                  ),
                );
              },
            );
          }

          return Center(child: Text('Loading'));
        },
      ),
    );
  }
}

void showCommentsSheet(BuildContext context, String postId) {
  final TextEditingController commentController = TextEditingController();
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              height: 5,
              width: 40,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('posts')
                    .doc(postId)
                    .collection('comments')
                    .orderBy('timestamp', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final comments = snapshot.data!.docs;
                  FirebaseFirestore.instance
                      .collection('posts')
                      .doc(postId)
                      .update({'totalComment': comments.length});
                  if (comments.isEmpty) {
                    return const Center(child: Text("No comments yet."));
                  }

                  return ListView.builder(
                    itemCount: comments.length,
                    itemBuilder: (context, index) {
                      final comment = comments[index];

                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(comment['userImage']),
                        ),
                        title: Text(comment['userName']),
                        subtitle: Text(comment['commentText']),
                      );
                    },
                  );
                },
              ),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 10,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: commentController,
                      decoration: const InputDecoration(
                        hintText: "Add a comment...",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.send, color: Colors.blue),
                    onPressed: () async {
                      final text = commentController.text;
                      if (text.isNotEmpty) {
                        await FirebaseFirestore.instance
                            .collection('posts')
                            .doc(postId)
                            .collection('comments')
                            .add({
                              'userId': FirebaseAuth.instance.currentUser!.uid,
                              'userName': Provider.of<ProfileSettingsNotifier>(
                                context,
                                listen: false,
                              ).userName,
                              'userImage': Provider.of<ProfileSettingsNotifier>(
                                context,
                                listen: false,
                              ).profileImageUrl,
                              'commentText': text,
                              'timestamp': FieldValue.serverTimestamp(),
                            });

                        commentController.clear(); // Clear input field
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    },
  );
}

void showSnckBarr(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(text),
      duration: const Duration(seconds: 3),
      backgroundColor: Colors.black,
      padding: EdgeInsets.all(14),
    ),
  );
}
          // if (snapshot.hasData) {
          //   final docs = snapshot.data!.docs;
          //   final postData = docs.first.data();
          //   return Padding(
          //     padding: const EdgeInsets.all(8.0),
          //     child: SingleChildScrollView(
          //       child: Padding(
          //         padding: const EdgeInsets.all(7.2),
          //         child: Column(
          //           children: [
          //             Container(
          //               width: size.width * 0.93,
          //               margin: EdgeInsets.only(bottom: 12),
          //               decoration: BoxDecoration(
          //                 color: const Color.fromARGB(255, 254, 251, 251),
          //                 borderRadius: BorderRadius.circular(30),
          //               ),
          //               child: Column(
          //                 children: [
          //                   SizedBox(height: 10),
          //                   Container(
          //                     margin: EdgeInsets.only(bottom: 12),
          //                     width: size.width * .8,
          //                     child: Wrap(
          //                       children: [
          //                         Row(
          //                           mainAxisAlignment:
          //                               MainAxisAlignment.spaceBetween,
          //                           children: [
          //                             Row(
          //                               children: [
          //                                 Padding(
          //                                   padding: const EdgeInsets.only(
          //                                     top: 12.0,
          //                                   ),
          //                                   child: CircleAvatar(
          //                                     backgroundImage: NetworkImage(
          //                                       postData['userImageUrl'] ?? '',
          //                                     ),
          //                                     radius: 24,
          //                                   ),
          //                                 ),
          //                                 SizedBox(width: 9),
          //                                 Column(
          //                                   crossAxisAlignment:
          //                                       CrossAxisAlignment.start,
          //                                   children: [
          //                                     Text(
          //                                       postData['userName'],
          //                                       style: TextStyles.userTitle,
          //                                     ),
          //                                     Text(
          //                                       'Posted 3m ago',
          //                                       style: TextStyles
          //                                           .profileHeaderText
          //                                           .copyWith(
          //                                             fontWeight:
          //                                                 FontWeight.w300,
          //                                             fontSize: 13,
          //                                           ),
          //                                     ),
          //                                   ],
          //                                 ),
          //                               ],
          //                             ),
          //                             PopupMenuButton<MenuAction>(
          //                               onSelected: (value) {
          //                                 print(value);
          //                               },
          //                               itemBuilder: (context) {
          //                                 return [
          //                                   PopupMenuItem<MenuAction>(
          //                                     value: MenuAction.delete,
          //                                     child: Text('Delete'),
          //                                   ),
          //                                 ];
          //                               },
          //                             ),
          //                           ],
          //                         ),

          //                         Padding(
          //                           padding: const EdgeInsets.only(
          //                             top: 7.0,
          //                             left: 1.0,
          //                           ),
          //                           child: Text(
          //                             style: TextStyles.profileHeaderText
          //                                 .copyWith(
          //                                   fontSize: 13.5,
          //                                   fontWeight: FontWeight.w400,
          //                                 ),
          //                             // maxLines: 100, //modify for specific user
          //                             postData['userPostText'],
          //                           ),
          //                         ),

          //                         (postData['postImageUrl'] != null)
          //                             ? Padding(
          //                                 padding: const EdgeInsets.only(
          //                                   top: 12,
          //                                 ),
          //                                 child: ClipRRect(
          //                                   clipBehavior: Clip.antiAlias,
          //                                   borderRadius:
          //                                       BorderRadiusGeometry.circular(
          //                                         16,
          //                                       ),
          //                                   child: Image.network(
          //                                     postData['postImageUrl'],
          //                                   ),
          //                                 ),
          //                               )
          //                             : SizedBox(),
          //                         Padding(
          //                           padding: const EdgeInsets.only(top: 11),
          //                           child: Row(
          //                             children: [
          //                               GestureDetector(
          //                                 onTap: () {
          //                                   print('reactions');
          //                                 },
          //                                 child: Row(
          //                                   children: [
          //                                     Icon(
          //                                       FluentIcons.heart_16_regular,
          //                                     ),
          //                                     SizedBox(width: 5),
          //                                     Text('574'),
          //                                   ],
          //                                 ),
          //                               ),
          //                               SizedBox(width: 17),
          //                               GestureDetector(
          //                                 onTap: () {
          //                                   print('commented');
          //                                 },
          //                                 child: Row(
          //                                   children: [
          //                                     Icon(
          //                                       FluentIcons.comment_28_regular,
          //                                     ),
          //                                     SizedBox(width: 5),
          //                                     Text('450'),
          //                                   ],
          //                                 ),
          //                               ),
          //                             ],
          //                           ),
          //                         ),
          //                       ],
          //                     ),
          //                   ),
          //                 ],
          //               ),
          //             ),
          //           ],
          //         ),
          //       ),
          //     ),
          //   );
          // }