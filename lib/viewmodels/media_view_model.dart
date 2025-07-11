import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';
import '../models/media_model.dart';

class MediaViewModel extends ChangeNotifier {
  MediaModel? _media;
  MediaModel? get media => _media;

  VideoPlayerController? _videoController;
  VideoPlayerController? get videoController => _videoController;

  Future<void> loadFromGallery(File file, bool isVideo) async {
    await _prepareMedia(file, isVideo);
  }

  Future<void> loadFromUrl(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final ext = path.extension(url).toLowerCase();
        final tempDir = await getTemporaryDirectory();
        final filePath = path.join(tempDir.path, 'downloaded$ext');
        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);
        final isVideo = ['.mp4', '.mov', '.avi', '.webm'].contains(ext);
        await _prepareMedia(file, isVideo);
      }
    } catch (_) {}
  }

  Future<void> _prepareMedia(File file, bool isVideo) async {
    String aspect;
    if (isVideo) {
      _videoController?.dispose();
      _videoController = VideoPlayerController.file(file);
      await _videoController!.initialize();
      final size = _videoController!.value.size;
      aspect = '${size.width.toInt()} x ${size.height.toInt()} '
          '(Ratio: ${(size.width / size.height).toStringAsFixed(2)})';
    } else {
      final decoded = await decodeImageFromList(file.readAsBytesSync());
      aspect = '${decoded.width} x ${decoded.height} '
          '(Ratio: ${(decoded.width / decoded.height).toStringAsFixed(2)})';
    }

    _media = MediaModel(file: file, isVideo: isVideo, aspectRatio: aspect);
    notifyListeners();
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }
}
