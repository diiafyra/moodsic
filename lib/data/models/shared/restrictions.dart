class Restrictions {
  final String reason;

  Restrictions({required this.reason});

  factory Restrictions.fromJson(Map<String, dynamic> json) {
    return Restrictions(reason: json['reason']);
  }
}

