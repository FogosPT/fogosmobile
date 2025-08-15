import 'package:flutter/gestures.dart' show TapGestureRecognizer;
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart' show launchUrl;

/// A class that encapsulates [describe the main goal or responsibility of the class].
///
/// ## Dependencies
/// - Requires the following libraries: url_launcher.
///
/// ## Arguments
/// Creates a [TextPartiallyUrl] widget.
///
///
/// This class is designed to [explain the intended use or behavior of the class].
class TextPartiallyUrl extends StatelessWidget {
  /// The text to be displayed before the URL
  final String text;

  /// The URL to be launched when the text is tapped
  final String url;

  /// The text that will be displayed as a clickable URL
  final String textUrl;

  const TextPartiallyUrl({
    super.key,
    required this.text,
    required this.url,
    required this.textUrl,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: Theme.of(context).textTheme.bodyMedium,
        children: [
          TextSpan(text: text),
          TextSpan(
            text: textUrl,
            style: const TextStyle(
              color: Colors.blue,
              decoration: TextDecoration.underline,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                launchUrl(Uri.parse(url));
              },
          ),
        ],
      ),
    );
  }
}
