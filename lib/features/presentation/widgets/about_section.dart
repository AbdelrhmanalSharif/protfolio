import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import 'dart:async';
import 'dart:math' as math;

class AboutSection extends ConsumerStatefulWidget {
  const AboutSection({super.key});

  @override
  ConsumerState<AboutSection> createState() => _AboutSectionState();
}

class _AboutSectionState extends ConsumerState<AboutSection>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // Add missing controllers for animations
  late AnimationController _continuousController;
  late AnimationController _waveController;
  late AnimationController _particlesController;

  final GlobalKey _sectionKey = GlobalKey();

  String _displayText = '';
  final List<String> _jobTitles = [
    'Flutter Developer',
    'Frontend Developer',
    'Mobile Developer',
    'UI/UX Designer',
  ];
  int _currentTitleIndex = 0;
  int _currentIndex = 0;
  bool _isDeleting = false;
  Timer? _typewriterTimer;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    // Initialize the continuous animations controllers
    _continuousController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat();

    _waveController = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    )..repeat();

    _particlesController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();

    // Start animation immediately
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.forward();
      Future.delayed(const Duration(milliseconds: 800), () {
        _startTypewriterEffect();
      });
    });
  }

  void _startTypewriterEffect() {
    if (!mounted) return;

    _typewriterTimer = Timer.periodic(const Duration(milliseconds: 150), (
      timer,
    ) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      setState(() {
        final currentTitle = _jobTitles[_currentTitleIndex];

        if (!_isDeleting) {
          // Typing forward
          if (_currentIndex < currentTitle.length) {
            _currentIndex++;
            _displayText = currentTitle.substring(0, _currentIndex);
          } else {
            // Finished typing, wait then start deleting
            timer.cancel();
            Future.delayed(const Duration(milliseconds: 2000), () {
              if (mounted) {
                _isDeleting = true;
                _startTypewriterEffect();
              }
            });
          }
        } else {
          // Deleting text
          if (_currentIndex > 0) {
            _currentIndex--;
            _displayText = _jobTitles[_currentTitleIndex].substring(
              0,
              _currentIndex,
            );
          } else {
            // Finished deleting, move to next title
            _isDeleting = false;
            _currentTitleIndex = (_currentTitleIndex + 1) % _jobTitles.length;
            timer.cancel();
            Future.delayed(const Duration(milliseconds: 500), () {
              if (mounted) {
                _startTypewriterEffect();
              }
            });
          }
        }
      });
    });
  }

  @override
  void dispose() {
    _typewriterTimer?.cancel();
    _controller.dispose();
    _continuousController.dispose();
    _waveController.dispose();
    _particlesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;

    return Container(
      key: _sectionKey,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 16 : 64,
        vertical: 80,
      ),
      child: Stack(
        children: [
          _buildBackgroundAnimations(),
          _buildFloatingParticles(),
          _buildWaveAnimation(),

          SlideTransition(
            position: _slideAnimation,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Column(
                children: [
                  // Title - always visible
                  Text(
                    'About Me',
                    style: TextStyle(
                      fontSize: isMobile ? 32 : 48,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Typewriter effect section
                  Container(
                    height: 80,
                    alignment: Alignment.center,
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        // First row - 3 elements
                        AnimatedBuilder(
                          animation: _continuousController,
                          builder: (context, child) {
                            return Transform.translate(
                              offset: Offset(
                                0,
                                math.sin(
                                      _continuousController.value * 2 * math.pi,
                                    ) *
                                    2,
                              ),
                              child: Text(
                                'I am a ',
                                style: TextStyle(
                                  fontSize: isMobile ? 18 : 24,
                                  color: AppColors.textPrimaryWithOpacity(0.8),
                                ),
                              ),
                            );
                          },
                        ),
                        Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withOpacity(0.5),
                                blurRadius: 10,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: Text(
                            'passionate ',
                            style: TextStyle(
                              fontSize: isMobile ? 18 : 24,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                        Container(
                          constraints: BoxConstraints(
                            minWidth: isMobile ? 120 : 200,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Flexible(
                                child: Text(
                                  _displayText,
                                  style: TextStyle(
                                    fontSize: isMobile ? 18 : 24,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                              // Enhanced blinking cursor
                              AnimatedBuilder(
                                animation: _continuousController,
                                builder: (context, child) {
                                  final isBlinking =
                                      _isDeleting || _displayText.isNotEmpty;
                                  return AnimatedOpacity(
                                    duration: const Duration(milliseconds: 300),
                                    opacity: isBlinking
                                        ? (math.sin(
                                                    _continuousController
                                                            .value *
                                                        6 *
                                                        math.pi,
                                                  ) *
                                                  0.5 +
                                              0.5)
                                        : 1.0,
                                    child: Container(
                                      width: 3,
                                      height: isMobile ? 18 : 24,
                                      margin: const EdgeInsets.only(left: 2),
                                      decoration: BoxDecoration(
                                        color: AppColors.primary,
                                        boxShadow: [
                                          BoxShadow(
                                            color: AppColors.primary
                                                .withOpacity(0.8),
                                            blurRadius: 8,
                                            spreadRadius: 1,
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Enhanced description with wave effect
                  AnimatedBuilder(
                    animation: _waveController,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(
                          0,
                          math.sin(_waveController.value * 2 * math.pi) * 3,
                        ),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 1000),
                          curve: Curves.easeInOut,
                          constraints: BoxConstraints(
                            maxWidth: isMobile ? double.infinity : 800,
                          ),
                          child: Text(
                            'with expertise in creating beautiful and functional mobile applications using Flutter framework.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: isMobile ? 16 : 18,
                              height: 1.6,
                              color: AppColors.textPrimaryWithOpacity(0.8),
                            ),
                          ),
                        ),
                      );
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

  Widget _buildBackgroundAnimations() {
    return Positioned.fill(
      child: AnimatedBuilder(
        animation: _continuousController,
        builder: (context, child) {
          return CustomPaint(
            painter: BackgroundAnimationPainter(_continuousController.value),
          );
        },
      ),
    );
  }

  Widget _buildFloatingParticles() {
    return Positioned.fill(
      child: AnimatedBuilder(
        animation: _particlesController,
        builder: (context, child) {
          return CustomPaint(
            painter: ParticlesPainter(_particlesController.value),
          );
        },
      ),
    );
  }

  Widget _buildWaveAnimation() {
    return Positioned.fill(
      child: AnimatedBuilder(
        animation: _waveController,
        builder: (context, child) {
          return CustomPaint(painter: WavePainter(_waveController.value));
        },
      ),
    );
  }
}

// Custom painters for ambient animations
class BackgroundAnimationPainter extends CustomPainter {
  final double animationValue;

  BackgroundAnimationPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primary.withOpacity(0.05)
      ..style = PaintingStyle.fill;

    // Draw pulsing circles
    for (int i = 0; i < 3; i++) {
      final radius = 50 + (math.sin(animationValue * 2 * math.pi + i) * 20);
      final offset = Offset(
        size.width * (0.2 + i * 0.3),
        size.height * (0.3 + math.sin(animationValue * math.pi + i) * 0.2),
      );

      canvas.drawCircle(offset, radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class ParticlesPainter extends CustomPainter {
  final double animationValue;

  ParticlesPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primaryLight.withOpacity(0.3)
      ..style = PaintingStyle.fill;

    // Draw floating particles
    for (int i = 0; i < 8; i++) {
      final x =
          (size.width * (i / 8) +
              math.sin(animationValue * 2 * math.pi + i) * 30) %
          size.width;
      final y =
          (size.height * 0.5 + math.cos(animationValue * math.pi + i) * 100) %
          size.height;
      final radius = 2 + math.sin(animationValue * 4 * math.pi + i) * 1;

      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class WavePainter extends CustomPainter {
  final double animationValue;

  WavePainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primary.withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final path = Path();
    path.moveTo(0, size.height * 0.5);

    for (double x = 0; x <= size.width; x += 10) {
      final y =
          size.height * 0.5 +
          math.sin(
                (x / size.width) * 4 * math.pi + animationValue * 2 * math.pi,
              ) *
              30;
      path.lineTo(x, y);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
