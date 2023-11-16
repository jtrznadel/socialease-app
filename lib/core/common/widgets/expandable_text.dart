import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:social_ease_app/core/extensions/context_extension.dart';
import 'package:social_ease_app/core/res/colors.dart';

class ExpandableText extends StatefulWidget {
  const ExpandableText(this.context,
      {super.key, required this.text, this.style});

  final String text;
  final TextStyle? style;
  final BuildContext context;

  @override
  State<ExpandableText> createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  bool expanded = false;
  late TextSpan textSpan;
  late TextPainter textPainter;

  @override
  void initState() {
    textSpan = TextSpan(
      text: widget.text,
    );

    textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
        maxLines: expanded ? null : 2)
      ..layout(
        maxWidth: widget.context.width * .9,
      );
    super.initState();
  }

  @override
  void dispose() {
    textPainter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const defaultStyle = TextStyle(
      height: 1.8,
      fontSize: 16,
      color: AppColors.secondaryTextColor,
    );
    return Container(
      child: textPainter.didExceedMaxLines
          ? RichText(
              textAlign: TextAlign.justify,
              text: TextSpan(
                  text: expanded
                      ? widget.text
                      : '${widget.text.substring(
                          0,
                          textPainter
                              .getPositionForOffset(
                                Offset(
                                  widget.context.width,
                                  widget.context.height,
                                ),
                              )
                              .offset,
                        )}...',
                  style: widget.style ?? defaultStyle,
                  children: [
                    TextSpan(
                        text: expanded ? ' show less' : ' show more',
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            setState(() {
                              expanded = !expanded;
                            });
                          },
                        style: const TextStyle(
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.w600,
                        )),
                  ]),
            )
          : Text(
              widget.text,
              style: widget.style ?? defaultStyle,
            ),
    );
  }
}
