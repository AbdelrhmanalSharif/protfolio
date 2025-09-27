import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:protfolio/core/theme/images_pre.dart';
import 'dart:html' as html;
import '../../../core/theme/app_colors.dart';
import '../../../core/providers/portfolio_providers.dart';

class HeroSection extends ConsumerStatefulWidget {
  const HeroSection({super.key});

  @override
  ConsumerState<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends ConsumerState<HeroSection>
    with TickerProviderStateMixin {
  late AnimationController _mainController;
  late AnimationController _profileController;
  late AnimationController _socialController;

  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _profileScaleAnimation;
  late Animation<double> _profileRotateAnimation;
  late Animation<double> _socialFadeAnimation;
  late Animation<Offset> _socialSlideAnimation;

  @override
  void initState() {
    super.initState();

    _mainController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _profileController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _socialController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _mainController, curve: Curves.easeInOut),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
          CurvedAnimation(parent: _mainController, curve: Curves.easeOutCubic),
        );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _mainController, curve: Curves.elasticOut),
    );

    _profileScaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _profileController, curve: Curves.elasticOut),
    );

    _profileRotateAnimation = Tween<double>(begin: -0.1, end: 0.0).animate(
      CurvedAnimation(parent: _profileController, curve: Curves.easeOutBack),
    );

    _socialFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _socialController, curve: Curves.easeInOut),
    );

    _socialSlideAnimation =
        Tween<Offset>(begin: const Offset(-0.5, 0), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _socialController,
            curve: Curves.easeOutCubic,
          ),
        );

    // Start animations with delays
    _profileController.forward();
    Future.delayed(const Duration(milliseconds: 500), () {
      _mainController.forward();
    });
    Future.delayed(const Duration(milliseconds: 1200), () {
      _socialController.forward();
    });
  }

  @override
  void dispose() {
    _mainController.dispose();
    _profileController.dispose();
    _socialController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final personalInfo = ref.watch(personalInfoProvider);
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;
    final isTablet = screenWidth >= 768 && screenWidth < 1024;

    return Container(
      height: MediaQuery.of(context).size.height,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: AppColors.heroGradient,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: isMobile
              ? 16
              : isTablet
              ? 32
              : 64,
        ),
        child: isMobile
            ? _buildMobileLayout(personalInfo)
            : _buildDesktopLayout(personalInfo),
      ),
    );
  }

  Widget _buildDesktopLayout(personalInfo) {
    return Row(
      children: [
        // Left side - Animated Profile image
        Expanded(flex: 1, child: _buildAnimatedProfile()),
        // Right side - Animated Text content
        Expanded(flex: 1, child: _buildAnimatedContent(personalInfo)),
      ],
    );
  }

  Widget _buildMobileLayout(personalInfo) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 50),
          SizedBox(height: 300, child: _buildAnimatedProfile()),
          const SizedBox(height: 40),
          _buildAnimatedContent(personalInfo, isMobile: true),
          const SizedBox(height: 50),
        ],
      ),
    );
  }

  Widget _buildAnimatedProfile() {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;
    final profileSize = isMobile ? 250.0 : 400.0;
    final iconSize = isMobile ? 300.0 : 350.0;

    return AnimatedBuilder(
      animation: _profileController,
      builder: (context, child) {
        return Transform.scale(
          scale: _profileScaleAnimation.value,
          child: Transform.rotate(
            angle: _profileRotateAnimation.value,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Animated red circle background
                TweenAnimationBuilder<double>(
                  duration: const Duration(milliseconds: 1500),
                  tween: Tween(begin: 0.0, end: 1.0),
                  builder: (context, value, child) {
                    return Container(
                      width: profileSize * value,
                      height: profileSize * value,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1 + 0.9 * value),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.3 * value),
                            blurRadius: 30 * value,
                            spreadRadius: 10 * value,
                          ),
                        ],
                      ),
                    );
                  },
                ),
                // Profile silhouette with pulse animation
                TweenAnimationBuilder<double>(
                  duration: const Duration(seconds: 2),
                  tween: Tween(begin: 0.95, end: 1.05),
                  builder: (context, scale, child) {
                    return Transform.scale(
                      scale: scale,
                      child: Container(
                        width: iconSize,
                        height: iconSize,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.8),
                          shape: BoxShape.circle,
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            ImagesPre.logo,
                            width: isMobile ? 120 : 200,
                            height: isMobile ? 120 : 200,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnimatedContent(personalInfo, {bool isMobile = false}) {
    return Padding(
      padding: EdgeInsets.only(left: isMobile ? 0 : 80),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: isMobile
            ? CrossAxisAlignment.center
            : CrossAxisAlignment.start,
        children: [
          // Animated main title
          SlideTransition(
            position: _slideAnimation,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: RichText(
                  textAlign: isMobile ? TextAlign.center : TextAlign.left,
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: isMobile ? 32 : 64,
                      fontWeight: FontWeight.bold,
                      height: 1.1,
                    ),
                    children: [
                      const TextSpan(
                        text: 'Hi, It\'s ',
                        style: TextStyle(color: AppColors.textPrimary),
                      ),
                      TextSpan(
                        text: personalInfo.name,
                        style: const TextStyle(color: AppColors.primary),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Animated subtitle with delay
          AnimatedBuilder(
            animation: _mainController,
            builder: (context, child) {
              return SlideTransition(
                position:
                    Tween<Offset>(
                      begin: const Offset(0, 0.3),
                      end: Offset.zero,
                    ).animate(
                      CurvedAnimation(
                        parent: _mainController,
                        curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
                      ),
                    ),
                child: FadeTransition(
                  opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
                    CurvedAnimation(
                      parent: _mainController,
                      curve: const Interval(0.3, 1.0),
                    ),
                  ),
                  child: RichText(
                    textAlign: isMobile ? TextAlign.center : TextAlign.left,
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: isMobile ? 20 : 32,
                        fontWeight: FontWeight.w500,
                      ),
                      children: [
                        const TextSpan(
                          text: 'I\'m a ',
                          style: TextStyle(color: AppColors.textPrimary),
                        ),
                        TextSpan(
                          text: personalInfo.title,
                          style: const TextStyle(color: AppColors.primaryLight),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 32),
          // Animated description
          AnimatedBuilder(
            animation: _mainController,
            builder: (context, child) {
              return SlideTransition(
                position:
                    Tween<Offset>(
                      begin: const Offset(0, 0.2),
                      end: Offset.zero,
                    ).animate(
                      CurvedAnimation(
                        parent: _mainController,
                        curve: const Interval(0.5, 1.0, curve: Curves.easeOut),
                      ),
                    ),
                child: FadeTransition(
                  opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
                    CurvedAnimation(
                      parent: _mainController,
                      curve: const Interval(0.5, 1.0),
                    ),
                  ),
                  child: SizedBox(
                    width: isMobile ? double.infinity : 400,
                    child: Text(
                      personalInfo.description,
                      textAlign: isMobile ? TextAlign.center : TextAlign.left,
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.textPrimaryWithOpacity(0.7),
                        height: 1.6,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 32),
          // Animated social media icons
          SlideTransition(
            position: _socialSlideAnimation,
            child: FadeTransition(
              opacity: _socialFadeAnimation,
              child: Wrap(
                alignment: isMobile
                    ? WrapAlignment.center
                    : WrapAlignment.start,
                children: [
                  _buildAnimatedSocialIcon(Icons.flutter_dash, 0),
                  const SizedBox(width: 16),
                  _buildAnimatedSocialIcon(Icons.web, 1),
                  const SizedBox(width: 16),
                  _buildAnimatedSocialIcon(Icons.mode_comment_outlined, 2),
                  const SizedBox(width: 16),
                  _buildAnimatedSocialIcon(Icons.mobile_friendly, 3),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),
          // Animated hire me button
          AnimatedBuilder(
            animation: _socialController,
            builder: (context, child) {
              return SlideTransition(
                position:
                    Tween<Offset>(
                      begin: const Offset(0, 0.3),
                      end: Offset.zero,
                    ).animate(
                      CurvedAnimation(
                        parent: _socialController,
                        curve: const Interval(0.5, 1.0, curve: Curves.easeOut),
                      ),
                    ),
                child: FadeTransition(
                  opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
                    CurvedAnimation(
                      parent: _socialController,
                      curve: const Interval(0.5, 1.0),
                    ),
                  ),
                  child: _buildAnimatedHireButton(personalInfo),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedSocialIcon(IconData icon, int index) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 800 + (index * 100)),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: MouseRegion(
            onEnter: (_) {},
            onExit: (_) {},
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppColors.textPrimaryWithOpacity(0.3),
                ),
                borderRadius: BorderRadius.circular(50),
              ),
              child: Icon(
                icon,
                size: 20,
                color: AppColors.textPrimaryWithOpacity(0.7),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnimatedHireButton(dynamic personalInfo) {
    bool isHovering = false;

    return StatefulBuilder(
      builder: (context, setState) {
        return MouseRegion(
          onEnter: (_) => setState(() => isHovering = true),
          onExit: (_) => setState(() => isHovering = false),
          child: InkWell(
            onTap: () {
              try {
                const String url = 'https://github.com/AbdelrhmanalSharif';
                html.window.open(url, '_blank');
              } catch (e) {
                debugPrint('Error opening URL: $e');
              }
            },
            borderRadius: BorderRadius.circular(30),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              decoration: BoxDecoration(
                color: isHovering
                    ? AppColors.primary.withOpacity(0.1)
                    : Colors.transparent,
                border: Border.all(color: AppColors.primary),
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Text(
                'Check my GitHub',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
