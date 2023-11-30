import 'dart:async';
import 'package:background_downloader/background_downloader.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:nunc_system_task/componets/video_view.dart';
import 'package:nunc_system_task/database/database.dart';
import 'package:nunc_system_task/provider/videos_provider.dart';
import 'package:provider/provider.dart';
import '../constants.dart';
import '../provider/donloader.dart';

class VideosPage extends StatefulWidget {
  const VideosPage({super.key});
  @override
  State<VideosPage> createState() => _VideosPagePageState();
}

class _VideosPagePageState extends State<VideosPage> {
  @override
  void initState() {
    super.initState();
    initializeProvider();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 4,
        shadowColor: Theme.of(context).shadowColor,
        title: const Text(
          'Videos',
          style: kHead3TextStyle,
        ),
        automaticallyImplyLeading: false,
      ),
      body: StreamBuilder<List<VideosTableData>>(
        stream: context.watch<AppDatabase>().watchEntriesInCategory(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data != null) {
              return ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: snapshot.data!.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      String status = snapshot.data![index].rendering!;
                      if (status != 'Completed') {
                        VideoDownloadedSave().downloadVideoToLocal(
                            snapshot.data![index], context);
                      }
                    },
                    child: VideoView(
                      item: snapshot.data![index],
                    ),
                  );
                },
              );
            } else {
              debugPrint('No Data');
              return const Center(
                child: Text(
                  'No Data',
                  style: kHead3TextStyle,
                ),
              );
            }
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Future<void> initializeProvider() async {
    /// Process the user tapping on a notification by printing a message
    void myNotificationTapCallback(
        Task task, NotificationType notificationType) {
      debugPrint(
          'Tapped notification $notificationType for taskId ${task.taskId}');
    }
    FileDownloader()
        .registerCallbacks(
            taskNotificationTapCallback: myNotificationTapCallback)
        .configureNotificationForGroup(FileDownloader.defaultGroup,
            // For the main download button
            // which uses 'enqueue' and a default group
            running: const TaskNotification('Download {filename}',
                'File: {filename} - {progress} - speed {networkSpeed} and {timeRemaining} remaining'),
            complete: const TaskNotification(
                '{displayName} download {filename}', 'Download complete'),
            error: const TaskNotification(
                'Download {filename}', 'Download failed'),
            paused: const TaskNotification(
                'Download {filename}', 'Paused with metadata {metadata}'),
            progressBar: true)
        .configureNotification(
            // for the 'Download & Open' dog picture
            // which uses 'download' which is not the .defaultGroup
            // but the .await group so won't use the above config
            complete: const TaskNotification(
                'Download {filename}', 'Download complete'),
            tapOpensFile: true);
    VideosProvider();
    bool result = await InternetConnectionChecker().hasConnection;
    if (result == true) {
      debugPrint('internet available');

      insertDataToDP();
    } else {
      debugPrint('No internet :( Reason:');
      showAlert();
    }
  }

  void insertDataToDP() {
    List<VideosTableCompanion> items = context.read<VideosProvider>().items;
    context.read<AppDatabase>().allVideosItems.then((value) => {
          if (value.isNotEmpty)
            {
              debugPrint('Table is not created'),
              context.read<AppDatabase>().insertMultipleEntries(items),
            }
          else
            {
              debugPrint('Table is already created with data'),
              context.read<AppDatabase>().insertMultipleEntries(items),
            }
        });
  }

  void showAlert() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("No internet"),
      ),
    );
  }
}

enum ButtonState { download, cancel, pause, resume, reset }
