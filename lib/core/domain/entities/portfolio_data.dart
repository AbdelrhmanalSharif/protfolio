class PersonalInfo {
  final String name;
  final String title;
  final String description;
  final String email;
  final String phone;
  final String location;
  final String? github;

  const PersonalInfo({
    required this.name,
    required this.title,
    required this.description,
    required this.email,
    required this.phone,
    required this.location,
    this.github,
  });
}

class Skill {
  final String name;
  final String color;

  const Skill({required this.name, required this.color});
}

class Project {
  final String title;
  final String description;
  final String iconName;

  const Project({
    required this.title,
    required this.description,
    required this.iconName,
  });
}

class Statistic {
  final String title;
  final String value;

  const Statistic({required this.title, required this.value});
}
