import 'package:flutter/material.dart';
import 'package:mtmeru_afya_yangu/features/authentication/controllers/user.controller.dart';
import 'package:mtmeru_afya_yangu/features/packages/mch/controller/pregnancy.controller.dart';
import 'package:mtmeru_afya_yangu/features/packages/mch/models/pregnancies.model.dart';

class PregnancyState extends ChangeNotifier {
  // Private variables
  DateTime? _selectedLMP;
  int _cycleLength = 28;
  String _dueDate = '';
  String _pregnancyWeek = '';
  Pregnancies? _pregnancy;

  // Getters to expose variables
  DateTime? get selectedLMP => _selectedLMP;
  int get cycleLength => _cycleLength;
  String get dueDate => _dueDate;
  String get pregnancyWeek => _pregnancyWeek;
  Pregnancies? get pregnancy => _pregnancy;

  // Computed property for pregnancy progress
  double get pregnancyProgress {
    if (_selectedLMP == null) return 0.0;
    int cycleAdjustment = _cycleLength - 28;
    DateTime adjustedLMP = _selectedLMP!.add(Duration(days: cycleAdjustment));
    int daysPregnant = DateTime.now().difference(adjustedLMP).inDays;
    return (daysPregnant / 280).clamp(0.0, 1.0);
  }
  
  get tableName => null;

  // Function to calculate the due date
  DateTime _calculateDueDate(DateTime lmp, int cycleLength) {
    int cycleAdjustment = cycleLength - 28;
    DateTime adjustedLMP = lmp.add(Duration(days: cycleAdjustment));
    return adjustedLMP.add(const Duration(days: 280)); // Add 280 days (40 weeks)
  }

  // Function to calculate the current pregnancy week
  int _calculateCurrentWeek(DateTime lmp, int cycleLength) {
    int cycleAdjustment = cycleLength - 28;
    DateTime adjustedLMP = lmp.add(Duration(days: cycleAdjustment));
    int daysPregnant = DateTime.now().difference(adjustedLMP).inDays;

    if (daysPregnant < 0) return 0; // Before pregnancy started

    return (daysPregnant ~/ 7) + 1; // Convert days to weeks
  }

  void _updatePregnancyDetails() {
    if (_selectedLMP != null) {
      DateTime dueDate = _calculateDueDate(_selectedLMP!, _cycleLength);
      int pregnancyWeek = _calculateCurrentWeek(_selectedLMP!, _cycleLength);

      _dueDate = "${dueDate.year}-${dueDate.month.toString().padLeft(2, '0')}-${dueDate.day.toString().padLeft(2, '0')}";
      _pregnancyWeek =
          pregnancyWeek == 0 ? "Not Pregnant Yet" : "Week $pregnancyWeek";
    } else {
      _dueDate = '';
      _pregnancyWeek = '';
    }
    notifyListeners();
  }

  // Load pregnancy data from SQLite
  Future<void> loadPregnancyData() async {
    List<Map<String, dynamic>>? result = await PregnancyController().loadPregnancy();
    if (result != null && result.isNotEmpty) {
      _pregnancy = Pregnancies.fromMap(result.first);
      _selectedLMP = DateTime.parse(_pregnancy!.lmp);
      _cycleLength = _pregnancy!.cycle;
      _updatePregnancyDetails();
    }
  }

  // Save pregnancy data to SQLite
  Future<void> savePregnancyData() async {
    if (_selectedLMP != null) {
      Pregnancies pregnancy = Pregnancies(
        id: _pregnancy?.id ?? 0,
        userId: _pregnancy?.userId ?? 1, // Default user ID
        lmp: _selectedLMP!.toIso8601String(),
        edd: _dueDate,
        cycle: _cycleLength,
      );

      await PregnancyController().insertPregnancy(pregnancy.toMap());
      await loadPregnancyData(); // Reload data to ensure sync
    }
  }

  void setLMP(DateTime lmp) {
    _selectedLMP = lmp;
    _updatePregnancyDetails();
    savePregnancyData(); // Persist changes
  }

  void setCycleLength(int length) {
    _cycleLength = length;
    _updatePregnancyDetails();
    savePregnancyData(); // Persist changes
  }

  // Clear subscription data
  Future<void> clearSubscription() async {
    _selectedLMP = null;
    _cycleLength = 28;
    _dueDate = '';
    _pregnancyWeek = '';
    _pregnancy = null;

    notifyListeners(); // Notify UI to update

    // Clear data from the SQLite database
    await clearPregnancyData();
  }

   Future<void> clearPregnancyData() async {
    try {
      final db = await DatabaseHelper().database;
      await db.delete(tableName); // Delete all rows from the table
    } catch (error) {
      throw Exception("Failed to clear pregnancy data: $error");
    }
  }
}
