import 'dart:io';

class MediaModel {
  final File file;
  final bool isVideo;
  final String aspectRatio;

  MediaModel({
    required this.file,
    required this.isVideo,
    required this.aspectRatio,
  });
}
