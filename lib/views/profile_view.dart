import 'package:blog_app/base/styles/text_styles.dart';
import 'package:blog_app/controller/notification_notifier.dart';
import 'package:blog_app/controller/profile_settings_notifier.dart';
import 'package:blog_app/customs/custom_clipper.dart';
import 'package:blog_app/utils/constants/app_routes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    Future<int> getUserPostCount(String userId) async {
      final snapshot = await FirebaseFirestore.instance
          .collection('posts')
          .where('userId', isEqualTo: userId)
          .get();

      return snapshot.docs.length;
    }

    Future<int> getUserReactionCount(String userId) async {
      double totalReaction = 0;
      final snapshots = await FirebaseFirestore.instance
          .collection('posts')
          .where('userId', isEqualTo: userId)
          .get();

      for (var doc in snapshots.docs) {
        totalReaction += doc.data()['likeCount'] ?? 0;
      }
      return totalReaction.toInt();
    }

    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("profilesettings")
            .where("userId", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text('Loading..');
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Please update your profile and navigate to this view"),

                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed(profileSettingsRoute);
                    },
                    child: const Text('Update profile'),
                  ),
                ],
              ),
            );
          }
          if (snapshot.hasData) {
            final docs = snapshot.data!.docs;
            final profileData = docs.first.data();
            context.read<ProfileSettingsNotifier>().setUserDetals(
              profileData['profileImageUrl'],
              profileData['name'],
            );
            context.read<NotificationNotifier>().setNotifierSenderImage(
              profileData['profileImageUrl'],
            );
            context.read<NotificationNotifier>().setNotifierSenderName(
              profileData['name'],
            );

            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  backgroundColor: Colors.white,
                  expandedHeight: 300.0,
                  pinned: false,
                  snap: false,
                  floating: false,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Stack(
                      children: [
                        ClipPath(
                          clipper: CurveClipper(),
                          child: Image.network(
                            profileData['coverImageUrl'],
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: 300,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Container(
                    color: Colors.white,
                    height: 100,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          child: Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  Navigator.of(
                                    context,
                                  ).pushNamed(createPostRoute);
                                },
                                icon: Icon(FluentIcons.add_16_regular),
                              ),
                              IconButton(
                                onPressed: () {
                                  Navigator.of(context).pushNamedAndRemoveUntil(
                                    homeRoute,
                                    (_) => false,
                                  );
                                },
                                icon: Icon(FluentIcons.home_12_regular),
                              ),

                              GestureDetector(
                                onTap: () {
                                  Navigator.of(
                                    context,
                                  ).pushNamed(profileSettingsRoute);
                                },
                                child: Container(
                                  padding: EdgeInsets.all(3),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(15),
                                    ),
                                    border: Border.all(
                                      color: const Color.fromARGB(
                                        255,
                                        142,
                                        140,
                                        140,
                                      ),
                                    ),
                                  ),
                                  child: Icon(Icons.settings),
                                ),
                              ),
                              SizedBox(width: 30),
                              CircleAvatar(
                                radius: 50,
                                backgroundImage: NetworkImage(
                                  profileData['profileImageUrl'],
                                ),
                              ),

                              SizedBox(width: 30),
                              GestureDetector(
                                onTap: () async {},
                                child: Container(
                                  padding: EdgeInsets.all(3),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(15),
                                    ),
                                    border: Border.all(
                                      color: const Color.fromARGB(
                                        255,
                                        142,
                                        140,
                                        140,
                                      ),
                                      width: 0.6,
                                    ),
                                  ),
                                  child: Icon(Icons.settings),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 50),
                      ],
                    ),
                  ),
                ),

                SliverToBoxAdapter(
                  child: Container(
                    color: Colors.white,
                    height: 100,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Member since Dec 2024',
                              style: TextStyles.profileHeaderText.copyWith(
                                fontWeight: FontWeight.w300,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              profileData['name'] ?? 'Your name',
                              style: TextStyles.profileHeaderText,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Container(
                    height: 100,
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 50, right: 50),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: 70,
                            width: 70,
                            decoration: BoxDecoration(
                              border: Border(
                                right: BorderSide(
                                  width: 0.6,
                                  color: const Color.fromARGB(
                                    255,
                                    161,
                                    159,
                                    159,
                                  ),
                                ),
                              ),
                            ),
                            child: Column(
                              children: [
                                Icon(Icons.post_add),
                                SizedBox(height: 4),
                                FutureBuilder<int>(
                                  future: getUserPostCount(
                                    profileData['userId'],
                                  ),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return SizedBox(
                                        height: 14,
                                        width: 14,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      );
                                    } else if (snapshot.hasError) {
                                      return Text("0");
                                    } else {
                                      return Text(snapshot.data.toString());
                                    }
                                  },
                                ),
                                SizedBox(height: 4),

                                Text(
                                  'Total Posts',
                                  style: TextStyles.profileHeaderText.copyWith(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Container(
                            height: 70,
                            width: 70,
                            decoration: BoxDecoration(
                              border: Border(
                                right: BorderSide(
                                  width: 0.6,
                                  color: const Color.fromARGB(
                                    255,
                                    161,
                                    159,
                                    159,
                                  ),
                                ),
                              ),
                            ),
                            child: Column(
                              children: [
                                Icon(Icons.people),
                                SizedBox(height: 4),
                                Text(profileData['followCount'].toString()),
                                SizedBox(height: 4),

                                Text(
                                  'Followers',
                                  style: TextStyles.profileHeaderText.copyWith(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: 70,
                            width: 70,
                            decoration: BoxDecoration(
                              border: Border(
                                right: BorderSide(
                                  width: 0.6,
                                  color: const Color.fromARGB(
                                    255,
                                    161,
                                    159,
                                    159,
                                  ),
                                ),
                              ),
                            ),
                            child: Column(
                              children: [
                                Icon(Icons.favorite),
                                SizedBox(height: 4),
                                FutureBuilder<int>(
                                  future: getUserReactionCount(
                                    profileData['userId'],
                                  ),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return SizedBox(
                                        height: 14,
                                        width: 14,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      );
                                    } else if (snapshot.hasError) {
                                      return Text("0");
                                    } else {
                                      return Text(snapshot.data.toString());
                                    }
                                  },
                                ),
                                SizedBox(height: 4),

                                Text(
                                  'Reactions',
                                  style: TextStyles.profileHeaderText.copyWith(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Container(
                    height: 60,
                    color: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushNamed(followerViewRoute);
                          },
                          child: Container(
                            height: 40,
                            width: 130,
                            decoration: BoxDecoration(
                              color: Colors.brown,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  'Followers',
                                  style: TextStyles.profileButtonDesign
                                      .copyWith(fontSize: 15),
                                ),
                                Icon(
                                  Icons.people_alt_outlined,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushNamed(messagesRoute);
                          },
                          child: Container(
                            height: 40,
                            width: 130,
                            decoration: BoxDecoration(
                              color: Colors.brown,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                SizedBox(width: 6),
                                Text(
                                  'Messages',
                                  style: TextStyles.profileButtonDesign
                                      .copyWith(fontSize: 14),
                                ),
                                SizedBox(width: 5),
                                Icon(Icons.chat, color: Colors.white),
                                Container(
                                  margin: EdgeInsets.only(bottom: 25),
                                  child: Badge(label: Text('1')),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SliverToBoxAdapter(
                  child: Container(
                    height: 60,
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 35.0, left: 20),
                      child: Row(
                        children: [
                          Text('About', style: TextStyles.aboutDesign),
                        ],
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Container(
                    height: 500,
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Container(child: Text(profileData['about'])),
                    ),
                  ),
                ),
              ],
            );
          }
          return Text('Loading');
        },
      ),
    );
  }
}
