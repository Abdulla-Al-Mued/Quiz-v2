import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';

class LatexText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign textAlign;

  const LatexText({
    super.key,
    required this.text,
    this.style,
    this.textAlign = TextAlign.start,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final defaultStyle = style ?? theme.textTheme.bodyLarge!;

    // Check if text contains LaTeX (enclosed in $ or $$)
    if (_containsLatex(text)) {
      return _buildLatexWidget(context, defaultStyle);
    } else {
      return Text(
        text,
        style: defaultStyle,
        textAlign: textAlign,
      );
    }
  }

  bool _containsLatex(String text) {
    return text.contains(RegExp(r'\$.*?\$'));
  }

  Widget _buildLatexWidget(BuildContext context, TextStyle style) {
    final parts = _parseLatexText(text);

    if (parts.length == 1 && parts.first.isLatex) {
      // Single LaTeX expression
      return Center(
        child: Math.tex(
          parts.first.content,
          textStyle: style,
          mathStyle: MathStyle.display,
        ),
      );
    }

    // Mixed text and LaTeX
    return Wrap(
      alignment: _getWrapAlignment(),
      children: parts.map((part) {
        if (part.isLatex) {
          return Math.tex(
            part.content,
            textStyle: style,
            mathStyle: MathStyle.text,
          );
        } else {
          return Text(
            part.content,
            style: style,
          );
        }
      }).toList(),
    );
  }

  WrapAlignment _getWrapAlignment() {
    switch (textAlign) {
      case TextAlign.center:
        return WrapAlignment.center;
      case TextAlign.end:
      case TextAlign.right:
        return WrapAlignment.end;
      case TextAlign.justify:
        return WrapAlignment.spaceBetween;
      default:
        return WrapAlignment.start;
    }
  }

  List<_TextPart> _parseLatexText(String text) {
    final parts = <_TextPart>[];
    final regex = RegExp(r'\$(.*?)\$');
    int lastEnd = 0;

    for (final match in regex.allMatches(text)) {
      // Add text before LaTeX
      if (match.start > lastEnd) {
        final textPart = text.substring(lastEnd, match.start);
        if (textPart.isNotEmpty) {
          parts.add(_TextPart(textPart, false));
        }
      }

      // Add LaTeX part
      parts.add(_TextPart(match.group(1)!, true));
      lastEnd = match.end;
    }

    // Add remaining text
    if (lastEnd < text.length) {
      final remaining = text.substring(lastEnd);
      if (remaining.isNotEmpty) {
        parts.add(_TextPart(remaining, false));
      }
    }

    return parts;
  }
}

class _TextPart {
  final String content;
  final bool isLatex;

  _TextPart(this.content, this.isLatex);
}