import 'package:fluent_ui/fluent_ui.dart';
import 'package:media_kit/media_kit.dart';
import 'package:provider/provider.dart';
import 'package:media_kit_video/media_kit_video.dart';
import '../widgets/playlist_widget.dart';
import '../widgets/torrent_button_widget.dart';
import '../widgets/download_list_widget.dart';
import '../widgets/url_button_widget.dart';
import '../providers/video_state_provider.dart';
import 'package:desktop_drop/desktop_drop.dart';
import 'dart:io';

class VideoPlayerScreen extends StatefulWidget {
  const VideoPlayerScreen({Key? key}) : super(key: key);

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late final player = Player();
  late final controller = VideoController(player);
  int _currentTabIndex = 0;
  bool _dragging = false;

  @override
  void initState() {
    super.initState();
    Provider.of<VideoStateProvider>(context, listen: false).setPlayer(player);
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      content: Row(
        children: [
          Expanded(
            flex: 1,
            child: Column(
              children: [
                Row(
                  children: [
                    const TorrentButtonWidget(),
                    const SizedBox(width: 8),
                    const UrlButtonWidget(),
                  ],
                ),
                Expanded(
                  child: TabView(
                    currentIndex: _currentTabIndex,
                    onChanged: (index) => setState(() => _currentTabIndex = index),
                    tabs: [
                      Tab(
                        text: const Text('Playlist'),
                        body: const PlaylistWidget(),
                      ),
                      Tab(
                        text: const Text('Downloads'),
                        body: const DownloadListWidget(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: Consumer<VideoStateProvider>(
              builder: (context, videoState, child) {
                return DropTarget(
                  onDragDone: (detail) async {
                    for (final file in detail.files) {
                      try {
                        await videoState.addVideoFile(File(file.path));
                      } catch (e) {
                        displayInfoBar(
                          context,
                          duration: const Duration(seconds: 3),
                          builder: (context, close) {
                            return InfoBar(
                              title: const Text('Error'),
                              content: Text('Failed to add file: ${file.name}. $e'),
                              severity: InfoBarSeverity.error,
                              action: IconButton(
                                icon: const Icon(FluentIcons.clear),
                                onPressed: close,
                              ),
                            );
                          },
                        );
                      }
                    }
                  },
                  onDragEntered: (detail) {
                    setState(() {
                      _dragging = true;
                    });
                  },
                  onDragExited: (detail) {
                    setState(() {
                      _dragging = false;
                    });
                  },
                  child: Stack(
                    children: [
                      Video(
                        controller: controller,
                        controls: AdaptiveVideoControls,
                      ),
                      if (_dragging)
                        Container(
                          color: Colors.black.withOpacity(0.5),
                          child: const Center(
                            child: Text(
                              'Drop video files here',
                              style: TextStyle(color: Colors.white, fontSize: 24),
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}