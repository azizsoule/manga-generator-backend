import 'package:dio/dio.dart' as http_helper;
import 'package:manga_generator/manga_generator.dart';
import 'package:manga_generator/models/manga_case.dart';
import 'package:manga_generator/models/manga_details.dart';
import 'package:manga_generator/utils/api_urls.dart';
import 'package:manga_generator/utils/constants.dart';

class MangaGeneratorController extends ResourceController {
  final http_helper.Dio dio = http_helper.Dio();

  @Operation.post()
  Future<Response> generateManga(@Bind.body() MangaGeneratorDTO details) async {
    final List<MangaPanel> panels = [];

    try {
      final http_helper.Response response = await dio.post(
        ApiUrls.chat,
        options: http_helper.Options(
          headers: {'Authorization': "Bearer ${Constants.openIAapiKey}"},
        ),
        data: {
          "model": "gpt-3.5-turbo",
          "messages": [
            {"role": "system", "content": "You translate prompts into manga style scenario"},
            {"role": "system", "content": details.prompt}
          ]
        },
      );

      if (response.statusCode == 200) {
        String scenario = (response.data['choices']?[0]?['message']?['content'] ?? "") as String;

        logger.log(Level.INFO, "OPEN AI RESPONSE ${scenario}");

        final RegExp regExp = RegExp(
          r'Panel \d+:',
          caseSensitive: true,
          multiLine: true,
        );

        scenario = scenario.replaceAll(regExp, '');
        scenario = scenario.trim();

        logger.log(Level.INFO, "REGEXP APPLIED");

        final texts = scenario.split("\n");

        final eachFuture = await Future.forEach<String>(
          texts.where((text) => text.trim().isNotEmpty),
          (text) async {
            logger.log(Level.INFO, "START GETTING IMAGE");

            final imageGeneratorResponse = await dio.post(
              ApiUrls.imageGenerator,
              data: {
                'prompt': text,
                'style': details.style,
              },
            );

            if (imageGeneratorResponse.statusCode == 200) {
              logger.log(Level.INFO, "IMAGE URL ${imageGeneratorResponse.data}");

              panels.add(
                MangaPanel(
                  imageUrl: imageGeneratorResponse.data as String,
                  text: text,
                ),
              );
            }

            return imageGeneratorResponse.data;
          },
        );

        if (eachFuture == null) {
          return Response.ok(panels);
        }
      }

      return Response.ok(panels);
    } catch (e) {
      logger.log(Level.WARNING, e);
    }

    return Response.ok(panels);
  }
}
