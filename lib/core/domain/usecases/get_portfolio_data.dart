import '../entities/portfolio_data.dart';
import '../repositories/portfolio_repository.dart';

class GetPortfolioData {
  final PortfolioRepository repository;

  GetPortfolioData(this.repository);

  PersonalInfo getPersonalInfo() => repository.getPersonalInfo();
  List<Skill> getSkills() => repository.getSkills();
  List<Project> getProjects() => repository.getProjects();
  List<Statistic> getStatistics() => repository.getStatistics();
}
