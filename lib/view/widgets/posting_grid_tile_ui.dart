import 'package:flutter/material.dart';
import 'package:flutter_places/model/posting_model.dart';
import 'package:custom_rating_bar/custom_rating_bar.dart';

class PostingGridTileUI extends StatefulWidget {
  final PostingModel? posting;

  const PostingGridTileUI({
    Key? key,
    this.posting,
  }) : super(key: key);

  @override
  State<PostingGridTileUI> createState() => _PostingGridTileUIState();
}

class _PostingGridTileUIState extends State<PostingGridTileUI> {
  PostingModel? posting;

  @override
  void initState() {
    super.initState();
    posting = widget.posting;
    updateUI();
  }

  updateUI() async {
    if (posting != null) {
      await posting!.getFirstImageFromStorage();
      if (mounted) {
        setState(() {});
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 4 / 3,
              child: (posting?.displayImages?.isEmpty ?? true)
                  ? Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Icon(
                        Icons.image,
                        size: 50,
                        color: Colors.grey.shade700,
                      ),
                    )
                  : Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        image: DecorationImage(
                          image: posting!.displayImages!.first,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
            ),
            const SizedBox(height: 8),
            Text(
              posting?.name ?? 'Adı bilinmiyor',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Text(
                  posting?.type ?? 'Tip bilinmiyor',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
                const SizedBox(width: 6),
                Row(
                  children: [
                    const Icon(
                      Icons.location_pin,
                      size: 14,
                      color: Colors.red,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      posting?.city ?? 'Şehir bilinmiyor',
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                const SizedBox(width: 10),
                Row(
                  children: [
                    const Icon(
                      Icons.price_check_sharp,
                      size: 14,
                      color: Colors.black,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      "${posting?.price ?? 0} TL",
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(
                  Icons.person,
                  size: 14,
                ),
                const SizedBox(width: 4),
                Text(
                  "${posting?.capacity ?? 0} kişi",
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
              ],
            ),
            const SizedBox(height: 4),
            RatingBar.readOnly(
              size: 20.0,
              maxRating: 5,
              initialRating: posting?.getCurrentRating() ?? 0,
              filledIcon: Icons.star,
              emptyIcon: Icons.star_border,
              filledColor: const Color.fromARGB(255, 140, 219, 188),
            ),
          ],
        ),
      ),
    );
  }
}
