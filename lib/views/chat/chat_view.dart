import 'package:blog_app/controller/home_user_profile_notifier.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatView extends StatefulWidget {
  const ChatView({super.key});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  late final TextEditingController _messageController;
  late final TextEditingController _recieverMessageController;
  @override
  void initState() {
    _messageController = TextEditingController();
    _recieverMessageController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _recieverMessageController.dispose();
    super.dispose();
  }

  Future<void> sendMessageHandler() async {
    try {
      await FirebaseFirestore.instance.collection("UserChatting").add({
        'senderId': FirebaseAuth.instance.currentUser!.uid,
        'senderMessage': _messageController.text,
        'recieverId': Provider.of<HomeUserProfileNotifier>(
          context,
          listen: false,
        ).homeUserId,
        "recieverName": Provider.of<HomeUserProfileNotifier>(
          context,
          listen: false,
        ).homeUserName,
        'recieverMessage': _recieverMessageController.text,
        "IdsAsArray": FieldValue.arrayUnion([
          FirebaseAuth.instance.currentUser!.uid,
          Provider.of<HomeUserProfileNotifier>(
            context,
            listen: false,
          ).homeUserId,
        ]),
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print(e.toString());
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
                  .collection('UserChatting')
                  .orderBy("createdAt", descending: false)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Text('No data');
                }
                if (snapshot.hasData) {
                  final docs = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      final data = docs[index].data();
                      return (data["senderId"] ==
                                  FirebaseAuth.instance.currentUser!.uid &&
                              data["recieverId"] ==
                                  context
                                      .watch<HomeUserProfileNotifier>()
                                      .homeUserId)
                          ? Column(
                              children: [
                                ListTile(
                                  title: Text(
                                    data['recieverMessage'],
                                    style: TextStyle(fontSize: 13.2),
                                  ),

                                  trailing: Text(
                                    data['senderMessage'],
                                    style: TextStyle(fontSize: 13.2),
                                  ),
                                ),
                              ],
                            )
                          : SizedBox.shrink();
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
              controller:
                  (FirebaseAuth.instance.currentUser!.uid ==
                      context.watch<HomeUserProfileNotifier>().homeUserId)
                  ? _recieverMessageController
                  : _messageController,
              decoration: InputDecoration(
                hintText:
                    (FirebaseAuth.instance.currentUser!.uid ==
                        context.watch<HomeUserProfileNotifier>().homeUserId)
                    ? 'Write your message as receiver'
                    : 'Write your message as sender',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  onPressed: () async {
                    await sendMessageHandler();
                    FocusScope.of(context).unfocus(); // dismiss keyboard
                    _recieverMessageController.clear();
                    _messageController.clear();
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
