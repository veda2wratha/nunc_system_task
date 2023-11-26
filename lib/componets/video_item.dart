import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:nunc_system_task/models/videos_model.dart';

class VideoItem extends StatelessWidget {
  const VideoItem(this.item, {super.key});
  final VideosModel item;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
      child: Row(
        children: [
          InkWell(
            child: CachedNetworkImage(
              width: 75,
              height: 75,
              imageUrl: item.thumbnail,
              //placeholder: (context, url) => const CircularProgressIndicator(),
              errorWidget: (context, url, error) => const Icon(
                Icons.video_call_sharp,
                color: Colors.red,
              ),
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(item.videoTitle),
              Text(item.videoLocalTitle),
              Text(item.rendering),
              const Text('Flick Fusion'),
            ],
          ),
          const Spacer(),
          // const SizedBox(
          //   width: 20,
          // ),
          const Icon(Icons.share),
        ],
      ),
    );
  }
}
