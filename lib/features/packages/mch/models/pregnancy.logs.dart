class PregnancyLogs {
  final int? id;
  final String? exercise;
  final String? mood;
  final String? appetite;
  final String? vaginalDischarge;
  final int? pregnancyId;
  final String? comment;
  final String? activities;
  final String? swelling;
  final String? symptoms;
  final String? stool;

  PregnancyLogs({
    required this.id,
    required this.exercise,
    required this.mood,
    required this.appetite,
    required this.vaginalDischarge,
    required this.pregnancyId,
    required this.comment,
    required this.activities,
    required this.swelling,
    required this.symptoms,
    required this.stool,
  });

  // Factory constructor to create an instance from JSON
  factory PregnancyLogs.fromJson(Map<String, dynamic> json) {
    return PregnancyLogs(
      id: json["id"] as int?,
      exercise: json["exercises"] ?? "normal routine",
      mood: json["mood"] ?? "happy",
      appetite: json["appetite"] ?? "normal",
      vaginalDischarge: json["vaginal_discharge"] ?? "normal",
      pregnancyId: json["pregnancy_id"] as int,
      comment: json["comments"] ?? "no comment",
      activities: json["activities"] ?? "none",
      swelling: json["swelling"] ?? "none",
      symptoms: json["symptoms"] ?? "none",
      stool: json["digestion_stool"] ?? "none",
    );
  }

  // Convert an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "exercises": exercise,
      "mood": mood,
      "appetite": appetite,
      "vaginal_discharge": vaginalDischarge,
      "pregnancy_id": pregnancyId,
      "comments": comment,
      "activities": activities,
      "swelling": swelling,
      "symptoms": symptoms,
      "digestion_stool": stool,
    };
  }

  // Factory constructor to create an instance from a SQLite map
  factory PregnancyLogs.fromMap(Map<String, dynamic> map) {
    return PregnancyLogs(
      id: map["id"] as int?,
      exercise: map["exercise"] as String?,
      mood: map["mood"] as String?,
      appetite: map["appetite"] as String?,
      vaginalDischarge: map["vaginalDischarge"] as String?,
      pregnancyId: map["pregnancyId"] as int,
      comment: map["comment"] as String?,
      activities: map["activities"] as String?,
      swelling: map["swelling"] as String?,
      symptoms: map["symptoms"] as String?,
      stool: map["stool"] as String?,
    );
  }

  // Convert an instance to a SQLite-compatible map
  Map<String, Object?> toMap() {
    return {
      "id": id,
      "exercise": exercise,
      "mood": mood,
      "appetite": appetite,
      "vaginalDischarge": vaginalDischarge,
      "pregnancyId": pregnancyId,
      "comment": comment,
      "activities": activities,
      "swelling": swelling,
      "symptoms": symptoms,
      "stool": stool,
    };
  }

  // Add the copyWith method
  PregnancyLogs copyWith({
    int? id,
    String? exercise,
    String? mood,
    String? appetite,
    String? vaginalDischarge,
    int? pregnancyId,
    String? comment,
    String? activities,
    String? swelling,
    String? symptoms,
    String? stool,
  }) {
    return PregnancyLogs(
      id: id ?? this.id,
      exercise: exercise ?? this.exercise,
      mood: mood ?? this.mood,
      appetite: appetite ?? this.appetite,
      vaginalDischarge: vaginalDischarge ?? this.vaginalDischarge,
      pregnancyId: pregnancyId ?? this.pregnancyId,
      comment: comment ?? this.comment,
      activities: activities ?? this.activities,
      swelling: swelling ?? this.swelling,
      symptoms: symptoms ?? this.symptoms,
      stool: stool ?? this.stool,
    );
  }

  // Override equality operator for proper comparison
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PregnancyLogs && other.id == id;
  }

  // Override hashCode for consistent hashing
  @override
  int get hashCode => id.hashCode;
}
