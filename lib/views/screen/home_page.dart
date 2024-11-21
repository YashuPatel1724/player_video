import 'dart:async';

import 'package:flutter/material.dart';
import 'package:player_video/views/screen/video_page.dart';
import 'package:provider/provider.dart';

import '../../provider/video_provider.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    var providerTrue = Provider.of<VideoProvider>(context);
    var providerFalse = Provider.of<VideoProvider>(context, listen: false);
    Future.delayed(
      const Duration(seconds: 6),
      () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => HomePage(
              videoUrl: providerTrue.videoPlayerModal!.categories.first.videos
                  .first.sources.first,
              title: providerTrue
                  .videoPlayerModal!.categories.first.videos.first.title,
              channelName: providerTrue
                  .videoPlayerModal!.categories.first.videos.first.description,
              views: '1M',
            ),
          ),
        );
      },
    );
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
          child: Container(
            height: 150,
              width: 150,
              child: Image.network(
                  'https://cdn.pixabay.com/photo/2021/06/15/12/28/tiktok-6338429_1280.png'))),
    );
  }
}
