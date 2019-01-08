import 'package:build/build.dart';
import 'package:markdown/markdown.dart';

Builder markdownBuilder(_) => MarkdownBuilder();

class MarkdownBuilder implements Builder {
  static const String _html = ".html";

  Future build(BuildStep buildStep) async {
    var inputId = buildStep.inputId;

    var outputId = inputId.changeExtension(_html);
    var contents = await buildStep.readAsString(inputId);
    var markdownContents = markdownToHtml(contents);

    await buildStep.writeAsString(outputId, markdownContents);
  }

  // TODO: support all .md .markdown .mdown
  Map<String, List<String>> get buildExtensions => {
        '.contents': [_html]
      };
}
