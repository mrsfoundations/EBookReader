import 'package:flutter/material.dart';
import 'package:my_ebook_reader/providers/downloads_provider.dart';
import 'package:my_ebook_reader/screens/book_detail_screen.dart';
import 'package:my_ebook_reader/screens/downloads_screen.dart';
import 'package:my_ebook_reader/utils/consts.dart';
import 'package:provider/provider.dart';

import 'screens/book_detail_screen2.dart';
import 'screens/splash_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => DownloadsProvider())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: Constants.appName,
        theme: ThemeData(
            primaryColor: Colors.blue,
            colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue)
                .copyWith(secondary: Colors.deepOrange)),
        initialRoute: '/',
        routes: {
          '/': ((context) => const SplashScreen()),
          BookDetailsScreen.routeName: ((context) => const BookDetailsScreen()),
          BookDetailsScreen2.routeName: ((context) =>
              const BookDetailsScreen2()),
          DownloadsScreen.routeName: ((context) => DownloadsScreen())
        },
      ),
    );
  }
}
