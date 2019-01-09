import 'package:build/build.dart';
import 'package:tavern/src/extensions.dart';
import 'package:path/path.dart' as p;

Builder partialBuilder(_) => PartialBuilder();

class PartialBuilder implements Builder {
  static final _includeRE = new RegExp(r'{{>(\s*)(.*)}}(\s*)');

  Future build(BuildStep buildStep) async {
    var inputId = buildStep.inputId;
    var outputId = buildStep.inputId.changeExtension(Extensions.withPartials);
    final relativeRootPath = p.dirname(inputId.path);

    var content = await buildStep.readAsString(inputId);
    final List<Future> futures = [];
    final Map<String, String> partials = {};

    _includeRE.allMatches(content).forEach((match) {
      final path = match.group(2);

      var readStrFuture = buildStep.readAsString(new AssetId(inputId.package, _normalizePath(path, relativeRootPath)));

      futures.add((readStrFuture).then((partial) async {
        final content = await partial;
        partials[path] = content;
      }).catchError((e) {
        print(e);
      }));
    });

    await Future.wait(futures);
    final newContent = content.replaceAllMapped(_includeRE, (match) {
      final path = match.group(2);
      return partials[path];
    });

    await buildStep.writeAsString(outputId, newContent);
  }

  Map<String, List<String>> get buildExtensions => {
    Extensions.htmlContent: [Extensions.withPartials],
  };

  String _normalizePath(String path, String relativeRootPath) {
    if (!path.startsWith('/')) {
      return '$relativeRootPath/$path';
    } else {
      return 'web$path';
    }
  }
}
