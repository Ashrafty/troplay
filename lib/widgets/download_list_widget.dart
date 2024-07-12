// widgets/download_list_widget.dart
import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';
import '../providers/video_state_provider.dart';

class DownloadListWidget extends StatelessWidget {
  const DownloadListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<VideoStateProvider>(
      builder: (context, videoState, child) {
        return ListView.builder(
          itemCount: videoState.downloadList.length,
          itemBuilder: (context, index) {
            final download = videoState.downloadList[index];
            return ListTile(
              title: Text(download.name),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Size: ${download.size}'),
                  ProgressBar(value: download.progress),
                  Text('${(download.progress * 100).toStringAsFixed(2)}%'),
                ],
              ),
            );
          },
        );
      },
    );
  }
}