import 'dart:math' as math;
import 'package:flutter/material.dart';

class KiblatScreen extends StatefulWidget {
  const KiblatScreen({super.key});

  @override
  State<KiblatScreen> createState() => _KiblatScreenState();
}

class _KiblatScreenState extends State<KiblatScreen> {
  // Qibla direction from Indonesia is approximately 295 degrees (West-Northwest)
  final double _qiblaAngleDegrees = 295.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Arah Kiblat', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF0F3A26),
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: const Row(
                  children: [
                    Icon(Icons.info_outline, color: Color(0xFF0F3A26)),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Posisikan ponsel Anda pada permukaan yang datar dan jauhkan dari benda logam/magnetik.',
                        style: TextStyle(fontSize: 13, color: Colors.black87),
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // Compass Dial
              Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Outer Compass Ring
                    Container(
                      width: 280,
                      height: 280,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        border: Border.all(color: const Color(0xFF0F3A26), width: 3),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.06),
                            blurRadius: 16,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Cardinal Directions
                          const Positioned(
                            top: 12,
                            child: Text('U (0°)', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
                          ),
                          const Positioned(
                            bottom: 12,
                            child: Text('S (180°)', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                          ),
                          const Positioned(
                            right: 12,
                            child: Text('T (90°)', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                          ),
                          const Positioned(
                            left: 12,
                            child: Text('B (270°)', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                          ),
                        ],
                      ),
                    ),

                    // Rotating Qibla Needle Pointing to 295°
                    Transform.rotate(
                      angle: _qiblaAngleDegrees * (math.pi / 180.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Ka'bah pointer icon at top of needle
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              color: Color(0xFF0F3A26),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.mosque,
                              color: Color(0xFFE2B75A),
                              size: 26,
                            ),
                          ),
                          Container(
                            width: 4,
                            height: 80,
                            decoration: BoxDecoration(
                              color: const Color(0xFFE2B75A),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          const SizedBox(height: 70), // Center pivot balance
                        ],
                      ),
                    ),

                    // Center Pivot
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: const Color(0xFF0F3A26),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 3),
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // Qibla Info Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF0F3A26),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        const Text(
                          'Derajat Kiblat',
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${_qiblaAngleDegrees.toInt()}° BBL',
                          style: const TextStyle(
                            color: Color(0xFFE2B75A),
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Container(width: 1, height: 32, color: Colors.white24),
                    const Column(
                      children: [
                        Text(
                          'Jarak ke Ka\'bah',
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                        SizedBox(height: 4),
                        Text(
                          '± 7.920 km',
                          style: TextStyle(
                            color: Color(0xFFE2B75A),
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
