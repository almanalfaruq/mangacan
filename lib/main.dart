import 'package:flutter/material.dart';
import 'package:mangacan/inherited_manga.dart';
import 'package:mangacan/helper.dart';
import 'package:mangacan/manga.dart';
import 'package:mangacan/search_manga.dart';
import 'package:url_launcher/url_launcher.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InheritedManga(
      helper: Helper(),
      child: MaterialApp(
        title: 'Mangacan',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MyHomePage(title: 'Mangacan - Manga Reader'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: NestedScrollView(
      headerSliverBuilder: (buildContext, headerSliverBuilder) {
        return <Widget>[
          SliverAppBar(
            floating: true,
            snap: true,
            title: Text('Mangacan - Manga Reader'),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  showSearch(context: context, delegate: SearchManga());
                },
              )
            ],
          ),
        ];
      },
      body: FutureBuilder<List<Manga>>(
        initialData: List<Manga>(),
        future: InheritedManga.of(context).helper.getAllManga(),
        builder: (BuildContext context, AsyncSnapshot<List<Manga>> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.active:
            case ConnectionState.waiting:
              return Center(
                child: RefreshProgressIndicator(),
              );
            case ConnectionState.none:
              return Center(
                child: Text('Tidak ada koneksi'),
              );
            case ConnectionState.done:
              if (snapshot.hasError) {
                return Center(
                  child: Text('Data yang diterima salah'),
                );
              }
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Icon(Icons.book),
                    title: Text(snapshot.data[index].title),
                    onTap: () async {
                      if (await canLaunch(snapshot.data[index].url)) {
                        await launch(snapshot.data[index].url);
                      }
                    },
                  );
                },
              );
          }
          return Column();
        },
      ),
    ));
  }
}
