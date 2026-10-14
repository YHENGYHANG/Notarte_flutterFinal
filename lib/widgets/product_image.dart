import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

/// Network image with a loading spinner and a LOCAL fallback image
/// (shown when offline or when the link is broken).
class ProductImage extends StatelessWidget {
  final String url;
  final double? width;
  final double? height;
  final double radius;

  const ProductImage({
    super.key,
    required this.url,
    this.width,
    this.height,
    this.radius = 14,
  });

  Widget _fallback() => Image.asset(
        'assets/images/placeholder.png',
        width: width,
        height: height,
        fit: BoxFit.cover,
      );

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: url.trim().isEmpty
          ? _fallback()
          : Image.network(
              url,
              width: width,
              height: height,
              fit: BoxFit.cover,
              filterQuality: FilterQuality.medium,
              loadingBuilder: (context, child, progress) {
                if (progress == null) return child;
                return Container(
                  width: width,
                  height: height,
                  color: AppColors.sand,
                  child: const Center(
                    child: SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: AppColors.primaryLight,
                      ),
                    ),
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) => _fallback(),
            ),
    );
  }
}
