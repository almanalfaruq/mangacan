import 'package:flutter/material.dart';
import 'package:mangacan/inherited_manga.dart';
import 'package:url_launcher/url_launcher.dart';

import 'manga.dart';

class SearchManga extends SearchDelegate {
  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      IconButton(
        icon: Icon(Icons.close),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder<List<Manga>>(
      initialData: [],
      future: InheritedManga.of(context).helper.getMangaByQuery(query),
      builder: (BuildContext context, AsyncSnapshot<List<Manga>> snapshot) {
        switch(snapshot.connectionState) {
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
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Column();
  }

}