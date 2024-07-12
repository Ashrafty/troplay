import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';
import '../providers/video_state_provider.dart';

class PlaylistWidget extends StatelessWidget {
  const PlaylistWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<VideoStateProvider>(
      builder: (context, videoState, child) {
        return ListView.builder(
          itemCount: videoState.playlist.length,
          itemBuilder: (context, index) {
            final video = videoState.playlist[index];
            return GestureDetector(
              onTap: () => videoState.selectVideo(index),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            video.title,
                            style: FluentTheme.of(context).typography.caption?.copyWith(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            video.duration,
                            style: FluentTheme.of(context).typography.caption?.copyWith(
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(FluentIcons.delete, size: 14),
                      onPressed: () => videoState.removeVideo(index),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}