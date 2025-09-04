import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class MarkdownMessageWidget extends StatelessWidget {
  final String text;
  final bool isUser;
  final Color textColor;

  const MarkdownMessageWidget({
    Key? key,
    required this.text,
    required this.isUser,
    required this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isUser) {
      // For user messages, just show plain text
      return Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: 16,
          height: 1.4,
        ),
        textAlign: TextAlign.start,
        softWrap: true,
        overflow: TextOverflow.visible,
      );
    } else {
      // For AI messages, render as markdown
      return MarkdownBody(
        data: text,
        styleSheet: MarkdownStyleSheet(
          p: TextStyle(
            color: textColor,
            fontSize: 16,
            height: 1.4,
          ),
          h1: TextStyle(
            color: textColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            height: 1.3,
          ),
          h2: TextStyle(
            color: textColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            height: 1.3,
          ),
          h3: TextStyle(
            color: textColor,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            height: 1.3,
          ),
          strong: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
          ),
          em: TextStyle(
            color: textColor,
            fontStyle: FontStyle.italic,
          ),
          code: TextStyle(
            color: textColor,
            backgroundColor: Colors.grey[200],
            fontFamily: 'monospace',
            fontSize: 14,
          ),
          codeblockDecoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[300]!),
          ),
          blockquote: TextStyle(
            color: textColor.withOpacity(0.8),
            fontStyle: FontStyle.italic,
          ),
          blockquoteDecoration: BoxDecoration(
            color: Colors.grey[50],
            border: Border(
              left: BorderSide(
                color: Colors.grey[400]!,
                width: 4,
              ),
            ),
          ),
          listBullet: TextStyle(
            color: textColor,
            fontSize: 16,
          ),
        ),
        selectable: true,
      );
    }
  }
}
