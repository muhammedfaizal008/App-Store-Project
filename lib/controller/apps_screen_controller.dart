import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AppsScreenController with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> _apps = [];
  bool _isLoading = true;

  List<Map<String, dynamic>> get apps => _apps;
  bool get isLoading => _isLoading;

  AppsScreenController() {
    fetchApps();
  }

  Future<void> fetchApps() async {
    try {
      _isLoading = true;
      notifyListeners();

      QuerySnapshot querySnapshot = await _firestore.collection('apps').get();
      _apps = querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      print("Error fetching apps: $e");
      _isLoading = false;
      notifyListeners();
    }
  }
}
