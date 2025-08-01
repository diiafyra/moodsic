class Validators {
  static bool isValidSearchQuery(String query, String value) {
    return value.toLowerCase().contains(query.toLowerCase());
  }
}
