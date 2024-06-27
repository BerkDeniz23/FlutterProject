import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_places/model/conversation_model.dart';

import '../model/app_constants.dart';

class InboxViewModel {
  getConversations() {
    return FirebaseFirestore.instance
        .collection('conversations')
        .where('userIDs', arrayContains: AppConstants.currentUser.id)
        .orderBy('lastMessageDateTime', descending: true)
        .snapshots();
  }

  getMessages(ConversationModel? conversation) {
    return FirebaseFirestore.instance
        .collection('conversations/${conversation!.id}/messages')
        .orderBy('dateTime')
        .snapshots();
  }
}

final inboxViewModel = InboxViewModel();
