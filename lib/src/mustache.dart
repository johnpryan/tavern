import 'dart:convert';

import 'package:build/build.dart';
import 'package:tavern/src/extensions.dart';
import 'package:mustache/mustache.dart' as mustache;

Builder mustacheBuilder(_) => MustacheBuilder();

class MustacheBuilder implements Builder {
  Future build(BuildStep buildStep) async {
    var inputId = buildStep.inputId;

    print("mustache inputId = $inputId");

    var outputId = inputId.changeExtension(Extensions.html);
    var contents = await buildStep.readAsString(inputId);
    var metadata = await _readMetadata(buildStep);

    var template = new mustache.Template(contents, lenient: true);
    var output = template.renderString(metadata);

    await buildStep.writeAsString(outputId, output);
  }

  Map<String, List<String>> get buildExtensions => {
        Extensions.htmlContent: [Extensions.html],
        Extensions.mustache: [Extensions.html],
      };

  Future<Map<String, dynamic>> _readMetadata(BuildStep buildStep) async {
    var id = buildStep.inputId.changeExtension(Extensions.metadata);
    try {
      return _parseNonNull(await buildStep.readAsString(id));
    } on AssetNotFoundException {
      return <String, dynamic>{};
    }
  }

  static Map<String, dynamic> _parseNonNull(String metadata) {
    try {
      var m = json.decode(metadata);
      if (m == null) {
        return <String, dynamic>{};
      }
      return m;
    } on FormatException {
      return <String, dynamic>{};
    }
  }
}
