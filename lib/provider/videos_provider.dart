import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:nunc_system_task/database/database.dart';
import 'package:nunc_system_task/models/videos_model.dart';
import 'package:drift/drift.dart';

class VideosProvider with ChangeNotifier {
  static final database = AppDatabase();

  static Future saveVideosToDB() async {
    List<VideosTableCompanion> items = [];
    debugPrint('Saving videos to database..');
    try {
      final String response =
          await rootBundle.loadString('assets/sample_response.json');
      List<VideosModel> videosModel = videosModelFromJson(response);

      for (VideosModel item in videosModel) {
        VideosTableCompanion videos = VideosTableCompanion.insert(
          video_id: Value(item.videoId),
          video_fk: Value(item.videoFk),
          views: Value(item.views),
          videourl: Value(item.videourl),
          rendering: Value(item.rendering),
          thumbnail: Value(item.thumbnail),
          lastupdate: Value(item.lastupdate),
          video_local_title: Value(item.videoLocalTitle),
          video_title: Value(item.videoTitle),
          video_progress: const Value(0),
        );
        items.add(videos);
      }

      database.insertMultipleEntries(items);
      debugPrint('Saved to database');
    } catch (e) {
      debugPrint(e.toString());
      throw Exception(e.toString());
    }
  }

  static Future<List<VideosModel>> getVideosFromDB() async {
    List<VideosModel> videosFromDatabase = [];
    debugPrint('Fetching videos from database..');
    try {
      database.allVideosItems.then((value) {
        for (VideosTableData video in value) {
          VideosModel model = VideosModel(
            videoId: video.video_id ?? '',
            videoFk: video.video_fk ?? '',
            views: video.views ?? '',
            videourl: video.videourl ?? '',
            rendering: video.rendering ?? '',
            thumbnail: video.thumbnail ?? '',
            lastupdate: video.lastupdate??'',
            videoLocalTitle: video.video_local_title ?? '',
            videoTitle: video.video_title ?? '',
          );
          videosFromDatabase.add(model);
        }
      });
    } catch (e) {
      debugPrint(e.toString());
      throw Exception(e.toString());
    }
    return videosFromDatabase;
  }
}
