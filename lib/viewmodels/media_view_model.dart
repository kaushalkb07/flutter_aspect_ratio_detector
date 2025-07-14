import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:flutter/painting.dart';
import '../models/aspect_ratio_type.dart';

class MediaViewModel extends ChangeNotifier {
  File? mediaFile;
  bool isVideo = false;
  Size? mediaSize;
  AspectRatioType? detectedAspectRatio;

  final picker = ImagePicker();

  Future<void> pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      mediaFile = File(pickedFile.path);
      isVideo = false;
      await _calculateImageAspectRatio();
      notifyListeners();
    }
  }

  Future<void> pickVideo() async {
    final pickedFile = await picker.pickVideo(source: ImageSource.gallery);
    if (pickedFile != null) {
      mediaFile = File(pickedFile.path);
      isVideo = true;
      await _calculateVideoAspectRatio();
      notifyListeners();
    }
  }

  Future<void> loadFromUrl(String url) async {
    final response = await http.get(Uri.parse(url));
    final tempDir = await getTemporaryDirectory();
    final file = File(join(tempDir.path, basename(url)));
    await file.writeAsBytes(response.bodyBytes);
    mediaFile = file;
    isVideo = url.endsWith('.mp4');
    if (isVideo) {
      await _calculateVideoAspectRatio();
    } else {
      await _calculateImageAspectRatio();
    }
    notifyListeners();
  }

  Future<void> _calculateImageAspectRatio() async {
    final bytes = await mediaFile!.readAsBytes();
    final image = await decodeImageFromList(bytes);
    mediaSize = Size(image.width.toDouble(), image.height.toDouble());
    detectedAspectRatio = _getClosestAspectRatio(mediaSize!.width, mediaSize!.height);
  }

  Future<void> _calculateVideoAspectRatio() async {
    final controller = VideoPlayerController.file(mediaFile!);
    await controller.initialize();
    mediaSize = controller.value.size;
    detectedAspectRatio = _getClosestAspectRatio(mediaSize!.width, mediaSize!.height);
    await controller.dispose();
  }

  AspectRatioType _getClosestAspectRatio(double width, double height) {
    final ratio = width / height;
    final Map<AspectRatioType, double> predefined = {
      AspectRatioType.RATIO_1_1: 1.0,
      AspectRatioType.RATIO_4_3: 4 / 3,
      AspectRatioType.RATIO_3_2: 3 / 2,
      AspectRatioType.RATIO_3_4: 3 / 4,
      AspectRatioType.RATIO_16_9: 16 / 9,
      AspectRatioType.RATIO_21_9: 21 / 9,
      AspectRatioType.RATIO_18_9: 18 / 9,
      AspectRatioType.RATIO_9_16: 9 / 16,
      AspectRatioType.RATIO_2_1: 2.0,
      AspectRatioType.RATIO_5_4: 5 / 4,
      AspectRatioType.RATIO_17_9: 17 / 9,
      AspectRatioType.RATIO_2_35_1: 2.35,
    };

    double minDiff = double.infinity;
    AspectRatioType closest = AspectRatioType.MIX;

    predefined.forEach((type, value) {
      final diff = (ratio - value).abs();
      if (diff < minDiff) {
        minDiff = diff;
        closest = type;
      }
    });

    return (minDiff < 0.05) ? closest : AspectRatioType.MIX;
  }
}
