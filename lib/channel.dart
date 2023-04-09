import 'package:manga_generator/controllers/manga_generator_controller.dart';
import 'package:manga_generator/manga_generator.dart';

/// This type initializes an application.
///
/// Override methods in this class to set up routes and initialize services like
/// database connections. See http://conduit.io/docs/http/channel/.
class MangaGeneratorChannel extends ApplicationChannel {
  /// Initialize services in this method.
  ///
  /// Implement this method to initialize services, read values from [options]
  /// and any other initialization required before constructing [entryPoint].
  ///
  /// This method is invoked prior to [entryPoint] being accessed.
  @override
  Future prepare() async {
    logger.onRecord.listen((rec) => print("$rec ${rec.error ?? ""} ${rec.stackTrace ?? ""}"));
    CORSPolicy.defaultPolicy.allowedOrigins.addAll(["*"]);
    CORSPolicy.defaultPolicy.allowedRequestHeaders.addAll(["*"]);
    CORSPolicy.defaultPolicy.allowedMethods.addAll(["*"]);
    CORSPolicy.defaultPolicy.allowedRequestHeaders.addAll(["*"]);
  }

  /// Construct the request channel.
  ///
  /// Return an instance of some [Controller] that will be the initial receiver
  /// of all [Request]s.
  ///
  /// This method is invoked after [prepare].
  @override
  Controller get entryPoint {
    final router = Router();

    // Prefer to use `link` instead of `linkFunction`.
    // See: https://conduit.io/docs/http/request_controller/
    router.route("/api/generate-manga").link(MangaGeneratorController.new);
    return router;
  }
}
