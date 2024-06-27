// ignore_for_file: must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_places/global.dart';
import 'package:flutter_places/model/app_constants.dart';
import 'package:flutter_places/model/conversation_model.dart';
import 'package:flutter_places/model/message_model.dart';
import 'package:flutter_places/view/widgets/message_list_tile_ui.dart';

class ConversationScreen extends StatefulWidget {
  ConversationModel? conversation;

  ConversationScreen({
    super.key,
    this.conversation,
  });

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  ConversationModel? conversation;
  TextEditingController controller = TextEditingController();

  sendMessage() {
    String text = controller.text;

    if (text.isEmpty) {
      return;
    }

    conversation!.addMessageToFirestore(text).whenComplete(() {
      setState(() {
        controller.text = "";
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    conversation = widget.conversation;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(color: Colors.white),
        backgroundColor: Color.fromARGB(255, 140, 219, 188),
        title: Text(
          conversation!.otherContact!.getFullNameOfUser(),
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: inboxViewModel.getMessages(conversation),
              builder: (context, snapshots) {
                if (snapshots.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  return ListView.builder(
                    itemCount: snapshots.data!.docs.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot snapshot = snapshots.data!.docs[index];
                      MessageModel currentMessage = MessageModel();
                      currentMessage.getMessageInfoFromFirestore(snapshot);

                      if (currentMessage.sender!.id == AppConstants.currentUser.id) {
                        currentMessage.sender = AppConstants.currentUser.createContactFromUser();
                      } else {
                        currentMessage.sender = conversation!.otherContact;
                      }

                      return MessageListTileUI(
                        message: currentMessage,
                      );
                    },
                  );
                }
              },
            ),
          ),
          Container(
            decoration: BoxDecoration(
                border: Border.all(
              color: Colors.black,
            )),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 5 / 6,
                  child: TextField(
                    decoration: const InputDecoration(
                        hintText: 'Mesaj yaz',
                        contentPadding: EdgeInsets.all(20.0),
                        border: InputBorder.none),
                    minLines: 1,
                    maxLines: 5,
                    style: const TextStyle(fontSize: 20.0),
                    controller: controller,
                  ),
                ),
                Expanded(
                  child: IconButton(
                    onPressed: () {
                      sendMessage();
                    },
                    icon: const Icon(Icons.send),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
