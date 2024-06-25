import 'package:flutter/services.dart';

class BulletPointInputFormatter extends TextInputFormatter {
  final String bullet = '\u2022 ';

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(
        text: "",
        selection: TextSelection.collapsed(offset: bullet.length),
      );
    }

    if (oldValue.text.endsWith(bullet) &&
        oldValue.text.length - newValue.text.length == 1) {
      final newText =
          newValue.text.substring(0, newValue.text.length - bullet.length);
      return newValue.copyWith(
        text: newText,
        selection: TextSelection.collapsed(offset: newText.length),
      );
    }

    if (newValue.text.endsWith('\n')) {
      final newText =
          newValue.text.substring(0, newValue.text.length - 1) + '\n$bullet';
      return newValue.copyWith(
        text: newText,
        selection: TextSelection.collapsed(offset: newText.length),
      );
    }

    if (oldValue.text.endsWith('$bullet') &&
        newValue.text.length > oldValue.text.length) {
      final lastBulletIndex = newValue.text.lastIndexOf(bullet);
      if (lastBulletIndex != -1 &&
          newValue.text.length > lastBulletIndex + bullet.length) {
        final textBeforeBullet =
            newValue.text.substring(0, lastBulletIndex + bullet.length);
        final textAfterBullet =
            newValue.text.substring(lastBulletIndex + bullet.length);

        if (textAfterBullet.isNotEmpty &&
            textAfterBullet[0] != textAfterBullet[0].toUpperCase()) {
          final capitalizedTextAfterBullet =
              textAfterBullet[0].toUpperCase() + textAfterBullet.substring(1);
          final capitalizedText = textBeforeBullet + capitalizedTextAfterBullet;

          return newValue.copyWith(
            text: capitalizedText,
            selection: TextSelection.collapsed(offset: capitalizedText.length),
          );
        }
      }
    }
    return newValue;
  }
}
