import 'package:flutter/foundation.dart';
import 'package:media_kit/media_kit.dart';
import '../models/video_item.dart';
import 'dart:io';
import 'package:path/path.dart' as path;

class DownloadItem {
  final String id;
  String name;
  String size;
  double progress = 0.0;
  bool isPlaceholder;

  DownloadItem({
    required this.id,
    required this.name,
    required this.size,
    this.isPlaceholder = false,
  });
}

class VideoStateProvider with ChangeNotifier {
  List<VideoItem> _playlist = [];
  List<DownloadItem> _downloadList = [];
  int _currentIndex = 0;
  Player? _player;

  List<VideoItem> get playlist => _playlist;
  List<DownloadItem> get downloadList => _downloadList;
  int get currentIndex => _currentIndex;
  bool get isPlaying => _player?.state.playing ?? false;
  double get progress => _player?.state.position.inMilliseconds.toDouble() ?? 0.0 / (_player?.state.duration.inMilliseconds.toDouble() ?? 1.0);

  get DTorrentTask => null;

  void setPlayer(Player player) {
    _player = player;
    notifyListeners();
  }

  void addVideo(VideoItem video) {
    _playlist.add(video);
    notifyListeners();
  }

  void selectVideo(int index) {
    _currentIndex = index;
    final videoItem = _playlist[index];
    _player?.open(Media(videoItem.source));
    notifyListeners();
  }

  void togglePlayPause() {
    if (_player != null) {
      if (_player!.state.playing) {
        _player!.pause();
      } else {
        _player!.play();
      }
      notifyListeners();
    }
  }

  DownloadItem addPlaceholderDownload(String magnetLink) {
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    final item = DownloadItem(
      id: id,
      name: 'Loading...',
      size: 'Fetching...',
      isPlaceholder: true,
    );
    _downloadList.add(item);
    notifyListeners();
    return item;
  }

  Future<void> addTorrent(String magnetLink) async {
    final placeholderItem = addPlaceholderDownload(magnetLink);
    try {
      final torrent = await DTorrentTask.newTask(magnetLink);
      final name = torrent.name;
      final size = '${(torrent.size / (1024 * 1024)).toStringAsFixed(2)} MB';
      
      // Update the placeholder item with actual information
      placeholderItem.name = name;
      placeholderItem.size = size;
      placeholderItem.isPlaceholder = false;
      notifyListeners();

      torrent.onProgress.listen((progress) {
        updateDownloadProgress(placeholderItem, progress);
      });

      await torrent.waitUntilComplete();
      final filePath = torrent.files.firstWhere((file) =>
        ['mp4', 'avi', 'mkv', 'mov', 'wmv', 'flv', 'webm'].contains(file.name.split('.').last.toLowerCase())
      ).path;
      completeDownload(placeholderItem, filePath);
    } catch (e) {
      // If there's an error, remove the placeholder
      _downloadList.remove(placeholderItem);
      notifyListeners();
      throw e; // Re-throw the error to be caught in the UI
    }
  }

  void updateDownloadProgress(DownloadItem item, double progress) {
    item.progress = progress;
    notifyListeners();
  }

  void completeDownload(DownloadItem item, String filePath) {
    _downloadList.remove(item);
    addVideo(VideoItem(
      title: item.name,
      source: filePath,
      sourceType: VideoSourceType.file,
      duration: '00:00', // You might want to get the actual duration
    ));
    notifyListeners();
  }

  void removeDownload(DownloadItem item) {
    _downloadList.remove(item);
    notifyListeners();
  }

  void removeVideo(int index) {
    _playlist.removeAt(index);
    notifyListeners();
  }

  Future<void> addUrlToPlaylist(String url) async {
    // Fetch video information here
    // For now, we'll just add it with a placeholder duration
    addVideo(VideoItem(
      title: 'URL Video',
      source: url,
      sourceType: VideoSourceType.url,
      duration: '00:00',
    ));
  }

  Future<void> addVideoFile(File file) async {
    final String fileName = path.basename(file.path);
    final String fileExtension = path.extension(file.path).toLowerCase();
    
    if (['.mp4', '.avi', '.mkv', '.mov', '.wmv', '.flv', '.webm'].contains(fileExtension)) {
      final videoItem = VideoItem(
        title: fileName,
        source: file.path,
        sourceType: VideoSourceType.file,
        duration: '00:00', // You might want to get the actual duration
      );
      
      addVideo(videoItem);
      
      // If this is the first video, start playing it
      if (_playlist.length == 1) {
        selectVideo(0);
      }
    } else {
      throw UnsupportedError('Unsupported file type: $fileExtension');
    }
  }
}