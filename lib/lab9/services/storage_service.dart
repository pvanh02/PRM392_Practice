import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import '../models/book_model.dart';
import '../models/contact_model.dart';

/// Service class handling file persistence operations
class StorageService {
  /// Reads books from the static asset bundle
  Future<List<Book>> loadBooksFromAssets() async {
    try {
      final jsonString = await rootBundle.loadString('assets/data/books.json');
      final List<dynamic> decoded = json.decode(jsonString) as List<dynamic>;
      return decoded.map((item) => Book.fromJson(item as Map<String, dynamic>)).toList();
    } catch (e) {
      throw Exception('Failed to read assets database: $e');
    }
  }

  /// Helper to resolve local path
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  /// Helper to resolve target database file
  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/contacts.json');
  }

  /// Reads contacts list from device storage
  Future<List<Contact>> loadContactsFromStorage() async {
    try {
      final file = await _localFile;

      if (!await file.exists()) {
        // Pre-populate database with default items for clean UX
        final defaultContacts = [
          const Contact(id: 1, name: 'John Doe', email: 'john@example.com', phone: '+1 234 567 890'),
          const Contact(id: 2, name: 'Jane Smith', email: 'jane@example.com', phone: '+1 987 654 321'),
          const Contact(id: 3, name: 'Alex Johnson', email: 'alex@example.com', phone: '+1 555 019 283'),
        ];
        await saveContactsToStorage(defaultContacts);
        return defaultContacts;
      }

      final contents = await file.readAsString();
      final List<dynamic> decoded = json.decode(contents) as List<dynamic>;
      return decoded.map((item) => Contact.fromJson(item as Map<String, dynamic>)).toList();
    } catch (e) {
      throw Exception('Failed to read from local file: $e');
    }
  }

  /// Saves the updated contacts array to file
  Future<void> saveContactsToStorage(List<Contact> contacts) async {
    try {
      final file = await _localFile;
      final jsonList = contacts.map((c) => c.toJson()).toList();
      final jsonString = json.encode(jsonList);
      await file.writeAsString(jsonString);
    } catch (e) {
      throw Exception('Failed to write updates to local file: $e');
    }
  }
}
