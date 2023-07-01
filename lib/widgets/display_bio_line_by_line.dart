import 'package:flutter/material.dart';

class DisplayBio extends StatefulWidget {
  final userdata;
  DisplayBio({super.key, required this.userdata});

  @override
  State<DisplayBio> createState() => _DisplayBioState();
}

class _DisplayBioState extends State<DisplayBio> {
  bool _readmoretapped = false;
  bool _ishovered = false;

  String displayLineByLine(String text, int wordLimit) {
    List<String> words = text.split(' ');
    List<String> lines = [];

    String currentLine = '';

    for (int i = 0; i < words.length; i++) {
      String word = words[i];

      if ((currentLine + word).length <= wordLimit) {
        currentLine += word + ' ';
      } else {
        lines.add(currentLine.trim());
        currentLine = word + ' ';
      }

      if (i == words.length - 1) {
        lines.add(currentLine.trim());
      }
    }

    return lines.join('\n');
  }

  checkcode(String text) {
    if (text.length >= 50) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            text,
            maxLines: 2,
          ),
          InkWell(
              onHover: (value) {
                setState(() {
                  _ishovered = true;
                });
              },
              onTap: () {
                setState(() {
                  _readmoretapped = !_readmoretapped;
                });
              },
              child: Opacity(
                opacity: _ishovered ? 0.5 : 1, 
                child: const Text(
                  'readmore',
                  style: TextStyle(
                    color: Color.fromARGB(255, 7, 125, 236),
                    fontSize: 13,
                  ),
                ),
              ))
        ],
      );
    } else {
      return Text(text);
    }
  }

  @override
  Widget build(BuildContext context) {
    String text = displayLineByLine(widget.userdata['bio'], 56);

    return _readmoretapped ? Text(text) : checkcode(text);
  }
}
