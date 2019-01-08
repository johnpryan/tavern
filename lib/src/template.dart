import 'dart:convert';

import 'package:build/build.dart';
import 'package:tavern/src/extensions.dart';
import 'package:mustache/mustache.dart' as mustache;

Builder templateBuilder(_) => TemplateBuilder();

class TemplateBuilder implements Builder {

  Future build(BuildStep buildStep) async {
    var inputId = buildStep.inputId;

    var outputId = inputId.changeExtension(Extensions.html);
    var contents = await buildStep.readAsString(inputId);
    var metadataStr = await buildStep.readAsString(inputId.changeExtension(Extensions.metadata));
    var metadata = json.decode(metadataStr);

    var template = new mustache.Template(contents);
    var output = template.renderString(metadata);

    await buildStep.writeAsString(outputId, output);
  }

  Map<String, List<String>> get buildExtensions => {
    Extensions.htmlTemplate: [Extensions.html]
  };
}
