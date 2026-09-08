import 'package:flutter/material.dart';

class ZelixaLogo extends StatelessWidget {
  final double iconSize;
  final double titleSize;
  final double subtitleSize;
  final bool showText;
  final Color textColor;
  final Color subtitleColor;
  final Color primaryColor;

  const ZelixaLogo({
    super.key,
    this.iconSize = 80,
    this.titleSize = 30,
    this.subtitleSize = 14,
    this.showText = true,
    this.textColor = Colors.white,
    this.subtitleColor = Colors.white70,
    this.primaryColor = const Color(0xFFE2B75A),
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.all(iconSize * 0.3),
          decoration: BoxDecoration(
            color: primaryColor.withValues(alpha: 0.12),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.menu_book_rounded,
            size: iconSize,
            color: primaryColor,
          ),
        ),
        if (showText) ...[
          SizedBox(height: iconSize * 0.3),
          Text(
            'Zelixa Quran',
            style: TextStyle(
              fontSize: titleSize,
              fontWeight: FontWeight.bold,
              color: textColor,
              letterSpacing: 0.5,
            ),
          ),
          SizedBox(height: titleSize * 0.2),
          Text(
            'Al-Qur\'an Digital & Sahabat Ibadah',
            style: TextStyle(
              color: subtitleColor,
              fontSize: subtitleSize,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }
}
