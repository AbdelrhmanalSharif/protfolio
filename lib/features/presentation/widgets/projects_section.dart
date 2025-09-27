import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:protfolio/core/theme/images_pre.dart';
import '../../../core/theme/app_colors.dart';

class ProjectsSection extends ConsumerStatefulWidget {
  const ProjectsSection({super.key});

  @override
  ConsumerState<ProjectsSection> createState() => _ProjectsSectionState();
}

class _ProjectsSectionState extends ConsumerState<ProjectsSection>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _hoverController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final GlobalKey _sectionKey = GlobalKey();
  bool _isVisible = false;
  ScrollController? _scrollController;
  int _hoveredCardIndex = -1;

  final List<ProjectData> _projects = [
    ProjectData(
      'E-commerce App',
      'A complete shopping app with payment integration',
      ['ReactTs', 'JSON', 'Supabase', 'UI/UX'],
      Icons.mobile_friendly,
      ImagesPre.project4,
    ),
    ProjectData(
      'Weather App',
      'Real-time weather updates with beautiful animations',
      ['Flutter', 'REST API', 'Animation', 'Dart'],
      Icons.mobile_friendly,
      ImagesPre.project6,
    ),
    ProjectData(
      'Event Software Page',
      'Productivity app with event tracking and reminders',
      ['Flutter', 'Local Storage', 'Notifications', 'MongoDB'],
      Icons.mobile_friendly,
      ImagesPre.project1,
    ),
    ProjectData(
      'Crypto Analytics Dashboard',
      'Real-time cryptocurrency data and analytics',
      ['Flutter', 'API', 'Charts', 'WebSockets'],
      Icons.mobile_friendly,
      ImagesPre.project2,
    ),
    ProjectData(
      'Personal Portfolio',
      'A personal portfolio website to showcase my projects',
      ['ReactTs', 'Animations', 'Responsive UI', 'TailwindCSS'],
      Icons.web,
      ImagesPre.project3,
    ),
    ProjectData(
      'Blog Platform',
      'A full-featured blogging platform with user authentication',
      ['Flutter', 'Firebase', 'Authentication', 'Cloud Storage'],
      Icons.mobile_friendly,
      ImagesPre.project7,
    ),
    ProjectData(
      'Protfoilio App',
      'A complete shopping app with payment integration',
      ['Flutter', 'Firebase', 'Stripe', 'UI/UX'],
      Icons.mobile_friendly,
      ImagesPre.project5,
    ),
  ];

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 200),
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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setupScrollListener();
    });
  }

  void _setupScrollListener() {
    final scrollController = Scrollable.of(context).widget.controller;
    if (scrollController != null) {
      _scrollController = scrollController;
      _scrollController!.addListener(_checkVisibility);
    }
  }

  void _checkVisibility() {
    if (_sectionKey.currentContext != null && !_isVisible) {
      final RenderBox renderBox =
          _sectionKey.currentContext!.findRenderObject() as RenderBox;
      final position = renderBox.localToGlobal(Offset.zero);
      final screenHeight = MediaQuery.of(context).size.height;

      final isCurrentlyVisible =
          position.dy < screenHeight * 0.8 &&
          position.dy > -renderBox.size.height * 0.5;

      if (isCurrentlyVisible) {
        setState(() => _isVisible = true);
        _controller.forward();
        _scrollController?.removeListener(_checkVisibility);
      }
    }
  }

  @override
  void dispose() {
    _scrollController?.removeListener(_checkVisibility);
    _controller.dispose();
    _hoverController.dispose();
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
      child: SlideTransition(
        position: _slideAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            children: [
              // Section title
              AnimatedOpacity(
                duration: const Duration(milliseconds: 600),
                opacity: _isVisible ? 1.0 : 0.0,
                child: Text(
                  'My Projects',
                  style: TextStyle(
                    fontSize: isMobile ? 32 : 48,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              const SizedBox(height: 50),

              // Projects grid
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: isMobile ? 1 : 2,
                  crossAxisSpacing: 20, // Reduced spacing
                  mainAxisSpacing: 20, // Reduced spacing
                  childAspectRatio: isMobile
                      ? 0.9
                      : 1.2, // Adjusted aspect ratio for smaller cards
                ),
                itemCount: _projects.length,
                itemBuilder: (context, index) {
                  return _ProjectCard(
                    project: _projects[index],
                    index: index,
                    isMobile: isMobile,
                    isVisible: _isVisible,
                    controller: _controller,
                    onHover: (isHovered) => _onCardHover(index, isHovered),
                    isHovered: _hoveredCardIndex == index,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onCardHover(int index, bool isHovered) {
    if (mounted) {
      setState(() {
        _hoveredCardIndex = isHovered ? index : -1;
      });
    }
  }
}

class _ProjectCard extends StatelessWidget {
  const _ProjectCard({
    required this.project,
    required this.index,
    required this.isMobile,
    required this.isVisible,
    required this.controller,
    required this.onHover,
    required this.isHovered,
  });

  final ProjectData project;
  final int index;
  final bool isMobile;
  final bool isVisible;
  final AnimationController controller;
  final Function(bool) onHover;
  final bool isHovered;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final animation = Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(
              0.1 + (index * 0.1),
              0.6 + (index * 0.1),
              curve: Curves.easeOut,
            ),
          ),
        );

        return Transform.scale(
          scale: 0.8 + (0.2 * animation.value),
          child: Opacity(
            opacity: animation.value,
            child: MouseRegion(
              onEnter: (_) => onHover(true),
              onExit: (_) => onHover(false),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                transform: Matrix4.identity()..scale(isHovered ? 1.02 : 1.0),
                decoration: BoxDecoration(
                  color: AppColors.backgroundSecondary,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppColors.primary.withOpacity(isHovered ? 0.6 : 0.3),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(
                        isHovered ? 0.2 : 0.05,
                      ),
                      blurRadius: isHovered ? 20 : 10,
                      spreadRadius: isHovered ? 2 : 1,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Image area - 50% of card height
                    Expanded(
                      flex: 50, // 50% of the card
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(18),
                          topRight: Radius.circular(18),
                        ),
                        child: Container(
                          color: AppColors.primary.withOpacity(0.1),
                          child: project.imageUrl != null
                              ? Image.asset(
                                  project.imageUrl!,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity,
                                )
                              : Center(
                                  child: Icon(
                                    project.icon,
                                    size:
                                        50, // Increased icon size for larger area
                                    color: AppColors.primary,
                                  ),
                                ),
                        ),
                      ),
                    ),

                    // Content area - 50% of card height
                    Expanded(
                      flex: 50, // 50% of the card
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Title
                            Text(
                              project.title,
                              style: const TextStyle(
                                fontSize: 16, // Slightly smaller to fit content
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 6),

                            // Description
                            Expanded(
                              child: Text(
                                project.description,
                                style: TextStyle(
                                  fontSize: 12, // Smaller font
                                  color: AppColors.textPrimaryWithOpacity(0.8),
                                  height: 1.3,
                                ),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),

                            const SizedBox(height: 8),

                            // Tech stack tags
                            Wrap(
                              spacing: 4,
                              runSpacing: 4,
                              children: project.technologies.take(3).map((
                                tech,
                              ) {
                                // Limit to 3 tags
                                return Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: AppColors.primary.withOpacity(0.3),
                                      width: 1,
                                    ),
                                  ),
                                  child: Text(
                                    tech,
                                    style: const TextStyle(
                                      fontSize: 10,
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),

                            const SizedBox(height: 8),

                            // Action buttons
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {},
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.primary,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 8,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: const Text(
                                      'View',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  decoration: BoxDecoration(
                                    color: AppColors.backgroundSecondary,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: AppColors.primary.withOpacity(0.3),
                                      width: 1,
                                    ),
                                  ),
                                  child: IconButton(
                                    onPressed: () {},
                                    padding: const EdgeInsets.all(6),
                                    icon: const Icon(
                                      Icons.code,
                                      color: AppColors.primary,
                                      size: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class ProjectData {
  final String title;
  final String description;
  final List<String> technologies;
  final IconData icon;
  final String? imageUrl;

  ProjectData(
    this.title,
    this.description,
    this.technologies,
    this.icon, [
    this.imageUrl,
  ]);
}
