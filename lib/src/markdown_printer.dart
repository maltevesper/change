import 'package:change/src/changelog.dart';

/// Prints changelog into markdown
class MarkdownPrinter {
  /// Returns a [StringBuffer] containing markdown representation of [changelog].
  /// If [buffer] is passed, it will be printed into and returned.
  StringBuffer print(Changelog changelog, {StringBuffer buffer}) {
    buffer ??= StringBuffer();
    if (changelog.hasTitle) buffer.writeln('# ${changelog.title}');
    changelog.manifest.forEach((p) {
      buffer.writeln(p);
      buffer.writeln();
    });
    changelog.releases.forEach((r) => _printRelease(r, buffer));
    changelog.releases
        .where((r) => r.hasLink)
        .forEach((r) => buffer.writeln('[${r.version}]: ${r.diffUrl}'));
    return buffer;
  }

  void _printRelease(Release release, StringBuffer buffer) {
    if (release.diffUrl != null && release.diffUrl.isNotEmpty) {
      buffer.write('## [${release.version}]');
    } else {
      buffer.write('## ${release.version}');
    }
    if (release.date != null && release.date.isNotEmpty)
      buffer.write(' - ${release.date}');
    buffer.writeln();
    release.blocks.forEach((b) => _printBlock(b, buffer));
  }

  void _printBlock(Block block, StringBuffer buff) {
    buff.writeln('### ${block.type}');
    block.changes.forEach((c) => buff.writeln('- $c'));
    buff.writeln();
  }
}
