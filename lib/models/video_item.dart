// models/video_item.dart
enum VideoSourceType { file, url }

class VideoItem {
  final String title;
  final String source;
  final VideoSourceType sourceType;
  final String duration;

  VideoItem({
    required this.title,
    required this.source,
    required this.sourceType,
    required this.duration,
  });

  bool get isFile => sourceType == VideoSourceType.file;
  bool get isUrl => sourceType == VideoSourceType.url;
}