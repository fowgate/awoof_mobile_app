
/// This class loads all bank suggestions in your text field
class Suggestions {

  /// This method checks whether the [query] matches any list [items]
  /// It returns a list of bank names it matches [matches]
  static Future<List<String>> getSuggestions(String query, List<String> items) async {
    if(items.isEmpty) await Future.delayed(Duration(seconds: 1));

    List<String> matches = [];
    matches.addAll(items);

    matches.retainWhere((s) => s.toLowerCase().contains(query.toLowerCase()));
    return matches;
  }
}