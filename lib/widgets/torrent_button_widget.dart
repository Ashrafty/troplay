import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';
import '../providers/video_state_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class TorrentButtonWidget extends StatefulWidget {
  const TorrentButtonWidget({Key? key}) : super(key: key);

  @override
  _TorrentButtonWidgetState createState() => _TorrentButtonWidgetState();
}

class _TorrentButtonWidgetState extends State<TorrentButtonWidget> {
  final TextEditingController _controller = TextEditingController();
  String _status = '';
  bool _isAdding = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Button(
      child: const Text('Add Torrent'),
      onPressed: () => _showTorrentDialog(context),
    );
  }

  void _showTorrentDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => ContentDialog(
        title: const Text('Add Torrent'),
        content: SizedBox(
          width: 700,
          height: 180,
          child: Column(
            children: [
              TextBox(
                controller: _controller,
                placeholder: 'Paste magnet URL here',
              ),
              const SizedBox(height: 10),
              Text(_status),
            ],
          ),
        ),
        actions: [
          Button(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.pop(context);
              _resetState();
            },
          ),
          FilledButton(
            child: const Text('Add'),
            onPressed: _isAdding ? null : () => _addTorrent(context),
          ),
        ],
      ),
    );
  }

  void _resetState() {
    setState(() {
      _status = '';
      _isAdding = false;
    });
  }

  Future<void> _addTorrent(BuildContext context) async {
    if (await _requestPermissions()) {
      final String magnetUrl = _controller.text.trim();
      if (magnetUrl.isEmpty) {
        setState(() {
          _status = 'Please enter a valid magnet URL.';
        });
        return;
      }

      setState(() {
        _isAdding = true;
        _status = 'Adding torrent...';
      });

      try {
        // Immediately add to downloads list and close dialog
        Provider.of<VideoStateProvider>(context, listen: false).addPlaceholderDownload(magnetUrl);
        Navigator.of(context).pop();

        // Start the actual torrent addition process
        await Provider.of<VideoStateProvider>(context, listen: false).addTorrent(magnetUrl);
      } catch (e) {
        // If there's an error, show it in a new dialog
        showDialog(
          context: context,
          builder: (context) => ContentDialog(
            title: const Text('Error'),
            content: Text('Failed to add torrent: $e'),
            actions: [
              Button(
                child: const Text('OK'),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      } finally {
        _resetState();
      }
    } else {
      setState(() {
        _status = 'Permissions not granted. Cannot add torrent.';
      });
    }
  }

  Future<bool> _requestPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
    ].request();
    return statuses[Permission.storage]!.isGranted;
  }
}