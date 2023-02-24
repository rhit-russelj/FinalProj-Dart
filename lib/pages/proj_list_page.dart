import 'dart:async';

import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:final_proj_dart/components/list_page_side_drawer.dart';
import 'package:final_proj_dart/components/prof_row_component.dart';
// import 'package:my_photo_bucket/managers/auth_manager.dart';
import 'package:final_proj_dart/managers/prof_collection_manager.dart';
import 'package:final_proj_dart/models/prof.dart';
// import 'package:my_photo_bucket/pages/photo_bucket_detail_page.dart';

class PhotoBucketListPage extends StatefulWidget {
  const PhotoBucketListPage({super.key});

  @override
  State<PhotoBucketListPage> createState() => _PhotoBucketListPageState();
}

class _PhotoBucketListPageState extends State<PhotoBucketListPage> {
  final captionTextController = TextEditingController();
  final imageTextController = TextEditingController();

  bool _isShowingAllPhotos = true;

  UniqueKey? _loginObserverKey;
  UniqueKey? _logoutObserverKey;

  @override
  void initState() {
    super.initState();

    _showAllProfs();
  //
  //   _loginObserverKey = AuthManager.instance.addLoginObserver(() {
  //     setState(() {});
  //   });
  //
  //   _logoutObserverKey = AuthManager.instance.addLogoutObserver(() {
  //     _showAllPhotos();
  //     setState(() {});
  //   });
  }
  //
  // void _showAllPhotos() {
  //   setState(() {
  //     _isShowingAllPhotos = true;
  //   });
  // }
  //
  // void _showOnlyMyPhotos() {
  //   setState(() {
  //     _isShowingAllPhotos = false;
  //   });
  // }

  @override
  void dispose() {
    captionTextController.dispose();
    imageTextController.dispose();
    // AuthManager.instance.removeObserver(_loginObserverKey);
    // AuthManager.instance.removeObserver(_logoutObserverKey);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Photo Bucket"),
        // actions: AuthManager.instance.isSignedIn
        //     ? null
        //     : [
        //   IconButton(
        //     onPressed: () {
        //       Navigator.push(context, MaterialPageRoute(
        //         builder: (BuildContext context) {
        //           return const LoginFrontPage();
        //         },
        //       ));
        //     },
        //     tooltip: "Log in",
        //     icon: const Icon(Icons.login),
        //   ),
        // ],
      ),
      backgroundColor: Colors.grey[100],
      body: FirestoreListView<Prof>(
        query: _isShowingAllPhotos
            ? ProfCollectionManager.instance.allPhotosQuery
            : ProfCollectionManager.instance.mineOnlyPhotosQuery,
        itemBuilder: (context, snapshot) {
          Photo p = snapshot.data();
          return PhotoRow(
            photo: p,
            onTap: () async {
              print("You clicked on the photo ${p.caption} - ${p.imageUrl}");
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return PhotoBucketDetailPage(
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
          title: const Text('Create a Photo'),
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
                    labelText: 'Enter the caption',
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
                    labelText: 'Enter the photo',
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
                  PhotoBucketCollectionManager.instance.add(
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