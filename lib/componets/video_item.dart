import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:nunc_system_task/models/videos_model.dart';

import '../database/database.dart';

class VideoItem extends StatelessWidget {
  const VideoItem({super.key, required this.item});
  final VideosTableData item;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, '/video_player_page', arguments: item);
        },
        child: Column(
          children: [
            Row(
              children: [
                CachedNetworkImage(
                  width: 75,
                  height: 75,
                  imageUrl: item.thumbnail!,
                  //placeholder: (context, url) => const CircularProgressIndicator(),
                  errorWidget: (context, url, error) => const Icon(
                    Icons.video_call_sharp,
                    color: Colors.red,
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.video_title!),
                    Text(item.video_local_title!),
                    Text(item.rendering!),
                    const Text('Flick Fusion'),
                  ],
                ),
                const Spacer(),
                const Icon(Icons.share),
              ],
            ),
            const Divider(
              height: 20,
              color: Colors.black12,
            ),
          ],
        ),
      ),
    );
  }
}
