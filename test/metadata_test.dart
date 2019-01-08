import 'package:test/test.dart';
import 'package:tavern/src/metadata.dart';
import 'package:tavern/src/utils.dart';
import 'dart:io';

main() {
  group('extract metadata', () {
    test('extracts metadata', () {
      var path = 'test/fixtures/metadata.md';
      var file = new File(path);
      var contents = file.readAsStringSync();
      var result = extractMetadata(contents, path);
      expect(result.metadata, isNotNull);
      expect(result.content, isNotNull);
      expect(result.metadata.keys, contains('foo'));
      expect(result.content, startsWith('# header'));
    });
    test('returns null if no metadata', () {
      var path = 'test/fixtures/no_metadata.md';
      var file = new File(path);
      var contents = file.readAsStringSync();
      var result = extractMetadata(contents, path);
      expect(result, isNull);
    });

    test('throws if bad metadata', () {
      var path = 'test/fixtures/bad_metadata.md';
      var file = new File(path);
      var contents = file.readAsStringSync();
      expect(() => extractMetadata(contents, path), throwsA(anything));
    });

    test('generateMetadataPath', () {
      var input = 'test/fixtures/foo.md';
      var expected = 'test/fixtures/foo.metadata.json';
      expect(getMetadataPath(input), expected);
    });
  });
}
