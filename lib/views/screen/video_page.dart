import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/video_provider.dart';

class HomePage extends StatefulWidget {
  final String videoUrl;
  final String title;
  final String channelName;
  final String views;

  const HomePage({
    super.key,
    required this.videoUrl,
    required this.title,
    required this.channelName,
    required this.views,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<VideoProvider>(context, listen: false)
          .initializePlayer(widget.videoUrl);
    });
  }

  @override
  Widget build(BuildContext context) {
    var providerTrue = Provider.of<VideoProvider>(context);
    var providerFalse = Provider.of<VideoProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.black,
      body: FutureBuilder(
        future: providerFalse.fetchApiData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return PageView.builder(
              onPageChanged: (value) {
                providerFalse.indexChange();
                providerFalse.initializePlayer(
                  providerTrue.videoPlayerModal!.categories.first.videos[providerTrue.selectedIndex].sources.first,
                );
              },
              scrollDirection: Axis.vertical,
              itemCount:
              providerTrue.videoPlayerModal!.categories.first.videos.length,
              itemBuilder: (context, index) {
                final video = providerTrue
                    .videoPlayerModal!.categories.first.videos[index];

                return Stack(
                  children: [
                    // Video Player (Placeholder for now)

                    // Video Player Section
                    if (providerTrue.chewieController != null &&
                        providerTrue.videoPlayerController.value.isInitialized)
                      AspectRatio(
                        aspectRatio: 9 / 18,
                        child:
                        Chewie(controller: providerTrue.chewieController!),
                      )
                    else
                      const Center(child: CircularProgressIndicator()),
                    // Overlay Details
                    Positioned(
                      left: 10,
                      bottom: 100,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '@channel_name',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            video.title,
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Row(
                            children: [
                              Icon(Icons.music_note, color: Colors.white),
                              SizedBox(width: 5),
                              Text(
                                'Original Sound - Artist Name',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Action Buttons
                    Positioned(
                      right: 10,
                      bottom: 100,
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 25,
                            backgroundImage: NetworkImage(
                              video.thumb, // Use user profile image here
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Column(
                            children: [
                              Icon(Icons.favorite, color: Colors.white),
                              Text('1.2M',
                                  style: TextStyle(color: Colors.white)),
                              SizedBox(height: 20),
                              Icon(Icons.chat_bubble_outline,
                                  color: Colors.white),
                              Text('325K',
                                  style: TextStyle(color: Colors.white)),
                              SizedBox(height: 20),
                              Icon(Icons.share, color: Colors.white),
                              Text('Share',
                                  style: TextStyle(color: Colors.white)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            );
          }
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.black,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        currentIndex: 0,
        onTap: (index) {},
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Discover',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box, color: Colors.white),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'Inbox',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}