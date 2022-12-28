import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_ebook_reader/category_data/adventure.dart';
import 'package:my_ebook_reader/category_data/books_list.dart';
import 'package:my_ebook_reader/category_data/horror.dart';
import 'package:my_ebook_reader/category_data/mystery.dart';
import 'package:my_ebook_reader/category_data/romance.dart';
import 'package:my_ebook_reader/category_data/sci_fi.dart';
import 'package:my_ebook_reader/utils/enums.dart';
import 'package:transparent_image/transparent_image.dart';
import '../providers/downloads_provider.dart';
import 'package:epub_viewer/epub_viewer.dart';

class BookDetailsScreen2 extends StatefulWidget {
  static String routeName = '/details-screen2';

  const BookDetailsScreen2({Key? key}) : super(key: key);

  @override
  State<BookDetailsScreen2> createState() => _BookDetailsScreenState();
}

class _BookDetailsScreenState extends State<BookDetailsScreen2> {
  @override
  Widget build(BuildContext context) {
    var downloadsProvider =
        Provider.of<DownloadsProvider>(context, listen: false);

    Map<String, dynamic> args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;

    String id = args['id'].toString();
    downloadsProvider.setBookId(id);
    downloadsProvider.checkDownload();

    CategoryName category = args['categoryname'] as CategoryName;
    List<dynamic> bookdetails = [];

    switch (category) {
      case CategoryName.popular:
        bookdetails =
            BOOKSLIST.where((element) => element['id'] == id).toList();
        break;
      case CategoryName.adventure:
        bookdetails =
            ADVENTURE.where((element) => element['id'] == id).toList();
        break;
      case CategoryName.scifi:
        bookdetails =
            SCIFILIST.where((element) => element['id'] == id).toList();
        break;
      case CategoryName.mystery:
        bookdetails = MYSTERY.where((element) => element['id'] == id).toList();
        break;
      case CategoryName.romance:
        bookdetails = ROMANCE.where((element) => element['id'] == id).toList();
        break;
      case CategoryName.horror:
        bookdetails = HORROR.where((element) => element['id'] == id).toList();
        break;
      default:
    }
    String epubUrl = bookdetails[0]['link'][3]['-href'];
    String imageUrl = bookdetails[0]['link'][1]['-href'];

    String title = bookdetails[0]['title'];
    String author = bookdetails[0]['author']['name'];
    String description = bookdetails[0]['summary'];
    String publicationdate = bookdetails[0]['dcterms:issued'].toString();

    void downloadEpub(String url, String filename)
    async {
     await downloadsProvider.downloadFile(context, url, filename, imageUrl);
    }

    void openEpub(DownloadsProvider value) {
      if (value.isDownloaded) {
        EpubViewer.setConfig(
          identifier: 'androidBook',
          themeColor: Theme.of(context).colorScheme.secondary,
          scrollDirection: EpubScrollDirection.VERTICAL,
          enableTts: false,
          allowSharing: true,
        );
        EpubViewer.open(value.bookPath, lastLocation: null);
      }
    }

    Widget readDownloadButton() {
      return Consumer<DownloadsProvider>(
        builder: (context, value, child) => value.getIsDownloaded
            ? ElevatedButton(
                onPressed: () {
                  openEpub(value);
                },
                child: const Text(
                  'Read',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ))
            : ElevatedButton(
                onPressed: () {
                  downloadEpub(epubUrl, title);
                },
                child: const Text(
                  'Download',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: FittedBox(
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                    width: 2, color: Colors.black12)),
                            width: MediaQuery.of(context).size.width * .35,
                            child: Image.network('https://picsum.photos/250?image=9'),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(right: 10, top: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * .50,
                              child: Text(title,
                                  maxLines: 10,
                                  overflow: TextOverflow.clip,
                                  style: const TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold)),
                            ),
                            Text(author),
                            Text(publicationdate),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * .60,
                    child: readDownloadButton(),
                  ),
                ),
                const Spacer(),
                IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.favorite_border,
                      color: Colors.orange,
                    ))
              ],
            ),
            const Divider(),
            const Padding(
              padding: EdgeInsets.only(right: 10, left: 10, bottom: 5),
              child: Text(
                'Description:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                description,
                textAlign: TextAlign.justify,
              ),
            )
          ],
        ),
      ),
    );
  }
}
