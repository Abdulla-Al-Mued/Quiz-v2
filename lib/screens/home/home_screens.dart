import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz/screens/home/widgets/home_widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _scaleController;

  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.elasticOut,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.bounceOut,
    ));


    _fadeController.forward();
    Future.delayed(const Duration(milliseconds: 200), () {
      _slideController.forward();
    });
    Future.delayed(const Duration(milliseconds: 400), () {
      _scaleController.forward();
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.primaryColor.withOpacity(0.05),
              Colors.purple.shade50.withOpacity(0.3),
              Colors.blue.shade50.withOpacity(0.2),
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: AnimatedBuilder(
            animation: _fadeAnimation,
            builder: (context, child) {
              return Opacity(
                opacity: _fadeAnimation.value,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    children: [
                      // Top spacing
                      SizedBox(height: size.height * 0.08),

                      // Animated header section
                      SlideTransition(
                        position: _slideAnimation,
                        child: _buildHeaderSection(context),
                      ),

                      const Spacer(),

                      // Animated buttons section
                      ScaleTransition(
                        scale: _scaleAnimation,
                        child: _buildButtonsSection(context),
                      ),

                      SizedBox(height: size.height * 0.06),

                      // Bottom stats section
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: buildStatsSection(context),
                      ),

                      SizedBox(height: size.height * 0.04),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [

        Container(
          width: 140,
          height: 140,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withOpacity(0.2),
                Colors.white.withOpacity(0.05),
              ],
            ),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: theme.primaryColor.withOpacity(0.1),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Icon(
            Icons.psychology,
            size: 70,
            color: theme.primaryColor,
          ),
        ),

        const SizedBox(height: 32),


        ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
            colors: [
              theme.primaryColor,
              Colors.purple.shade400,
            ],
          ).createShader(bounds),
          child: Text(
            'Quiz Master',
            style: theme.textTheme.headlineLarge?.copyWith(
              fontWeight: FontWeight.w800,
              fontSize: 36,
              color: Colors.white,
              letterSpacing: -0.5,
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Subtitle
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'Challenge your mind with engaging math and science questions',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.6),
              fontSize: 16,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildButtonsSection(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        // Start Quiz Button - Primary Action
        ModernButton(
          onPressed: () => Get.toNamed('/quiz'),
          icon: Icons.play_arrow,
          label: 'Start Quiz',
          isPrimary: true,
          gradient: LinearGradient(
            colors: [
              theme.primaryColor,
              Colors.purple.shade400,
            ],
          ),
        ),

        const SizedBox(height: 16),


        Row(
          children: [
            Expanded(
              child: ModernButton(
                onPressed: () => Get.toNamed('/leaderboard'),
                icon: Icons.leaderboard,
                label: 'Leaderboard',
                isPrimary: false,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ModernButton(
                onPressed: () {
                  // Add settings navigation
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Settings coming soon!')),
                  );
                },
                icon: Icons.settings,
                label: 'Settings',
                isPrimary: false,
              ),
            ),
          ],
        ),
      ],
    );
  }
}