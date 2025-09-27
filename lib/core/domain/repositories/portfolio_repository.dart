import '../entities/portfolio_data.dart';

abstract class PortfolioRepository {
  PersonalInfo getPersonalInfo();
  List<Skill> getSkills();
  List<Project> getProjects();
  List<Statistic> getStatistics();
}
