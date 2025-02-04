import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BricolageText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final int? maxLines;
  final bool? softWrap;
  const BricolageText(
      {super.key,
      required this.text,
      this.textAlign = TextAlign.center,
      this.style = const TextStyle(),
      this.overflow = TextOverflow.visible,
      this.maxLines,
      this.softWrap = true});
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      overflow: overflow,
      softWrap: softWrap,
      maxLines: maxLines,
      textAlign: textAlign,
      style: GoogleFonts.bricolageGrotesque(textStyle: style),
    );
  }
}
