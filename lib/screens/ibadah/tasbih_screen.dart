import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TasbihScreen extends StatefulWidget {
  const TasbihScreen({super.key});

  @override
  State<TasbihScreen> createState() => _TasbihScreenState();
}

class _TasbihScreenState extends State<TasbihScreen> {
  int _counter = 0;
  int _target = 33;
  int _selectedDzikirIndex = 0;

  final List<String> _dzikirOptions = [
    'سُبْحَانَ اللّٰهِ (Subhanallah)',
    'الْحَمْدُ لِلّٰهِ (Alhamdulillah)',
    'اللّٰهُ أَكْبَرُ (Allahu Akbar)',
    'لَا إِلٰهَ إِلَّا اللّٰهُ (La ilaha illallah)',
    'أَسْتَغْفِرُ اللّٰهَ (Astaghfirullah)',
    'اللّٰهُمَّ صَلِّ عَلَى مُحَمَّدٍ (Shalawat)',
  ];

  void _increment() {
    HapticFeedback.mediumImpact();
    setState(() {
      _counter++;
      if (_counter == _target) {
        HapticFeedback.vibrate();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Target $_target kali telah tercapai! Alhamdulillah.'),
            backgroundColor: const Color(0xFF0F3A26),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    });
  }

  void _reset() {
    setState(() {
      _counter = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final progress = _target > 0 ? (_counter / _target).clamp(0.0, 1.0) : 0.0;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Tasbih Digital', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF0F3A26),
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              // Target Selector & Reset
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  DropdownButton<int>(
                    value: _target,
                    underline: const SizedBox(),
                    items: const [
                      DropdownMenuItem(value: 33, child: Text('Target: 33x')),
                      DropdownMenuItem(value: 99, child: Text('Target: 99x')),
                      DropdownMenuItem(value: 100, child: Text('Target: 100x')),
                      DropdownMenuItem(value: 1000, child: Text('Target: 1000x')),
                    ],
                    onChanged: (val) {
                      if (val != null) setState(() => _target = val);
                    },
                  ),
                  TextButton.icon(
                    icon: const Icon(Icons.refresh, color: Colors.redAccent, size: 18),
                    label: const Text('Reset', style: TextStyle(color: Colors.redAccent)),
                    onPressed: _reset,
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Dzikir selector chip/card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.02),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<int>(
                    isExpanded: true,
                    value: _selectedDzikirIndex,
                    items: List.generate(
                      _dzikirOptions.length,
                      (i) => DropdownMenuItem(
                        value: i,
                        child: Text(
                          _dzikirOptions[i],
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0F3A26),
                          ),
                        ),
                      ),
                    ),
                    onChanged: (val) {
                      if (val != null) {
                        setState(() {
                          _selectedDzikirIndex = val;
                          _counter = 0;
                        });
                      }
                    },
                  ),
                ),
              ),

              const Spacer(),

              // Circular Counter
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 220,
                    height: 220,
                    child: CircularProgressIndicator(
                      value: progress,
                      strokeWidth: 10,
                      backgroundColor: Colors.grey.shade200,
                      valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFE2B75A)),
                    ),
                  ),
                  InkWell(
                    onTap: _increment,
                    borderRadius: BorderRadius.circular(100),
                    child: Container(
                      width: 190,
                      height: 190,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const RadialGradient(
                          colors: [Color(0xFF1E5B3D), Color(0xFF0F3A26)],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF0F3A26).withValues(alpha: 0.3),
                            blurRadius: 16,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '$_counter',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 54,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '/ $_target',
                            style: const TextStyle(color: Colors.white70, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),
              const Text(
                'Ketuk lingkaran untuk menghitung',
                style: TextStyle(color: Colors.grey, fontSize: 13),
              ),

              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
