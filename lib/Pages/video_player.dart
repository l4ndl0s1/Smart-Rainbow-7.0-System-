import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:smartrainbow/Widgets/video.dart';
import 'package:smartrainbow/style.dart';

class Video extends StatelessWidget {
  const Video({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 200, 200, 200),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 200, 200, 200),
        title: const Text(
          'The matter is melting!',
          style: TextStyle(color: AppColors.green),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: AppColors.green,
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              if (kDebugMode) {
                if (kDebugMode) {
                  print("No pages in stack to pop");
                }
              }
            }
          },
        ),
      ),
      body: const Center(
        child: VideoPlayerWidget(videoUrl: 'assets/objects.mp4'),
      ),
    );
  }
}
