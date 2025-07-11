import 'dart:io';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../viewmodels/media_view_model.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  ChewieController? _chewieController;

  Future<void> _pickMedia(bool isVideo) async {
    final picker = ImagePicker();
    final picked = isVideo
        ? await picker.pickVideo(source: ImageSource.gallery)
        : await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      await context.read<MediaViewModel>().loadFromGallery(File(picked.path), isVideo);
      _initChewie();
    }
  }

  Future<void> _loadUrl() async {
    final controller = TextEditingController();
    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Enter media URL"),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: "https://..."),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          TextButton(
              onPressed: () async {
                Navigator.pop(context);
                await context.read<MediaViewModel>().loadFromUrl(controller.text.trim());
                _initChewie();
              },
              child: const Text("Load")),
        ],
      ),
    );
  }

  void _initChewie() {
    final viewModel = context.read<MediaViewModel>();
    final controller = viewModel.videoController;
    if (controller != null && controller.value.isInitialized) {
      _chewieController?.dispose();
      _chewieController = ChewieController(
        videoPlayerController: controller,
        autoPlay: false,
        looping: false,
        aspectRatio: controller.value.aspectRatio,
      );
    }
  }

  @override
  void dispose() {
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final media = context.watch<MediaViewModel>().media;

    return Scaffold(
      appBar: AppBar(title: const Text("Aspect Ratio")),
      body: Center(
        child: Column(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () => _pickMedia(false),
                  child: const Text("Pick Image"),
                ),
                ElevatedButton(
                  onPressed: () => _pickMedia(true),
                  child: const Text("Pick Video"),
                ),
              ],
            ),
            ElevatedButton(onPressed: _loadUrl, child: const Text("Load from URL")),
            const SizedBox(height: 10),
            if (media != null)
              Expanded(
                child: media.isVideo
                    ? (_chewieController != null
                        ? Chewie(controller: _chewieController!)
                        : const Text("Loading video..."))
                    : Image.file(media.file),
              ),
            if (media != null)
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  media.aspectRatio,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              )
          ],
        ),
      ),
    );
  }
}
