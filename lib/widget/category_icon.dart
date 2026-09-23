import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CategoryIconWidget extends StatelessWidget {
  final String imageUrl;
  final double width;
  final double height;
  final Color? color;

  const CategoryIconWidget({
    super.key,
    required this.imageUrl,
    this.width = 24,
    this.height = 24,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    if (imageUrl.isEmpty) {
      return Icon(Icons.build_rounded, size: width, color: color ?? Colors.grey);
    }

    final isNetwork = imageUrl.startsWith('http://') || imageUrl.startsWith('https://');
    final isSvg = imageUrl.toLowerCase().endsWith('.svg');

    if (isNetwork) {
      if (isSvg) {
        return SvgPicture.network(
          imageUrl,
          width: width,
          height: height,
          placeholderBuilder: (context) => SizedBox(
            width: width,
            height: height,
            child: const Center(
              child: CircularProgressIndicator(strokeWidth: 1.5),
            ),
          ),
        );
      } else {
        return Image.network(
          imageUrl,
          width: width,
          height: height,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) => Icon(Icons.broken_image, size: width),
        );
      }
    } else {
      if (isSvg) {
        return SvgPicture.asset(
          imageUrl,
          width: width,
          height: height,
        );
      } else {
        return Image.asset(
          imageUrl,
          width: width,
          height: height,
          fit: BoxFit.contain,
        );
      }
    }
  }
}
