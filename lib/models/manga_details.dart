import 'package:manga_generator/manga_generator.dart';

class MangaGeneratorDTO extends Serializable {
  MangaGeneratorDTO({
    this.prompt = "",
    this.style = "",
  });

  String prompt;
  String style;

  @override
  Map<String, dynamic>? asMap() {
    return {'scenario': prompt, 'style': style};
  }

  @override
  void readFromMap(Map<String, dynamic> object) {
    prompt = (object['scenario'] as String?) ?? "";
    style = (object['style'] as String?) ?? "";
  }
}
