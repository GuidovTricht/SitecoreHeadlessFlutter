class ExperienceData {
  Visits visits;
  PersonalInfo personalInfo;
  OnsiteBehavior onsiteBehavior;
  bool isActive;

  ExperienceData(
      this.visits, this.personalInfo, this.onsiteBehavior, this.isActive);

  factory ExperienceData.fromJson(dynamic json) {
    return ExperienceData(
        Visits.fromJson(json['Visits']),
        PersonalInfo.fromJson(json['PersonalInfo']),
        OnsiteBehavior.fromJson(json['OnsiteBehavior']),
        json['IsActive'] as bool);
  }
}

class PersonalInfo {
  String fullName;
  bool isIdentified;

  PersonalInfo(this.fullName, this.isIdentified);

  factory PersonalInfo.fromJson(dynamic json) {
    return PersonalInfo(
        json['FullName'] as String, json['IsIdentified'] as bool);
  }
}

class OnsiteBehavior {
  List<Goal> goals;

  OnsiteBehavior(this.goals);

  factory OnsiteBehavior.fromJson(dynamic json) {
    var objsJson = json['Goals'] as List;
    var goalsList =
        objsJson.map((goalJson) => Goal.fromJson(goalJson)).toList();

    return OnsiteBehavior(goalsList);
  }
}

class Goal {
  int engagementValue;
  String title;
  String date;
  bool isCurrentVisit;

  Goal(this.engagementValue, this.title, this.date, this.isCurrentVisit);

  factory Goal.fromJson(dynamic json) {
    return Goal(json['EngagementValue'] as int, json['Title'] as String,
        json['Date'] as String, json['IsCurrentVisit'] as bool);
  }
}

class Visits {
  int engagementValue;
  List<PageView> pageViews;
  int totalPageViews;
  int totalVisits;

  Visits(this.engagementValue, this.pageViews, this.totalPageViews,
      this.totalVisits);

  factory Visits.fromJson(dynamic json) {
    var objsJson = json['PageViews'] as List;
    var pageViewsList = objsJson
        .map((pageViewJson) => PageView.fromJson(pageViewJson))
        .toList();

    return Visits(json['EngagementValue'] as int, pageViewsList,
        json['TotalPageViews'] as int, json['TotalVisits'] as int);
  }
}

class PageView {
  String fullPath;
  String path;
  String duration;
  bool hasEngagementValue;
  bool hasMvTest;
  bool hasPersonalisation;

  PageView(this.fullPath, this.path, this.duration, this.hasEngagementValue,
      this.hasMvTest, this.hasPersonalisation);

  factory PageView.fromJson(dynamic json) {
    return PageView(
        json['FullPath'] as String,
        json['Path'] as String,
        json['Duration'] as String,
        json['HasEngagementValue'] as bool,
        json['HasMvTest'] as bool,
        json['HasPersonalisation'] as bool);
  }
}
