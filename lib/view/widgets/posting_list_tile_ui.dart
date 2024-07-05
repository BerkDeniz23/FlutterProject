// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_places/model/posting_model.dart';

class PostingListTileUI extends StatefulWidget {
  PostingModel? posting;

  PostingListTileUI({
    super.key,
    this.posting,
  });

  @override
  State<PostingListTileUI> createState() => _PostingListTileUIState();
}

class _PostingListTileUIState extends State<PostingListTileUI> {
  PostingModel? posting;

  @override
  void initState() {
    super.initState();

    posting = widget.posting;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Text(
                  posting!.name!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 100,
              height: 66.67,
              child: Image(
                image: posting!.displayImages!.first,
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
