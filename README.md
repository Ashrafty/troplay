# Troplay

## Description

This Video Player App is a Flutter-based desktop application that allows users to play and manage video content from various sources, including local files, URLs, and torrents. It features a user-friendly interface with a playlist, download manager, and video player, all wrapped in a dark-themed Fluent UI design.

## Features

- Play videos from local files, URLs, and torrents
- Manage a video playlist
- Download and manage torrents
- Drag and drop support for adding video files
- Dark theme user interface
- Tabbed view for playlist and downloads

## Technologies Used

- Flutter
- Fluent UI
- Provider (for state management)
- media_kit and media_kit_video (for video playback)
- desktop_drop (for drag and drop functionality)
- permission_handler (for managing permissions)

## Project Structure

```
lib/
├── main.dart
├── models/
│   └── video_item.dart
├── providers/
│   └── video_state_provider.dart
├── screens/
│   └── video_player_screen.dart
└── widgets/
    ├── download_list_widget.dart
    ├── playlist_widget.dart
    ├── torrent_button_widget.dart
    └── url_button_widget.dart
```

## Main Components

1. `VideoPlayerScreen`: The main screen containing the video player and sidebar.
2. `VideoStateProvider`: Manages the application state, including playlist, downloads, and player controls.
3. `PlaylistWidget`: Displays and manages the video playlist.
4. `DownloadListWidget`: Shows ongoing and completed downloads.
5. `TorrentButtonWidget`: Handles adding torrents to the download list.
6. `UrlButtonWidget`: Allows users to add videos from URLs.

## How to Build and Run

1. Ensure you have Flutter installed on your system.
2. Clone the repository to your local machine.
3. Navigate to the project directory in your terminal.
4. Run `flutter pub get` to install dependencies.
5. Ensure you have the necessary permissions set up for file access and network operations.

6. Run `flutter run` to launch the app on your desktop platform.

## Notes

- This app is designed for Windows

## Contributing

Contributions to improve the app are welcome. Please feel free to submit issues and pull requests.
