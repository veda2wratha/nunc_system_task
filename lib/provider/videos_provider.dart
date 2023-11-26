import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:nunc_system_task/models/videos_model.dart';

class VideosProvider with ChangeNotifier {
  static late List<VideosModel> videosModel;
  static Future<List<VideosModel>> getVideos() async {
    debugPrint('Fetching videos..');
    try {
      final String response =
          await rootBundle.loadString('assets/sample_response.json');
      videosModel = videosModelFromJson(response);
    } catch (e) {
      throw Exception(e.toString());
    }
    return videosModel;
  }
}
