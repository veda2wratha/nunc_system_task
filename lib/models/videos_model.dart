// To parse this JSON data, do
//
// final videosModel = videosModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

List<VideosModel> videosModelFromJson(String str) => List<VideosModel>.from(
    json.decode(str).map((x) => VideosModel.fromJson(x)));

String videosModelToJson(List<VideosModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class VideosModel {
  final String videoId;
  final String videoFk;
  final String views;
  final String videourl;
  final String rendering;
  final String thumbnail;
  final DateTime lastupdate;
  final String videoLocalTitle;
  final String videoTitle;

  VideosModel({
    required this.videoId,
    required this.videoFk,
    required this.views,
    required this.videourl,
    required this.rendering,
    required this.thumbnail,
    required this.lastupdate,
    required this.videoLocalTitle,
    required this.videoTitle,
  });

  factory VideosModel.fromJson(Map<String, dynamic> json) => VideosModel(
        videoId: json["video_id"],
        videoFk: json["video_fk"],
        views: json["views"],
        videourl: json["videourl"],
        rendering: json["rendering"],
        thumbnail: json["thumbnail"],
        lastupdate: DateTime.parse(json["lastupdate"]),
        videoLocalTitle: json["video_local_title"],
        videoTitle: json["video_title"],
      );

  Map<String, dynamic> toJson() => {
        "video_id": videoId,
        "video_fk": videoFk,
        "views": views,
        "videourl": videourl,
        "rendering": rendering,
        "thumbnail": thumbnail,
        "lastupdate": lastupdate.toIso8601String(),
        "video_local_title": videoLocalTitle,
        "video_title": videoTitle,
      };
}
