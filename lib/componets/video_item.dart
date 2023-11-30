import 'dart:async';
import 'package:background_downloader/background_downloader.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:nunc_system_task/provider/video_downloader.dart';
import '../database/database.dart';

enum ButtonState { download, cancel, pause, resume, reset, play }

class VideoItem extends StatefulWidget {
  const VideoItem({super.key, required this.item});

  final VideosTableData item;

  @override
  State<VideoItem> createState() => _VideoItemState();
}

class _VideoItemState extends State<VideoItem> {
  //TaskStatus? downloadTaskStatus;
  //DownloadTask? backgroundDownloadTask;
  //bool loadAndOpenInProgress = false;
  //bool loadABunchInProgress = false;
  ButtonState buttonState = ButtonState.download;
  final buttonIcons = [
    Icons.download_for_offline,
    Icons.cancel,
    Icons.pause,
    Icons.refresh,
    Icons.refresh,
    Icons.play_circle
  ];
  StreamController<TaskProgressUpdate> progressUpdateStream =
      StreamController.broadcast();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FileDownloader().configure(globalConfig: [
      (Config.requestTimeout, const Duration(seconds: 100)),
    ], androidConfig: [
      (Config.useCacheDir, Config.whenAble),
    ], iOSConfig: [
      (Config.localize, {'Cancel': 'StopIt'}),
    ]).then((result) => debugPrint('Configuration result = $result'));

    // Registering a callback and configure notifications
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
  }

  /// Process the user tapping on a notification by printing a message
  void myNotificationTapCallback(Task task, NotificationType notificationType) {
    debugPrint(
        'Tapped notification $notificationType for taskId ${task.taskId}');
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox(
                width: 100,
                height: 100,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CachedNetworkImage(
                      imageUrl: widget.item.thumbnail ?? '',
                      //placeholder: (context, url) => const CircularProgressIndicator(),
                      errorWidget: (context, url, error) => const Icon(
                        Icons.video_call_sharp,
                        color: Colors.red,
                      ),
                    ),
                    IconButton(
                      // onPressed: VideoDownloaderProvider()
                      //     .processButtonPress(),
                      onPressed: () async {
                        //processButtonPress(widget.item);

                        // Next, enqueue tasks to kick off background downloads, e.g.
                        // final task = DownloadTask(
                        //     url: widget.item.videourl ?? '',
                        //     filename:
                        //         '${widget.item.video_title}_${widget.item.video_id}.mp4',
                        //     updates: Updates.statusAndProgress);
                        // final successfullyEnqueued =
                        //     await FileDownloader().enqueue(task);
                        // Listen to updates and process
                      },

                      icon: Icon(
                        widget.item.video_progress > 99
                            ? buttonIcons.last
                            : buttonIcons.first,
                        size: 50,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.item.video_title ?? ''),
                  Text(widget.item.video_local_title ?? ''),
                  Text(widget.item.rendering ?? ''),
                  const Text('Flick Fusion'),
                  Text('${widget.item.video_progress} %' ?? ''),
                ],
              ),
              const Spacer(),
              const Icon(Icons.share),
            ],
          ),
          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: Row(
          //     children: [
          //       const Expanded(child: Text('File download status:')),
          //       Text(
          //           '${context.watch<VideoDownloaderProvider>().downloadTaskStatus ?? "undefined"}')
          //     ],
          //   ),
          // ),
          // Center(
          //   child: ElevatedButton(
          //     onPressed: context
          //             .watch<VideoDownloaderProvider>()
          //             .loadAndOpenInProgress
          //         ? null
          //         : context
          //             .read<VideoDownloaderProvider>()
          //             .processLoadAndOpen,
          //     child: const Text(
          //       'Load & Open',
          //     ),
          //   ),
          // ),
          // Center(
          //   child: Text(
          //     context.watch<VideoDownloaderProvider>().loadAndOpenInProgress
          //         ? 'Busy'
          //         : '',
          //     style: Theme.of(context).textTheme.bodySmall,
          //   ),
          // ),
          // StreamBuilder(
          //   // mention the data source to the stream
          //   stream: progressUpdateStream.stream,
          //   // context and snapshot is used to capture the data coming from stream
          //   builder: (context, snapshot) {
          //     if (snapshot.hasData) {
          //       if (snapshot.data != null) {
          //         return Text(
          //           // show data coming from steam
          //           '${snapshot.data!.progress * 100}%',
          //           style: Theme.of(context).textTheme.bodyLarge,
          //         );
          //       }
          //     }
          //     return const Text('');
          //   },
          // ),
          // SizedBox(
          //   width: 500,
          //   child: DownloadProgressIndicator(
          //     context
          //         .watch<VideoDownloaderProvider>()
          //         .progressUpdateStream
          //         .stream,
          //     showPauseButton: true,
          //     showCancelButton: true,
          //     backgroundColor: Colors.red,
          //   ),
          // ),

          const Divider(
            height: 20,
            thickness: 1,
            color: Colors.grey,
          ),
        ],
      ),
    );
  }

  /// Process center button press (initially 'Download' but the text changes
  /// based on state)
  Future<void> processButtonPress(VideosTableData data) async {
    DownloadTask? backgroundDownloadTask;
    TaskStatus? downloadTaskStatus;
    switch (buttonState) {
      case ButtonState.download:
        // start download
        backgroundDownloadTask = DownloadTask(
          url: data.videourl!,
          filename: '${data.video_title}_${data.video_id}.mp4',
          baseDirectory: BaseDirectory.applicationDocuments,
          updates: Updates.statusAndProgress,
          allowPause: true,
        );
        await FileDownloader().enqueue(backgroundDownloadTask!);
        break;
      case ButtonState.cancel:
        // cancel download
        if (backgroundDownloadTask != null) {
          await FileDownloader()
              .cancelTasksWithIds([backgroundDownloadTask!.taskId]);
        }
        break;
      case ButtonState.reset:
        downloadTaskStatus = null;
        buttonState = ButtonState.download;
        break;
      case ButtonState.pause:
        if (backgroundDownloadTask != null) {
          await FileDownloader().pause(backgroundDownloadTask!);
        }
        break;
      case ButtonState.resume:
        if (backgroundDownloadTask != null) {
          await FileDownloader().resume(backgroundDownloadTask!);
        }
        break;
      case ButtonState.play:
        //processLoadAndOpen(backgroundDownloadTask);
        break;
    }
    FileDownloader().updates.listen((update) {
      switch (update) {
        case TaskStatusUpdate _:
          if (update.task == backgroundDownloadTask) {
            buttonState = switch (update.status) {
              TaskStatus.running || TaskStatus.enqueued => ButtonState.pause,
              TaskStatus.paused => ButtonState.resume,
              TaskStatus.complete => ButtonState.play,
              _ => ButtonState.reset
            };
            setState(() {
              downloadTaskStatus = update.status;
            });
          }

        case TaskProgressUpdate _:
          progressUpdateStream.add(update);
        // progressUpdateStream.stream.listen((value) {
        //   debugPrint('Progresss ...$value');
        //   //updateValue(value);
        //   // VideosTableCompanion newVideo =
        //   //     VideosTableCompanion.insert(
        //   //   video_id: Value(item.videoId),
        //   //   video_fk: Value(item.videoFk),
        //   //   views: Value(widget.item.views),
        //   //   videourl: Value(widget.item.videourl),
        //   //   rendering: Value(widget.item.rendering),
        //   //   thumbnail: Value(widget.item.thumbnail),
        //   //   lastupdate: Value(widget.item.lastupdate),
        //   //   video_local_title:
        //   //       Value(widget.item.videoLocalTitle),
        //   //   video_title: Value(widget.item.videoTitle),
        //   //   video_progress: Value(event.progress),
        //   // );
        //   // context
        //   //     .read<AppDatabase>()
        //   //     .updateData(newVideo);
        // }); // pass on to widget for indicator
      }
    });

    if (mounted) {
      setState(() {});
    }
  }

  // Future<void> processLoadAndOpen(DownloadTask? task) async {
  //   if (!loadAndOpenInProgress) {
  //     // var task = DownloadTask(
  //     //     url:
  //     //         'http://d5638c46e9d8a6fde200-4a368be6a86dae998dd81c519d69c3f4.r88.cf1.rackcdn.com/AEE7CBFD-66CB-2E17-53B1-81D3882C5F5D.mp4',
  //     //     baseDirectory: BaseDirectory.applicationSupport,
  //     //     filename: 'AEE7CBFD-66CB-2E17-53B1-81D3882C5F5D.mp4');
  //     setState(() {
  //       loadAndOpenInProgress = true;
  //     });
  //
  //     await FileDownloader().download(task!);
  //     await FileDownloader().openFile(task: task);
  //     setState(() {
  //       loadAndOpenInProgress = false;
  //     });
  //   }
  // }
}
