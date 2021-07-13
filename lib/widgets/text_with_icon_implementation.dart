import 'package:flutter/material.dart';

class TextWithIconImplementation extends StatelessWidget {
  const TextWithIconImplementation({Key key,
    @required this.label,
  }) : super(key: key);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            )
          ),
          Spacer(),
          Icon(Icons.arrow_forward, size: 30),
        ],
      ),
    );
  }
}
