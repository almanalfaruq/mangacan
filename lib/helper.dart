import 'package:http/http.dart';
import 'package:mangacan/manga.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';

class Helper {

  Client _client;

  Helper() {
    this._client = Client();
  }

  Future<List<Manga>> getAllManga() async {
    List<Manga> allManga = [];
    final response = await _client.get('http://www.mangacanblog.com/daftar-komik-manga-bahasa-indonesia.html');
    final document = parse(response.body);
    final mangasPerTitle = document.getElementsByClassName('blix');
    for (Element mangaPerTitle in mangasPerTitle) {
      final mangas = mangaPerTitle.getElementsByTagName('li');
      for (Element m in mangas) {
        final aTag = m.getElementsByTagName('a')[0];
        final title = aTag.text;
        final url = aTag.attributes['href'];
        final manga = Manga(title: title, url: url);
        allManga.add(manga);
      }
    }
    return allManga;
  }
}