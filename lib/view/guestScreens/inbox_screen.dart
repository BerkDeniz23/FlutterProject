// ignore_for_file: must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_places/global.dart';
import 'package:flutter_places/model/conversation_model.dart';
import 'package:flutter_places/model/posting_model.dart';
import 'package:flutter_places/view/conversation_screen.dart';
import 'package:flutter_places/view/widgets/conversation_list_tile_ui.dart';
import 'package:get/get.dart';

class InboxScreen extends StatefulWidget {
  PostingModel? posting;
  String? hostID;

  InboxScreen({super.key});

  @override
  State<InboxScreen> createState() => _InboxScreenState();
}

class _InboxScreenState extends State<InboxScreen> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: inboxViewModel.getConversations(),
      builder: (context, dataSnapshot) {
        if (dataSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (dataSnapshot.hasError) {
          return Center(child: Text('Error: ${dataSnapshot.error}'));
        } else if (!dataSnapshot.hasData || dataSnapshot.data!.docs.isEmpty) {
          return const Center(child: Text('Konuşma Yok'));
        } else {
          List<DocumentSnapshot> sortedDocs = dataSnapshot.data!.docs;
          sortedDocs.sort((a, b) {
            Timestamp tsA = a['lastMessageDateTime'];
            Timestamp tsB = b['lastMessageDateTime'];
            return tsB.compareTo(tsA);
          });

          return ListView.builder(
            itemCount: sortedDocs.length,
            itemExtent: MediaQuery.of(context).size.height / 9,
            itemBuilder: (context, index) {
              DocumentSnapshot snapshot = sortedDocs[index];

              ConversationModel currentConversation = ConversationModel();
              currentConversation.getConversationInfoFromFirestore(snapshot);

              return InkResponse(
                onTap: () {
                  Get.to(() => ConversationScreen(
                        conversation: currentConversation,
                      ));
                },
                child: ConversationListTileUI(
                  conversation: currentConversation,
                ),
              );
            },
          );
        }
      },
    );
  }
}
