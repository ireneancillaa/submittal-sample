import 'package:flutter/material.dart';
import 'dashed_border.dart';

class DashedAddButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final double height;
  final Color primaryColor;

  const DashedAddButton({
    super.key,
    required this.label,
    required this.onTap,
    this.height = 48,
    this.primaryColor = const Color(0xFF008CFF),
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: DashedContainer(
        color: primaryColor.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: double.infinity,
          height: height,
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: primaryColor,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.add, color: Colors.white, size: 14),
              ),
              const SizedBox(width: 12),
              Text(
                label,
                style: TextStyle(
                  color: primaryColor,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
