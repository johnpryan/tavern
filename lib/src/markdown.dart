import 'package:build/build.dart';
import 'package:markdown/markdown.dart';
import 'package:tavern/src/extensions.dart';

Builder markdownBuilder(_) => MarkdownBuilder();

class MarkdownBuilder implements Builder {
  Future build(BuildStep buildStep) async {
    var inputId = buildStep.inputId;

    var outputId = inputId.changeExtension(Extensions.mustache);
    var contents = await buildStep.readAsString(inputId);
    var markdownContents =
        markdownToHtml(contents, extensionSet: ExtensionSet.gitHubWeb);

    await buildStep.writeAsString(outputId, markdownContents);
  }

  Map<String, List<String>> get buildExtensions => {
        Extensions.contents: [Extensions.mustache]
      };
}
