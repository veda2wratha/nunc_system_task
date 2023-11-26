import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nunc_system_task/componets/video_item.dart';
import 'package:nunc_system_task/models/videos_model.dart';
import 'package:nunc_system_task/provider/videos_provider.dart';

import '../constants.dart';

class VideosPage extends StatefulWidget {
  const VideosPage({super.key});
  @override
  State<VideosPage> createState() => _VideosPagePageState();
}

class _VideosPagePageState extends State<VideosPage> {
  late Future<List<VideosModel>> videos;

  @override
  void initState() {
    super.initState();
    videos = VideosProvider.getVideos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 4,
        shadowColor: Theme.of(context).shadowColor,
        leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(Icons.arrow_back)),
        title: const Text(
          'Videos',
          style: kHead3TextStyle,
        ),
        automaticallyImplyLeading: false,
      ),
      body: FutureBuilder<List<VideosModel>>(
          future: videos,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
                if (snapshot.data != null) {
                  return ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (BuildContext context, int index) {
                      return VideoItem(snapshot.data![index]);
                    },
                  );
                }
                else{
                  return const Center(
                    child: Text('No Leaves Yet!', style: kHead3TextStyle,),
                  );
                }

            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            return const Center(child: CircularProgressIndicator());
          }),
    );
  }
}
