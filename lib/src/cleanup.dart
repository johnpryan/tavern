import 'package:build/build.dart';
import 'package:tavern/src/extensions.dart';

PostProcessBuilder cleanupBuilder(_) => CleanupBuilder();

class CleanupBuilder extends FileDeletingBuilder implements PostProcessBuilder {
  CleanupBuilder() : super([
    Extensions.markdown,
    Extensions.markdownContent,
    Extensions.htmlContent,
    Extensions.metadata,
    Extensions.mustache,
  ]);
}
