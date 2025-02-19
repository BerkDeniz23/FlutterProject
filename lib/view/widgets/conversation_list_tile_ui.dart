// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_places/global.dart';
import 'package:flutter_places/model/conversation_model.dart';
import 'package:flutter_places/model/posting_model.dart';

class ConversationListTileUI extends StatefulWidget {
  ConversationModel? conversation;

  ConversationListTileUI({
    super.key,
    this.conversation,
  });

  @override
  State<ConversationListTileUI> createState() => _ConversationListTileUIState();
}

class _ConversationListTileUIState extends State<ConversationListTileUI> {
  ConversationModel? conversation;

  getImageOfOtherContact() {
    conversation!.otherContact!.getImageFromStorage().whenComplete(() {
      setState(() {});
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    conversation = widget.conversation;

    getImageOfOtherContact();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: GestureDetector(
        onTap: () {},
        child: CircleAvatar(
          backgroundImage: conversation!.otherContact!.displayImage,
          radius: MediaQuery.of(context).size.width / 14.0,
        ),
      ),
      title: Text(
        conversation!.otherContact!.getFullNameOfUser(),
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18.5,
        ),
      ),
      subtitle: Text(
        widget.conversation!.lastMessage!.text!,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Text(
        widget.conversation!.lastMessage!.getMessageDateTime(),
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}
