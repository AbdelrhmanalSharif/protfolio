import '../../domain/entities/portfolio_data.dart';
import '../../domain/repositories/portfolio_repository.dart';

class PortfolioRepositoryImpl implements PortfolioRepository {
  @override
  PersonalInfo getPersonalInfo() {
    return const PersonalInfo(
      name: 'Abd El-Rhman El-Sharif',
      title: 'Flutter Developer',
      description:
          'I create stellar mobile experiences with modern technologies. Specializing in front-end development, I build interfaces that are both beautiful and functional. And eager to expand my skills into web development.',
      email: 'abdelrhmmanelsharif@gmail.com',
      phone: '+961 71-454-383',
      location: 'Beirut, Lebanon',
      github: 'https://github.com/AbdelrhmanalSharif',
    );
  }

  @override
  List<Skill> getSkills() {
    return const [
      Skill(name: "HTML/CSS", color: 'red'),
      Skill(name: "JavaScript", color: 'yellow'),
      Skill(name: "TypeScript", color: 'blue'),
      Skill(name: "React", color: 'blue'),
      Skill(name: "Node.js", color: 'cyan'),
      Skill(name: "MongoDB", color: 'green'),
      Skill(name: "GitHub", color: 'black'),
      Skill(name: "Express", color: 'green'),
      Skill(name: 'Flutter', color: 'blue'),
      Skill(name: 'Dart', color: 'cyan'),
      Skill(name: 'Firebase', color: 'orange'),
      Skill(name: 'REST APIs', color: 'green'),
      Skill(name: 'State Management', color: 'purple'),
      Skill(name: 'UI/UX Design', color: 'pink'),
    ];
  }

  @override
  List<Project> getProjects() {
    return const [
      Project(
        title: 'E-commerce App',
        description: 'A complete shopping app with payment integration',
        iconName: 'mobile_friendly',
      ),
      Project(
        title: 'Weather App',
        description: 'Real-time weather updates with beautiful animations',
        iconName: 'mobile_friendly',
      ),
      Project(
        title: 'Event Software Page',
        description: 'Productivity app with event tracking and reminders',
        iconName: 'mobile_friendly',
      ),
      Project(
        title: 'Crypto Analytics Dashboard',
        description: 'Real-time cryptocurrency data and analytics',
        iconName: 'mobile_friendly',
      ),
      Project(
        title: 'Personal Portfolio',
        description: 'A personal portfolio website to showcase my projects',
        iconName: 'web',
      ),
      Project(
        title: 'Blog Platform',
        description: 'A full-featured blogging platform with user authentication',
        iconName: 'mobile_friendly',
      ),
      Project(
        title: 'Personal Portfolio',
        description: 'A personal portfolio website to showcase my projects',
        iconName: 'mobile_friendly',
      ),
      Project(
        title: 'Blog Platform',
        description: 'A full-featured blogging platform with user authentication',
        iconName: 'mobile_friendly',
      ),
    ];
  }

  @override
  List<Statistic> getStatistics() {
    return const [
      Statistic(title: 'Projects', value: '15+'),
      Statistic(title: 'Experience', value: '2 Years'),
      Statistic(title: 'Clients', value: '10+'),
    ];
  }
}
