import 'package:manga_generator/manga_generator.dart';

class MangaPanel extends Serializable {
  MangaPanel({
    this.imageUrl = "",
    this.text = "",
  });

  String imageUrl;
  String text;

  @override
  Map<String, dynamic>? asMap() {
    return {
      'imageUrl': imageUrl,
      'text': text,
    };
  }

  @override
  void readFromMap(Map<String, dynamic> object) {
    imageUrl = (object["imageUrl"] ?? "") as String;
    text = (object["text"] ?? "") as String;
  }
}
