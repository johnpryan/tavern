import 'dart:html';

main() {
  var message = new ParagraphElement()
    ..text = "This paragraph was added using Dart";
  var host = querySelector('#content');
  host.children.add(message);
}
