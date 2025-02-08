import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SearchScreenController with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> _allData = [];
  List<Map<String, dynamic>> _filteredData = [];
  bool _isLoading = true;
  String _searchQuery = '';

  List<Map<String, dynamic>> get filteredData => _filteredData;
  bool get isLoading => _isLoading;
  String get searchQuery => _searchQuery;

  SearchScreenController() {
    fetchAllData(); 
  }


  Future<void> fetchAllData() async {
    try {
      _isLoading = true;
      notifyListeners();

      QuerySnapshot querySnapshot = await _firestore.collection('apps').get();
      _allData = querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
      _filteredData = _allData; // Initially, filtered data is the same as all data

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      print("Error fetching data: $e");
      _isLoading = false;
      notifyListeners();
    }
  }


  void updateSearchQuery(String query) {
    _searchQuery = query;
    _filterData();
    notifyListeners();
  }

 
  void _filterData() {
    if (_searchQuery.isEmpty) {
      _filteredData = _allData; // query is empty show all data
    } else {
      _filteredData = _allData.where((item) {
        //logic 
        final String title = item['title']?.toString().toLowerCase() ?? '';
        final String author = item['author']?.toString().toLowerCase() ?? '';
        final String description = item['description']?.toString().toLowerCase() ?? '';

        return title.contains(_searchQuery.toLowerCase()) ||
            author.contains(_searchQuery.toLowerCase()) ||
            description.contains(_searchQuery.toLowerCase());
      }).toList();
    }
  }
}