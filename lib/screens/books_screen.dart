import 'package:flutter/material.dart';
import 'package:my_ebook_reader/category_data/books_list.dart';
import 'package:my_ebook_reader/widgets/books_item.dart';

import '../utils/enums.dart';
import '../widgets/background_widget.dart';

class BooksScreen extends StatefulWidget {
  List<dynamic> bookslist;
  CategoryName categoryName;
  BooksScreen(this.bookslist, this.categoryName);

  @override
  State<BooksScreen> createState() => _BooksScreenState();
}

class _BooksScreenState extends State<BooksScreen> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const BackgroundWidget(),
        GridView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: BOOKSLIST.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 0.45,
                crossAxisSpacing: 2,
                mainAxisSpacing: 1),
            itemBuilder: (ctx, index) {
              return BooksItem(
                category: widget.categoryName,
                id: widget.bookslist[index]['id'],
                title: widget.bookslist[index]['title'],
                author: widget.bookslist[index]['author']['name'],
                url: widget.bookslist[index]['link'][1]['-href'],
              );
            }),
      ],
    );
  }
}
