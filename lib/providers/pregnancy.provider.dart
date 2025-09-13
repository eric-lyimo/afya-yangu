import 'package:flutter/material.dart';
import 'package:mtmeru_afya_yangu/features/authentication/models/user.model.dart';
import 'package:mtmeru_afya_yangu/features/packages/mch/models/pregnancies.model.dart';
import 'package:mtmeru_afya_yangu/features/packages/mch/models/pregnancy.logs.dart';
import 'package:mtmeru_afya_yangu/providers/user.provider.dart';

class PregnancyState extends ChangeNotifier {
  // Private variables
  DateTime? _selectedLMP;
  int _cycleLength = 28;
  String _dueDate = '';
  int _pregnancyWeek = 0;
  Pregnancies? _pregnancy;
  List<PregnancyLogs> _logs =[];

  bool _isLoading = false;
  String _errorMessage = '';

  // Dependency Injection: PregnancyController instance

  final UserState _userState;

  // Constructor with Dependency Injection
  PregnancyState(this._userState);

  // Getters
  DateTime? get selectedLMP => _selectedLMP;
  int get cycleLength => _cycleLength;
  String get dueDate => _dueDate;
  int get pregnancyWeek => _pregnancyWeek;
  Pregnancies? get pregnancy => _pregnancy;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  Users? get currentUser => _userState.user;
  List<PregnancyLogs> get logs => _logs;

  // Computed property for pregnancy progress
  double get pregnancyProgress {
    if (_selectedLMP == null) return 0.0;
    int cycleAdjustment = _cycleLength - 28;
    DateTime adjustedLMP = _selectedLMP!.add(Duration(days: cycleAdjustment));
    int daysPregnant = DateTime.now().difference(adjustedLMP).inDays;
    return (daysPregnant / 280).clamp(0.0, 1.0);
  }

  // Helper methods
  DateTime _calculateDueDate(DateTime lmp, int cycleLength) {
    int cycleAdjustment = cycleLength - 28;
    DateTime adjustedLMP = lmp.add(Duration(days: cycleAdjustment));
    return adjustedLMP.add(const Duration(days: 280)); // Add 280 days (40 weeks)
  }

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
      _pregnancyWeek = pregnancyWeek;
    } else {
      _dueDate = '';
      _pregnancyWeek = 0;
    }
    notifyListeners();
  }

  // Load pregnancy data from API
  Future<void> loadPregnancyData() async {
    _setLoading(true);
    try {
      if (_pregnancy != null ) {
        _pregnancy = _pregnancy;
        _selectedLMP = DateTime.parse(_pregnancy!.lmp);
        _cycleLength = _pregnancy!.cycle;
        _updatePregnancyDetails();
      } else {
        _errorMessage = 'No pregnancy data found.';
      }
    } catch (error) {
      _errorMessage = 'Error loading pregnancy data: $error';
    } finally {
      _setLoading(false);
    }
  }

  // Save pregnancy data to the API
Future<void> savePregnancyData(Pregnancies pregnancy) async {      
    try {
      Pregnancies pregnancyData =Pregnancies(
        id: pregnancy.id,
        userId: pregnancy.userId,
        lmp: pregnancy.lmp,
        edd: pregnancy.edd,
        cycle: pregnancy.cycle,
      );
      _pregnancy = pregnancyData;
       notifyListeners();
    } catch (error) {
      _errorMessage = 'Error saving pregnancy data: $error';
    }
}

Future<void> savePregnancyLogs(List<PregnancyLogs> logs) async {      
    try {
      if (_logs.isNotEmpty) {
        _logs.addAll(logs);
        notifyListeners();
      }
      else{
        _logs = logs;
        notifyListeners();
      }
    } catch (error) {
      _errorMessage = 'Error saving pregnancy data: $error';
    }
}
Future<void> deletePregnancyLogs(PregnancyLogs logs) async {
  try {
    // Ensure proper object comparison
    _logs.remove(logs);
      notifyListeners();
  } catch (error) {
    _errorMessage = 'Error removing pregnancy log: $error';
  }
}


  // Set Last Menstrual Period (LMP)
  void setLMP(DateTime lmp, Users user) {
    _selectedLMP = lmp;
    _updatePregnancyDetails();

  }

  // Set Cycle Length
  void setCycleLength(int length, Users user) {
    _cycleLength = length;
    _updatePregnancyDetails();
  }

  // Clear pregnancy data
  Future<void> clearPregnancyData() async {
    _setLoading(true);
    try {
      _selectedLMP = null;
      _cycleLength = 28;
      _dueDate = '';
      _pregnancyWeek = 0;
      _pregnancy = null;
      notifyListeners();
    } catch (error) {
      _errorMessage = 'Failed to clear pregnancy data: $error';
    } finally {
      _setLoading(false);
    }
  }

  // Helper to set loading state
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}
