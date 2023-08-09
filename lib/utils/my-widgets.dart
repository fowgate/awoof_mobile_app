import 'package:awoof_app/utils/size-config.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class SocialContainer extends StatelessWidget {

  SocialContainer({
    required this.text,
    required this.url,
    required this.onPressed
  });

  final String text;
  final String url;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
      child: GestureDetector(
        onTap: onPressed(),
        child: Container(
          width: SizeConfig.screenWidth! * 0.4,
          height: 58.34,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(8),
            ),
            border: Border.all(
              width: 2,
              color: Color(0xFFDFE2E7),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 24,
                height: 24,
                child: Image.asset(
                  url,
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(width: 10),
              Text(
                text,
                style: TextStyle(
                  color: Color(0xff021642),
                  fontSize: 17,
                  fontFamily: "Regular",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ComingSoonContainer extends StatelessWidget {

  ComingSoonContainer({
    required this.text,
    required this.url,
  });

  final String text;
  final String url;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
      width: SizeConfig.screenWidth,
      height: 56,
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          color: Color(0xFFFFFFFF).withOpacity(0.7),
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(5),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Opacity(
                  opacity: 0.7,
                  child: Container(
                    width: 24,
                    height: 24,
                    child: Image.asset(
                      url,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                Text(
                  text,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    fontFamily: "Regular",
                    color: Color(0xffB2D2C3),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ExpandableText extends StatefulWidget {

  const ExpandableText(
    this.text, {
      Key? key,
      this.trimLines = 3,
      required this.username,
    }) : assert(text != null), super(key: key);

  final String text;

  final String username;

  final int trimLines;

  @override
  ExpandableTextState createState() => ExpandableTextState();
}

class ExpandableTextState extends State<ExpandableText> {

  bool _readMore = true;

  void _onTapLink() {
    setState(() => _readMore = !_readMore);
  }

  @override
  Widget build(BuildContext context) {

    TextSpan link = TextSpan(
      text: _readMore ? "...more" : "less",
      style: TextStyle(
        fontSize: 14,
        fontFamily: 'Regular',
        color: Color(0xFF000000).withOpacity(0.5),
        fontWeight: FontWeight.normal,
      ),
      recognizer: TapGestureRecognizer()..onTap = _onTapLink
    );

    Widget result = LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        assert(constraints.hasBoundedWidth);
        final double maxWidth = constraints.maxWidth;
        // Create a TextSpan with data
        final text = TextSpan(
          text: widget.text,
          style: TextStyle(
            fontSize: 14,
            fontFamily: 'Regular',
            color: Color(0xFF000000).withOpacity(0.5),
            fontWeight: FontWeight.normal,
          )
        );
        // Layout and measure link

        //[TextPainter] this is to calculate the amount of text that can be inserted
        TextPainter textPainter = TextPainter(
          text: link,
          textDirection: TextDirection.rtl,//better to pass this from master widget if ltr and rtl both supported
          maxLines: widget.trimLines,
          ellipsis: '...',
        );
        textPainter.layout(minWidth: constraints.minWidth, maxWidth: maxWidth);
        final linkSize = textPainter.size;
        // Layout and measure text
        textPainter.text = text;
        textPainter.layout(minWidth: constraints.minWidth, maxWidth: maxWidth);
        final textSize = textPainter.size;
        // Get the endIndex of data
        int endIndex;
        final pos = textPainter.getPositionForOffset(Offset(
          textSize.width - linkSize.width,
          textSize.height,
        ));
        endIndex = textPainter.getOffsetBefore(pos.offset)!;
        var textSpan;
        if (textPainter.didExceedMaxLines) {
          textSpan = TextSpan(
            text: widget.username,
            style: TextStyle(
              fontSize: 14,
              fontFamily: 'Bold',
              color: Color(0xFF000000),
              fontWeight: FontWeight.normal,
            ),
            children: <TextSpan>[
              TextSpan(
                text: _readMore
                    ? widget.text.substring(0, endIndex)
                    : widget.text,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  fontFamily: 'Regular',
                  color: Color(0xFF000000),
                ),
              ),
              link
            ],
          );
        } else {
          textSpan = TextSpan(
            text: widget.username,
            style: TextStyle(
              fontSize: 14,
              fontFamily: 'Bold',
              color: Color(0xFF000000),
              fontWeight: FontWeight.normal,
            ),
            children: <TextSpan>[
              TextSpan(
                text: widget.text,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  fontFamily: 'Regular',
                  color: Color(0xFF000000),
                ),
              )
            ]
          );
        }
        return RichText(
          softWrap: true,
          overflow: TextOverflow.clip,
          text: textSpan,
        );
      },
    );
    return result;
  }
}

class Button extends StatelessWidget {

  final void Function() onTap;

  final Color buttonColor;

  final Color foregroundColor;

  final Widget child;

  final double width;

  final double radius;

  const Button({
    Key? key,
    required this.onTap,
    required this.buttonColor,
    required this.foregroundColor,
    required this.child,
    required this.width,
    required this.radius
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          primary: buttonColor, // background
          onPrimary: foregroundColor ?? Color(0xFFFFFFFF), // foreground
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(radius ?? 0)),
          )
      ),
      onPressed: onTap,
      child: Container(
        width: width ?? SizeConfig.screenWidth,
        height: 56,
        child: child,
      ),
    );
  }

}