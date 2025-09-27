import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';

class SkillsSection extends ConsumerStatefulWidget {
  const SkillsSection({super.key});

  @override
  ConsumerState<SkillsSection> createState() => _SkillsSectionState();
}

class _SkillsSectionState extends ConsumerState<SkillsSection>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final GlobalKey _sectionKey = GlobalKey();

  final List<SkillData> _skills = [
    SkillData('Flutter', Icons.flutter_dash, const Color(0xFF02569B)),
    SkillData('Dart', Icons.code, const Color(0xFF0175C2)),
    SkillData('JavaScript', Icons.javascript, const Color(0xFFF7DF1E)),
    SkillData('React', Icons.web, const Color(0xFF61DAFB)),
    SkillData('Node.js', Icons.storage, const Color(0xFF339933)),
    SkillData('Python', Icons.terminal, const Color(0xFF3776AB)),
    SkillData('Firebase', Icons.cloud, const Color(0xFFFFCA28)),
    SkillData('HTML/CSS', Icons.language, const Color(0xFFE34F26)),
    SkillData('TypeScript', Icons.code, const Color(0xFF3178C6)),
    SkillData('MongoDB', Icons.storage, const Color(0xFF47A248)),
    SkillData('GitHub', Icons.code, Colors.white),
    SkillData(
      'Express',
      Icons.storage,
      const Color.fromARGB(255, 133, 234, 45),
    ),
    SkillData('REST APIs', Icons.http, const Color.fromARGB(255, 55, 30, 240)),
  ];

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

    // Start animation immediately
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;
    final isTablet = screenWidth >= 768 && screenWidth < 1024;

    // Better responsive grid calculation
    int crossAxisCount;
    if (isMobile) {
      crossAxisCount = 2; // 2 columns for mobile
    } else if (isTablet) {
      crossAxisCount = 3; // 3 columns for tablet
    } else {
      crossAxisCount = 4; // 4 columns for desktop
    }

    return Container(
      key: _sectionKey,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile
            ? 16
            : isTablet
            ? 32
            : 64,
        vertical: 60,
      ),
      child: SlideTransition(
        position: _slideAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            children: [
              // Simplified title
              Text(
                'My Skills',
                style: TextStyle(
                  fontSize: isMobile
                      ? 28
                      : isTablet
                      ? 36
                      : 42,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 40),
              // Skills grid with better responsive layout
              LayoutBuilder(
                builder: (context, constraints) {
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: isMobile ? 10 : 15,
                      mainAxisSpacing: isMobile ? 10 : 15,
                      childAspectRatio: isMobile ? 1.0 : 1.1,
                    ),
                    itemCount: _skills.length,
                    itemBuilder: (context, index) {
                      return _SkillCard(
                        skill: _skills[index],
                        index: index,
                        isMobile: isMobile,
                        isTablet: isTablet,
                        controller: _controller,
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Separate widget to prevent unnecessary rebuilds
class _SkillCard extends StatefulWidget {
  const _SkillCard({
    required this.skill,
    required this.index,
    required this.isMobile,
    required this.isTablet,
    required this.controller,
  });

  final SkillData skill;
  final int index;
  final bool isMobile;
  final bool isTablet;
  final AnimationController controller;

  @override
  State<_SkillCard> createState() => _SkillCardState();
}

class _SkillCardState extends State<_SkillCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, child) {
        final animation = Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: widget.controller,
            curve: Interval(
              widget.index * 0.08,
              0.5 + (widget.index * 0.08),
              curve: Curves.easeOut,
            ),
          ),
        );

        return Transform.scale(
          scale: 0.8 + (0.2 * animation.value),
          child: Opacity(
            opacity: animation.value,
            child: MouseRegion(
              onEnter: (_) => setState(() => _isHovered = true),
              onExit: (_) => setState(() => _isHovered = false),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                transform: Matrix4.identity()..scale(_isHovered ? 1.05 : 1.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    widget.isMobile ? 16 : 20,
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      widget.skill.color.withOpacity(0.1),
                      widget.skill.color.withOpacity(0.2),
                      widget.skill.color.withOpacity(0.05),
                    ],
                  ),
                  border: Border.all(
                    color: widget.skill.color.withOpacity(
                      _isHovered ? 0.6 : 0.3,
                    ),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: widget.skill.color.withOpacity(
                        _isHovered ? 0.3 : 0.1,
                      ),
                      blurRadius: _isHovered ? 15 : 8,
                      spreadRadius: _isHovered ? 2 : 1,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.all(widget.isMobile ? 8 : 12),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Skill icon with colored background
                      Container(
                        padding: EdgeInsets.all(widget.isMobile ? 8 : 10),
                        decoration: BoxDecoration(
                          color: widget.skill.color.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(
                            widget.isMobile ? 12 : 15,
                          ),
                          border: Border.all(
                            color: widget.skill.color.withOpacity(0.3),
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: widget.skill.color.withOpacity(0.2),
                              blurRadius: 6,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        child: Icon(
                          widget.skill.icon,
                          size: widget.isMobile
                              ? 18
                              : widget.isTablet
                              ? 20
                              : 24,
                          color: widget.skill.color,
                        ),
                      ),
                      SizedBox(height: widget.isMobile ? 6 : 10),
                      // Skill name - always visible
                      Text(
                        widget.skill.name,
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: widget.isMobile
                              ? 10
                              : widget.isTablet
                              ? 12
                              : 14,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: widget.isMobile ? 4 : 6),
                      // Colored accent bar - always visible
                      Container(
                        height: 2,
                        width: widget.isMobile ? 20 : 30,
                        decoration: BoxDecoration(
                          color: widget.skill.color,
                          borderRadius: BorderRadius.circular(1),
                          boxShadow: [
                            BoxShadow(
                              color: widget.skill.color.withOpacity(0.4),
                              blurRadius: 3,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class SkillData {
  final String name;
  final IconData icon;
  final Color color;

  SkillData(this.name, this.icon, this.color);
}
