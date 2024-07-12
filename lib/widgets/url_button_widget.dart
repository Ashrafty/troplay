// widgets/url_button_widget.dart
import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';
import '../providers/video_state_provider.dart';

class UrlButtonWidget extends StatelessWidget {
  const UrlButtonWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Button(
      child: const Text('Add URL'),
      onPressed: () => _showUrlDialog(context),
    );
  }

  void _showUrlDialog(BuildContext context) {
    final TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => ContentDialog(
        title: const Text('Add URL'),
        content: TextBox(
          controller: controller,
          placeholder: 'Enter video URL',
        ),
        actions: [
          Button(
            child: const Text('Cancel'),
            onPressed: () => Navigator.pop(context),
          ),
          FilledButton(
            child: const Text('Add'),
            onPressed: () async {
              final url = controller.text.trim();
              if (url.isNotEmpty) {
                await Provider.of<VideoStateProvider>(context, listen: false).addUrlToPlaylist(url);
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
    );
  }
}