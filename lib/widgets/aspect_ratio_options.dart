import 'package:flutter/material.dart';

class AspectRatioOptions extends StatelessWidget {
  final Function(String) onOptionSelected;

  const AspectRatioOptions({
    Key? key,
    required this.onOptionSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        left: 12.0,
        right: 12.0,
        top: 2.0,
        bottom: 6.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // Bot avatar
          Container(
            width: 32.0,
            height: 32.0,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF4F46E5).withOpacity(0.4),
                  blurRadius: 15.0,
                  offset: const Offset(0, 5),
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10.0,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: const Icon(
              Icons.psychology_rounded,
              color: Colors.white,
              size: 22.0,
            ),
          ),
          const SizedBox(width: 8.0),
          // Options container
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF1A1A24), Color(0xFF0D0D12)],
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(18.0),
                  topRight: Radius.circular(18.0),
                  bottomLeft: Radius.circular(6.0),
                  bottomRight: Radius.circular(18.0),
                ),
                border: Border.all(
                  color: const Color(0xFF06FFA5).withOpacity(0.3),
                  width: 1.0,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF06FFA5).withOpacity(0.2),
                    blurRadius: 20.0,
                    offset: const Offset(0, 8),
                  ),
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 12.0,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Select aspect ratio',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 12.0),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      // Check if we have enough space for all options
                      if (constraints.maxWidth < 280) {
                        // Use scrollable row for smaller screens
                        return SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              _buildRatioOption('1:1', 40, 40),
                              _buildRatioOption('9:16', 30, 45),
                              _buildRatioOption('16:9', 45, 30),
                              _buildRatioOption('3:4', 35, 42),
                            ],
                          ),
                        );
                      } else {
                        // Use spaced row for larger screens
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildRatioOption('1:1', 40, 40),
                            _buildRatioOption('9:16', 30, 45),
                            _buildRatioOption('16:9', 45, 30),
                            _buildRatioOption('3:4', 35, 42),
                          ],
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatioOption(String ratio, double width, double height) {
    return GestureDetector(
      onTap: () => onOptionSelected(ratio),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          children: [
            Container(
              width: width,
              height: height,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF06FFA5), Color(0xFF059669)],
                ),
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                  width: 2.0,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF06FFA5).withOpacity(0.4),
                    blurRadius: 12.0,
                    offset: const Offset(0, 6),
                  ),
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 8.0,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 6.0),
            Text(
              ratio,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 12.0,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
