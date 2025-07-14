import 'dart:io';

import 'package:aspect_ratio/models/aspect_ratio_type.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import '../viewmodels/media_view_model.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  VideoPlayerController? _videoController;
  ChewieController? _chewieController;

  @override
  void dispose() {
    _videoController?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  Future<void> _setupVideo(String path) async {
    _videoController = VideoPlayerController.file(File(path));
    await _videoController!.initialize();
    _chewieController = ChewieController(
      videoPlayerController: _videoController!,
      autoPlay: false,
      looping: false,
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<MediaViewModel>(context);

    if (viewModel.mediaFile != null && viewModel.isVideo && _videoController == null) {
      _setupVideo(viewModel.mediaFile!.path);
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Aspect Ratio Detector")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            if (viewModel.mediaFile != null)
              viewModel.isVideo
                  ? (_chewieController != null
                      ? AspectRatio(
                          aspectRatio: _videoController!.value.aspectRatio,
                          child: Chewie(controller: _chewieController!),
                        )
                      : const CircularProgressIndicator())
                  : Image.file(viewModel.mediaFile!),
            const SizedBox(height: 20),
            if (viewModel.mediaSize != null)
              Text(
                'Dimensions: ${viewModel.mediaSize!.width.toInt()} x ${viewModel.mediaSize!.height.toInt()}',
              ),
            if (viewModel.detectedAspectRatio != null)
              Text('Aspect Ratio: ${viewModel.detectedAspectRatio!.label}'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => viewModel.pickImage(),
              child: const Text('Pick Image'),
            ),
            ElevatedButton(
              onPressed: () => viewModel.pickVideo(),
              child: const Text('Pick Video'),
            ),
            ElevatedButton(
              onPressed: () async {
                final controller = TextEditingController();
                await showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text('Enter URL'),
                    content: TextField(controller: controller),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          viewModel.loadFromUrl(controller.text);
                        },
                        child: const Text('Load'),
                      ),
                    ],
                  ),
                );
              },
              child: const Text('Load from URL'),
            ),
          ],
        ),
      ),
    );
  }
}
