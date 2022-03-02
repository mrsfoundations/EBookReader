import 'package:flutter/material.dart';
import 'package:my_ebook_reader/category_data/adventure.dart';
import 'package:my_ebook_reader/category_data/books_list.dart';
import 'package:my_ebook_reader/category_data/horror.dart';
import 'package:my_ebook_reader/category_data/mystery.dart';
import 'package:my_ebook_reader/category_data/romance.dart';
import 'package:my_ebook_reader/category_data/sci_fi.dart';
import 'package:my_ebook_reader/screens/downloads_screen.dart';
import 'package:my_ebook_reader/utils/consts.dart';
import 'package:my_ebook_reader/utils/enums.dart';
import 'package:my_ebook_reader/screens/books_screen.dart';
import 'package:permission_handler/permission_handler.dart';

class TabScreen extends StatefulWidget {
  const TabScreen({Key? key}) : super(key: key);

  @override
  State<TabScreen> createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  Future requestStoragePermission() async {
    PermissionStatus permission = await Permission.storage.status;

    if (permission != PermissionStatus.granted) {
      await Permission.storage.request();
      // access media location needed for android 10/Q
      await Permission.accessMediaLocation.request();
      // manage external storage needed for android 11/R
      await Permission.manageExternalStorage.request();
    }
  }

  @override
  void initState() {
    requestStoragePermission();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 6,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(DownloadsScreen.routeName);
                },
                icon: const Icon(Icons.download))
          ],
          title: Text(Constants.appName),
          bottom: const TabBar(isScrollable: true, tabs: [
            Tab(
              child: FittedBox(
                child: Text(
                  "Popular",
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Tab(
              child: FittedBox(
                child: Text(
                  "Sci-fi",
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Tab(
              child: FittedBox(
                child: Text(
                  "Adventure",
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Tab(
              child: FittedBox(
                child: Text(
                  "Mystery",
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Tab(
              child: FittedBox(
                child: Text(
                  "Romance",
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Tab(
              child: FittedBox(
                child: Text(
                  "Horror",
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ]),
        ),
        body: TabBarView(children: [
          BooksScreen(BOOKSLIST, CategoryName.popular),
          BooksScreen(SCIFILIST, CategoryName.scifi),
          BooksScreen(ADVENTURE, CategoryName.adventure),
          BooksScreen(MYSTERY, CategoryName.mystery),
          BooksScreen(ROMANCE, CategoryName.romance),
          BooksScreen(HORROR, CategoryName.horror)
        ]),
      ),
    );
  }
}
