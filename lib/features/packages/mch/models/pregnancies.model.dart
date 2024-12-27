class Pregnancies {
  final int id;
  final int cycle; 
  final String lmp;
  final String edd;
  final int userId;

  Pregnancies({
    required this.id,
    required this.userId,
    required this.edd,
    required this.lmp,
    required this.cycle,
  });

  // Factory constructor to create an instance from JSON
  factory Pregnancies.fromJson(Map<String, dynamic> json) {
    return Pregnancies(
      id: json["id"],
      userId: json["userId"], 
      lmp: json["lmp"],
      edd: json["edd"],
      cycle: json["cycle"] is int ? json["cycle"] : int.parse(json["cycle"]),
    );
  }

  // Convert an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "userId": userId,
      "lmp": lmp,
      "edd": edd,
      "cycle": cycle,
    };
  }

  // Factory constructor to create an instance from a SQLite map
  factory Pregnancies.fromMap(Map<String, dynamic> map) {
    return Pregnancies(
      id: map['id'],
      userId: map['userId'], 
      lmp: map['lmp'],
      edd: map['edd'],
      cycle: map['cycle'],
    );
  }

  // Convert an instance to a SQLite-compatible map
  Map<String, Object?> toMap() {
    return {
      "id": id,
      "userId": userId,
      "lmp": lmp,
      "edd": edd,
      "cycle": cycle,
    };
  }
}
