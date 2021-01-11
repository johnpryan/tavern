import 'package:build/build.dart';
import 'package:tavern/src/extensions.dart';

Builder partialBuilder(_) => PartialBuilder();

class PartialBuilder implements Builder {
  static final _includeRE = RegExp(r'{{>(\s*)(.*)}}(\s*)');

  @override
  Future build(BuildStep buildStep) async {
    var inputId = buildStep.inputId;
    var outputId = buildStep.inputId.changeExtension(Extensions.withPartials);

    var content = await buildStep.readAsString(inputId);
    final futures = <Future>[];
    final partials = <String, String>{};

    _includeRE.allMatches(content).forEach((match) {
      final path = match.group(2);

      var readStrFuture =
          buildStep.readAsString(AssetId(inputId.package, path));

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

  @override
  Map<String, List<String>> get buildExtensions => const {
        Extensions.markdownContent: [Extensions.withPartials],
      };
}
