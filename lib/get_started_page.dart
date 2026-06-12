import 'package:flutter/material.dart';
import 'onboarding_page.dart';

class GetStartedPage extends StatelessWidget {
  const GetStartedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF3F2B96), Color(0xFF241468)],
          ),
        ),
        child: Stack(
          children: [
            // Decorative background elements
            Positioned(top: 40, left: 20, child: _buildDotPattern(4, 5)),
            Positioned(top: -50, right: -50, child: _buildCircularPattern(250)),
            Positioned(bottom: 120, left: 20, child: _buildWavePattern()),
            Positioned(bottom: 40, right: 20, child: _buildDotPattern(3, 4)),
            
            SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(minHeight: constraints.maxHeight),
                      child: IntrinsicHeight(
                        child: Column(
                          children: [
                            const SizedBox(height: 50),
                            // App Logo Section
                            _buildAppLogo(),
                            const SizedBox(height: 24),
                            RichText(
                              text: TextSpan(
                                style: const TextStyle(
                                  fontSize: 44,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.0,
                                ),
                                children: [
                                  const TextSpan(
                                    text: 'Cari',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  TextSpan(
                                    text: 'Intern',
                                    style: TextStyle(color: Colors.purple.shade200),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 12),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 40.0),
                              child: Text(
                                'Real reviews. Real experiences.\nBetter internship decisions.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 16,
                                  height: 1.4,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                            const Spacer(),
                            
                            // Dynamic Hero Section
                            _buildHeroSection(),
                            
                            const Spacer(),
                            
                            // Get Started Button
                            _buildGetStartedButton(context),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppLogo() {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: const Icon(Icons.search, color: Colors.white, size: 45),
    );
  }

  Widget _buildHeroSection() {
    return SizedBox(
      height: 320,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Glowing background core
          Container(
            width: 180,
            height: 180,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withValues(alpha: 0.05),
                  blurRadius: 60,
                  spreadRadius: 20,
                ),
              ],
            ),
          ),
          // Center Rocket Icon
          Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
            ),
            child: const Icon(
              Icons.rocket_launch_rounded,
              color: Colors.white,
              size: 50,
            ),
          ),
          // Floating Stats Card 1: Reviews
          _buildFloatingCard(
            icon: Icons.star_rounded,
            color: Colors.amber,
            label: "4.8/5",
            subLabel: "Student Reviews",
            alignment: const Alignment(-0.7, -0.6),
          ),
          // Floating Stats Card 2: Companies
          _buildFloatingCard(
            icon: Icons.business_rounded,
            color: Colors.blueAccent,
            label: "500+",
            subLabel: "Top Companies",
            alignment: const Alignment(0.8, -0.1),
          ),
          // Floating Stats Card 3: Opportunities
          _buildFloatingCard(
            icon: Icons.auto_awesome,
            color: Colors.greenAccent,
            label: "10k+",
            subLabel: "Opportunities",
            alignment: const Alignment(-0.5, 0.7),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingCard({
    required IconData icon,
    required Color color,
    required String label,
    required String subLabel,
    required Alignment alignment,
  }) {
    return Align(
      alignment: alignment,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 8),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                ),
                Text(
                  subLabel,
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 10),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGetStartedButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
      child: SizedBox(
        width: double.infinity,
        height: 58,
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const OnboardingPage()),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: const Color(0xFF241468),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 0,
          ),
          child: const Text(
            'Get Started', 
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
          ),
        ),
      ),
    );
  }

  Widget _buildDotPattern(int rows, int cols) {
    return Column(
      children: List.generate(rows, (i) => Row(
          children: List.generate(cols, (j) => Container(
              margin: const EdgeInsets.all(4),
              width: 3,
              height: 3,
              decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), shape: BoxShape.circle),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCircularPattern(double size) {
    return Opacity(
      opacity: 0.1,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 1.5),
        ),
      ),
    );
  }

  Widget _buildWavePattern() {
    return Opacity(
      opacity: 0.2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(3, (i) => Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              children: List.generate(6, (j) => Container(
                  width: 8,
                  height: 2,
                  margin: const EdgeInsets.symmetric(horizontal: 1),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(1)),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
