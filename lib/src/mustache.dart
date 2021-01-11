import 'dart:convert';

import 'package:build/build.dart';
import 'package:glob/glob.dart';
import 'package:tavern/src/extensions.dart';
import 'package:mustache_template/mustache.dart' as mustache;

Builder mustacheBuilder(_) => MustacheBuilder();

class MustacheBuilder implements Builder {
  @override
  Future build(BuildStep buildStep) async {
    var inputId = buildStep.inputId;

    var outputId = inputId.changeExtension(Extensions.html);
    var contents = await buildStep.readAsString(inputId);
    var metadata = await _readMetadata(buildStep);
    var templateName = metadata['template'] ?? '';
    var templateStr = await _readTemplate(buildStep, templateName);

    var template = mustache.Template(templateStr, lenient: true);

    // also render the metadata to the input file
    var contentTemplate = mustache.Template(contents, lenient: true);
    metadata['content'] = contentTemplate.renderString(metadata);

    var output = template.renderString(metadata);

    await buildStep.writeAsString(outputId, output);
  }

  Future<String> _readTemplate(BuildStep buildStep, String fileName) async {
    var assets = await buildStep.findAssets(Glob('**.mustache')).toList();
    for (var asset in assets) {
      var assetFileName = asset.path;
      if (assetFileName == fileName) {
        var assetStr =
            await buildStep.readAsString(AssetId(asset.package, asset.path));
        return assetStr;
      }
    }

    return '';
  }

  @override
  Map<String, List<String>> get buildExtensions => const {
        Extensions.htmlContent: [Extensions.html],
      };

  Future<Map<String, dynamic>> _readMetadata(BuildStep buildStep) async {
    var id = buildStep.inputId.changeExtension(Extensions.metadata);
    try {
      return _parseNonNull(await buildStep.readAsString(id));
    } on AssetNotFoundException {
      return {};
    }
  }

  static Map<String, dynamic> _parseNonNull(String metadata) {
    try {
      return json.decode(metadata) ?? {};
    } on FormatException {
      return {};
    }
  }
}
