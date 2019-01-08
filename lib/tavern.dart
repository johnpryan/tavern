library tavern;

import 'package:build/build.dart';
import 'package:markdown/markdown.dart';

Builder markdownBuilder(_) => MarkdownBuilder();

/// A really simple [Builder], it just makes copies!
class MarkdownBuilder implements Builder {
  String extension = ".html";

  Future build(BuildStep buildStep) async {
    /// Each [buildStep] has a single input.
    var inputId = buildStep.inputId;

    /// Create a new target [AssetId] based on the old one.
    var copy = inputId.changeExtension(extension);
    var contents = await buildStep.readAsString(inputId);

    /// Write out the new asset.
    ///
    /// There is no need to `await` here, the system handles waiting on these
    /// files as necessary before advancing to the next phase.
    var markdownContents = markdownToHtml(contents);
    buildStep.writeAsString(copy, markdownContents);
  }

  /// Configure output extensions. All possible inputs match the empty input
  /// extension. For each input 1 output is created with `extension` appended to
  /// the path.
  Map<String, List<String>> get buildExtensions => {'.md': [extension]};
}
