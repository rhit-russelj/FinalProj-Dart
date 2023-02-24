import 'dart:async';

import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_photo_bucket/components/list_page_side_drawer.dart';
import 'package:my_photo_bucket/components/video_row_component.dart';
import 'package:my_photo_bucket/managers/auth_manager.dart';
import 'package:my_photo_bucket/managers/video_bucket_collection_manager.dart';
import 'package:my_photo_bucket/models/video.dart';
import 'package:my_photo_bucket/pages/video_bucket_detail_page.dart';

import 'login_front_page.dart';

class VideoBucketListPage extends StatefulWidget {
  const VideoBucketListPage({super.key});

  @override
  State<VideoBucketListPage> createState() => _VideoBucketListPageState();
}

class _VideoBucketListPageState extends State<VideoBucketListPage> {
  final captionTextController = TextEditingController();
  final imageTextController = TextEditingController();

  bool _isShowingAllPhotos = true;

  UniqueKey? _loginObserverKey;
  UniqueKey? _logoutObserverKey;

  @override
  void initState() {
    super.initState();

    _showAllPhotos();

    _loginObserverKey = AuthManager.instance.addLoginObserver(() {
      setState(() {});
    });

    _logoutObserverKey = AuthManager.instance.addLogoutObserver(() {
      _showAllPhotos();
      setState(() {});
    });
  }

  void _showAllPhotos() {
    setState(() {
      _isShowingAllPhotos = true;
    });
  }

  void _showOnlyMyPhotos() {
    setState(() {
      _isShowingAllPhotos = false;
    });
  }

  @override
  void dispose() {
    captionTextController.dispose();
    imageTextController.dispose();
    AuthManager.instance.removeObserver(_loginObserverKey);
    AuthManager.instance.removeObserver(_logoutObserverKey);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Movie Quotes with Text-to-Speech"),
        actions: AuthManager.instance.isSignedIn
            ? null
            : [
          IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (BuildContext context) {
                  return const LoginFrontPage();
                },
              ));
            },
            tooltip: "Log in",
            icon: const Icon(Icons.login),
          ),
        ],
      ),
      backgroundColor: Colors.grey[100],
      body: FirestoreListView<Video>(
        query: _isShowingAllPhotos
            ? VideoBucketCollectionManager.instance.allPhotosQuery
            : VideoBucketCollectionManager.instance.mineOnlyPhotosQuery,
        itemBuilder: (context, snapshot) {
          Video p = snapshot.data();
          return PhotoRow(
            photo: p,
            onTap: () async {
              print("You clicked on the caption to be read${p.caption} - ${p.videoUrl}");
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return VideoDetailPage(
                        p.documentId!); // In Firebase use a documentId
                  },
                ),
              );
              setState(() {});
            },
          );
        },
      ),
      drawer: AuthManager.instance.isSignedIn
          ? ListPageSideDrawer(
        showAllCallback: () {
          print("PhotoBucketListPage: Callback to Show all quotes");
          _showAllPhotos();
        },
        showOnlyMineCallback: () {
          print("PhotoBucketListPage: Callback to Show only my quotes");
          _showOnlyMyPhotos();
        },
      )
          : null,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (AuthManager.instance.isSignedIn) {
            showCreateQuoteDialog(context);
          } else {
            showMustLogInDialog(context);
          }
        },
        tooltip: 'Create',
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> showCreateQuoteDialog(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Create a caption'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 4.0),
                child: TextFormField(
                  controller: captionTextController,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Enter the caption title',
                  ),
                ),
              ),
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 4.0),
                child: TextFormField(
                  controller: imageTextController,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Enter the caption to be read',
                  ),
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Create'),
              onPressed: () {
                setState(() {
                  VideoBucketCollectionManager.instance.add(
                    caption: captionTextController.text,
                    imageUrl: imageTextController.text,
                  );
                  captionTextController.text = "";
                  imageTextController.text = "";
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> showMustLogInDialog(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Login Required"),
          content: const Text(
              "You must be signed in to post.  Would you like to sign in now?"),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text("Go sign in"),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(context, MaterialPageRoute(
                  builder: (BuildContext context) {
                    return const LoginFrontPage();
                  },
                ));
              },
            ),
          ],
        );
      },
    );
  }
}