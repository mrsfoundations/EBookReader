import 'dart:io';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';

import '../utils/consts.dart';
import '../utils/database.dart';
import '../widgets/download_alert.dart';

class DownloadsProvider extends ChangeNotifier {
  String bookId = '';
  bool isDownloaded = false;
  String bookPath = '';

  get getIsDownloaded {
    return isDownloaded;
  }

  void setBookId(String value) {
    bookId = value;
  }

  String get getBookPath {
    return bookPath;
  }

  void setIsDownloaded(bool value) {
    isDownloaded = value;
    notifyListeners();
  }

  // check if book has been downloaded before
  checkDownload() async {
    print('chheck $bookId');
    List downloads = await DownloadDatabase().check({'id': bookId});

    print(downloads.length);

    if (downloads.isNotEmpty) {
      // check if book has been deleted
      String path = downloads[0]['path'];
      print(path);
      if (await File(path).exists()) {
        print(bookId + ' Exist');
        bookPath = path;
        setIsDownloaded(true);
      } else {
        setIsDownloaded(false);
      }
    } else {
      setIsDownloaded(false);
    }
  }

  addDownload(Map body) async {
    await DownloadDatabase().removeAllWithId({'id': bookId});
    await DownloadDatabase().add(body);
    checkDownload();
  }

  removeDownload(String id, String path) async {
    await DownloadDatabase().removeAllWithId({'id': id});
    File file = File(path);
    if (await file.exists()) {
      await file.delete();
    }
  }

  Future downloadFile(BuildContext context, String url, String filename,
      String imageUrl) async {
    PermissionStatus permission = await Permission.storage.status;

    if (permission != PermissionStatus.granted) {
      await Permission.storage.request();
      // access media location needed for android 10/Q
      await Permission.accessMediaLocation.request();
      // manage external storage needed for android 11/R
      await Permission.manageExternalStorage.request();
      startDownload(context, url, filename, imageUrl);
    } else {
      startDownload(context, url, filename, imageUrl);
    }
  }

  startDownload(BuildContext context, String url, String filename,
      String imageUrl) async {
    Directory? appDocDir = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();
    if (Platform.isAndroid) {
      Directory(appDocDir!.path.split('Android')[0] + Constants.appName)
          .createSync();
    }

    String path = Platform.isIOS
        ? appDocDir!.path + '/$filename.epub'
        : appDocDir!.path.split('Android')[0] +
            '${Constants.appName}/$filename.epub';

    File file = File(path);
    if (!await file.exists()) {
      await file.create();
    } else {
      await file.delete();
      await file.create();
    }

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => DownloadAlert(
        url: url,
        path: path,
      ),
    ).then((v) {
      // When the download finishes, we then add the book
      // to our local database
      if (v != null) {
        addDownload(
          {
            'id': bookId,
            'path': path,
            'image': imageUrl,
            'size': v,
            'name': filename,
          },
        );
      }
    });
  }
}
