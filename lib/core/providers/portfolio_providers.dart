import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/repositories/portfolio_repository_impl.dart';
import '../domain/entities/portfolio_data.dart';
import '../domain/repositories/portfolio_repository.dart';
import '../domain/usecases/get_portfolio_data.dart';

// Repository Provider
final portfolioRepositoryProvider = Provider<PortfolioRepository>((ref) {
  return PortfolioRepositoryImpl();
});

// Use Case Provider
final getPortfolioDataProvider = Provider<GetPortfolioData>((ref) {
  final repository = ref.watch(portfolioRepositoryProvider);
  return GetPortfolioData(repository);
});

// Data Providers
final personalInfoProvider = Provider<PersonalInfo>((ref) {
  final getPortfolioData = ref.watch(getPortfolioDataProvider);
  return getPortfolioData.getPersonalInfo();
});

final skillsProvider = Provider<List<Skill>>((ref) {
  final getPortfolioData = ref.watch(getPortfolioDataProvider);
  return getPortfolioData.getSkills();
});

final projectsProvider = Provider<List<Project>>((ref) {
  final getPortfolioData = ref.watch(getPortfolioDataProvider);
  return getPortfolioData.getProjects();
});

final statisticsProvider = Provider<List<Statistic>>((ref) {
  final getPortfolioData = ref.watch(getPortfolioDataProvider);
  return getPortfolioData.getStatistics();
});

// Scroll Controller Provider
final scrollControllerProvider = Provider<ScrollController>((ref) {
  final controller = ScrollController();
  ref.onDispose(() => controller.dispose());
  return controller;
});

// Navigation Provider
final navigationProvider = StateNotifierProvider<NavigationNotifier, int>((
  ref,
) {
  return NavigationNotifier();
});

class NavigationNotifier extends StateNotifier<int> {
  NavigationNotifier() : super(0);

  void navigateToSection(int sectionIndex) {
    state = sectionIndex;
  }

  void scrollToSection(ScrollController controller, double offset) {
    controller.animateTo(
      offset,
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOut,
    );
  }
}
