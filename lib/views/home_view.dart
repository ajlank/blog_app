import 'package:blog_app/base/styles/text_styles.dart';
import 'package:blog_app/controller/profile_settings_notifier.dart';
import 'package:blog_app/utils/constants/app_routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum MenuAction { delete, update }

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 225, 227, 230),
      appBar: AppBar(
        backgroundColor: Colors.white,
        actionsPadding: EdgeInsets.all(12),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(FluentIcons.home_12_regular)),
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(profileRoute);
            },
            icon: Icon(FluentIcons.person_12_regular),
          ),
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(profileSettingsRoute);
            },
            icon: Icon(FluentIcons.settings_16_filled),
          ),
          IconButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              context.read<ProfileSettingsNotifier>().clearUserDetails();
            },
            icon: Icon(FluentIcons.arrow_exit_20_filled),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(7.2),
            child: Column(
              children: [
                Container(
                  width: size.width * 0.93,
                  margin: EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 254, 251, 251),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: 10),
                      Container(
                        margin: EdgeInsets.only(bottom: 12),
                        width: size.width * .8,
                        child: Wrap(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 12.0),
                                      child: CircleAvatar(radius: 24),
                                    ),
                                    SizedBox(width: 9),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Azunyan U. Wu',
                                          style: TextStyles.userTitle,
                                        ),
                                        Text(
                                          'Posted 3m ago',
                                          style: TextStyles.profileHeaderText
                                              .copyWith(
                                                fontWeight: FontWeight.w300,
                                                fontSize: 13,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                PopupMenuButton<MenuAction>(
                                  onSelected: (value) {
                                    print(value);
                                  },
                                  itemBuilder: (context) {
                                    return [
                                      PopupMenuItem<MenuAction>(
                                        value: MenuAction.delete,
                                        child: Text('Delete'),
                                      ),
                                    ];
                                  },
                                ),
                              ],
                            ),

                            Padding(
                              padding: const EdgeInsets.only(
                                top: 7.0,
                                left: 1.0,
                              ),
                              child: Text(
                                // maxLines: 100, //modify for specific user
                                "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
                              ),
                            ),

                            !(1 > 2)
                                ? Padding(
                                    padding: const EdgeInsets.only(top: 12),
                                    child: ClipRRect(
                                      clipBehavior: Clip.antiAlias,
                                      borderRadius:
                                          BorderRadiusGeometry.circular(16),
                                      child: Image.network(
                                        'https://tse3.mm.bing.net/th/id/OIP.L_wr5vbGvq_E1sIRrx5dUwHaEo?pid=Api&P=0&h=220',
                                      ),
                                    ),
                                  )
                                : SizedBox(),
                            Padding(
                              padding: const EdgeInsets.only(top: 11),
                              child: Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      print('reactions');
                                    },
                                    child: Row(
                                      children: [
                                        Icon(FluentIcons.heart_16_regular),
                                        SizedBox(width: 5),
                                        Text('574'),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 17),
                                  GestureDetector(
                                    onTap: () {
                                      print('commented');
                                    },
                                    child: Row(
                                      children: [
                                        Icon(FluentIcons.comment_28_regular),
                                        SizedBox(width: 5),
                                        Text('450'),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        context
                            .watch<ProfileSettingsNotifier>()
                            .userName
                            .toString(),
                      ),

                      Image.network(
                        context
                            .watch<ProfileSettingsNotifier>()
                            .profileImageUrl,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
