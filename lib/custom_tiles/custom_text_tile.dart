import 'package:flutter/material.dart';

class TextTile{
  Widget customTextBox(
        double availableWidth, String itemCaption, String item) {
      return Padding(
        padding: EdgeInsets.only(
            left: availableWidth * .1, right: availableWidth * .1),
        child: Row(
          children: [
            SizedBox(width: availableWidth * 0.2, child: Text(itemCaption)),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(":"),
            ),
            SizedBox(
                child: Text(
              item,
              overflow: TextOverflow.ellipsis,
            ))
          ],
        ),
      );
    }
  }