
class Subscriptions {
    final int packageId;
    final String date;
    final String validity;
    final int userId;

    Subscriptions({
        required this.packageId,
        required this.date,
        required this.userId,
        required this.validity
    });


    Map<String, dynamic> toJson() => {
        "packageId": packageId,
        "date": date,
        "userId": userId,
        "validity":validity,
    };

  Map<String, Object?> toMap() {
    return {
      'userId': userId,
      'packageId': packageId,
      'date': date,
      'validity':validity,
    };
  }
}
