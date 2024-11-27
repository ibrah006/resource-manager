import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

Future<void> getWordInfo(String word) async {
  // Define the Free Dictionary API URL
  var url = Uri.parse('https://api.dictionaryapi.dev/api/v2/entries/en/$word');

  try {
    // Make a request to the Free Dictionary API
    var response = await http.get(url);

    // Check if the request was successful
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      // Extract and print the word's information
      for (var meaning in data[0]['meanings']) {
        print('Part of Speech: ${meaning['partOfSpeech']}');

        for (var definition in meaning['definitions']) {
          print('Definition: ${definition['definition']}');
          if (definition.containsKey('example')) {
            print('Example: ${definition['example']}');
          }
        }

        // Fetch synonyms if available
        if (meaning.containsKey('synonyms')) {
          print('Synonyms: ${meaning['synonyms'].join(', ')}');
        } else {
          print('No synonyms found.');
        }
      }
    } else {
      print('Error: ${response.statusCode} - Unable to fetch data for "$word"');
    }
  } catch (e) {
    print('An error occurred: $e');
  }
}

void main() async {
  String word = 'Expenses';  // Example word
  await getWordInfo(word);  // Fetch and print word information
}

void getSubcategories(String category) async {
  final String endpoint = 'https://dbpedia.org/sparql';
  final String query = '''
  SELECT ?subcategory WHERE {
    ?subcategory <http://www.w3.org/2004/02/skos/core#broader> <http://dbpedia.org/resource/Category:$category> .
  }
  LIMIT 10
  ''';

  final response = await http.get(
    Uri.parse('$endpoint?query=${Uri.encodeComponent(query)}&format=json'),
    headers: {
      'Accept': 'application/sparql-results+json',  // Updated Accept header
    },
  );

  String jsonString = jsonEncode(response.body);

  // Define the file path (this example writes to the app's directory)
  final file = File('data.json');

  try {
    // Write the JSON string to the file
    await file.writeAsString(jsonString);
    print("File written successfully!");
  } catch (e) {
    print("Error writing to file: $e");
  }
}
Future<void> fetchGroceriesCategory() async {
  final response = await http.get(
    Uri.parse("http://dbpedia.org/resource/Category:Food"),
    headers: {'Accept': 'application/json'},
  );

  if (response.statusCode == 200) {
    // Check the response body for categories
    print(response.body);

    try {
      var jsonResponse = jsonDecode(response.body);
      // You can inspect the structure of the response to find subcategories
      // For example, print out the keys or categories from the response
      print(jsonResponse);
    } catch (e) {
      print("Error parsing JSON response: $e");
    }
  } else {
    print('Failed to load category');
  }
}
