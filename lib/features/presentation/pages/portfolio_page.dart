import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/providers/portfolio_providers.dart';
import '../widgets/hero_section.dart';
import '../widgets/about_section.dart';
import '../widgets/skills_section.dart';
import '../widgets/projects_section.dart';
import '../widgets/contact_section.dart';

class PortfolioPage extends ConsumerStatefulWidget {
  const PortfolioPage({super.key});

  @override
  ConsumerState<PortfolioPage> createState() => _PortfolioPageState();
}

class _PortfolioPageState extends ConsumerState<PortfolioPage>
    with TickerProviderStateMixin {
  late AnimationController _sectionsController;
  final List<GlobalKey> sectionKeys = List.generate(5, (index) => GlobalKey());

  @override
  void initState() {
    super.initState();
    _sectionsController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          _sectionsController.forward();
        }
      });
    });
  }

  @override
  void dispose() {
    _sectionsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final personalInfo = "FireCore Protfolio";
    final scrollController = ref.watch(scrollControllerProvider);
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;

    return Scaffold(
      appBar: isMobile ? null : _buildAppBar(personalInfo),
      drawer: isMobile ? _buildMobileDrawer() : null,
      body: SingleChildScrollView(
        controller: scrollController,
        physics: const ClampingScrollPhysics(), // Better for web
        child: Column(
          children: [
            const HeroSection(),
            _buildAnimatedSection(const AboutSection(), 0),
            _buildAnimatedSection(const SkillsSection(), 1),
            _buildAnimatedSection(const ProjectsSection(), 2),
            _buildAnimatedSection(const ContactSection(), 3),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(String name) {
    return AppBar(
      title: Text(
        name,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 24,
          color: AppColors.textPrimary,
        ),
      ),
      backgroundColor: AppColors.backgroundPrimary,
      elevation: 0,
      actions: const [
        _NavButton(text: 'Home', offset: 0),
        _NavButton(text: 'About Me', offset: 600),
        _NavButton(text: 'Skills', offset: 800),
        _NavButton(text: 'Projects', offset: 2200),
        _NavButton(text: 'Contact', offset: 5000),
      ],
    );
  }

  Widget _buildAnimatedSection(Widget section, int index) {
    return AnimatedBuilder(
      animation: _sectionsController,
      builder: (context, child) {
        final animation = Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: _sectionsController,
            curve: Interval(
              index * 0.1,
              0.5 + (index * 0.1),
              curve: Curves.easeOut,
            ),
          ),
        );

        return Opacity(
          opacity: animation.value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - animation.value)),
            child: section,
          ),
        );
      },
    );
  }

  Widget _buildMobileDrawer() {
    final personalInfo = ref.watch(personalInfoProvider);

    return Drawer(
      backgroundColor: AppColors.backgroundPrimary,
      child: ListView(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: AppColors.heroGradient),
            ),
            child: Text(
              personalInfo.name,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const _DrawerItem(title: 'Home', icon: Icons.home, offset: 0),
          const _DrawerItem(title: 'About Me', icon: Icons.person, offset: 800),
          const _DrawerItem(title: 'Skills', icon: Icons.code, offset: 1400),
          const _DrawerItem(title: 'Projects', icon: Icons.work, offset: 2200),
          const _DrawerItem(
            title: 'Contact',
            icon: Icons.contact_mail,
            offset: 3000,
          ),
        ],
      ),
    );
  }
}

// Separate stateless widgets to prevent unnecessary rebuilds
class _NavButton extends ConsumerWidget {
  const _NavButton({required this.text, required this.offset});

  final String text;
  final double offset;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextButton(
      onPressed: () {
        final scrollController = ref.read(scrollControllerProvider);
        final navigationNotifier = ref.read(navigationProvider.notifier);
        navigationNotifier.scrollToSection(scrollController, offset);
      },
      child: Text(
        text,
        style: const TextStyle(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _DrawerItem extends ConsumerWidget {
  const _DrawerItem({
    required this.title,
    required this.icon,
    required this.offset,
  });

  final String title;
  final IconData icon;
  final double offset;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(title, style: const TextStyle(color: AppColors.textPrimary)),
      onTap: () {
        Navigator.pop(context);
        final scrollController = ref.read(scrollControllerProvider);
        final navigationNotifier = ref.read(navigationProvider.notifier);
        navigationNotifier.scrollToSection(scrollController, offset);
      },
    );
  }
}
