
class Packages {
    final int id;
    final String name;

    Packages({
        required this.id,
        required this.name,
    });


    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
    };

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }
}
