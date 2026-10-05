import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../data/mock/mock_data.dart';

class ConsultationBooking {
  final String id;
  final MockExpert expert;
  final DateTime date;
  final String timeSlot;
  final String problemDescription;
  final String plantType;
  final double fee;
  final String status; // 'Confirmed', 'Completed', 'Cancelled'

  ConsultationBooking({
    required this.id,
    required this.expert,
    required this.date,
    required this.timeSlot,
    required this.problemDescription,
    required this.plantType,
    required this.fee,
    this.status = 'Confirmed',
  });
}

class ConsultationProvider extends ChangeNotifier {
  final List<MockExpert> _experts = [];
  final List<ConsultationBooking> _myBookings = [];
  String _selectedSpecialty = 'সব';

  static const List<String> specialties = [
    'সব',
    'রোগ বালাই দমন',
    'মাটি ও পুষ্টি',
    'ইনডোর প্ল্যান্ট কেয়ার',
    'ছাদ বাগান ও বনসাই',
  ];

  ConsultationProvider() {
    _experts.addAll(MockData.experts);
    // Seed with 1 past booking for demonstration
    if (_experts.isNotEmpty) {
      _myBookings.add(ConsultationBooking(
        id: 'CON-9921',
        expert: _experts[0],
        date: DateTime.now().add(const Duration(days: 1)),
        timeSlot: 'বিকাল ৪:০০ - ৪:৩০',
        problemDescription: 'মনিস্টেরা গাছের পাতায় বাদামী দাগ ও হলুদ ভাব।',
        plantType: 'Monstera Deliciosa',
        fee: _experts[0].pricePerSession.toDouble(),
      ));
    }
  }

  List<MockExpert> get experts => List.unmodifiable(_experts);
  List<ConsultationBooking> get myBookings => List.unmodifiable(_myBookings);
  String get selectedSpecialty => _selectedSpecialty;

  List<MockExpert> get filteredExperts {
    if (_selectedSpecialty == 'সব') return _experts;
    return _experts.where((e) => e.specialty.contains(_selectedSpecialty) || e.skills.any((s) => s.contains(_selectedSpecialty))).toList();
  }

  void setSpecialty(String specialty) {
    _selectedSpecialty = specialty;
    notifyListeners();
  }

  ConsultationBooking bookConsultation({
    required MockExpert expert,
    required DateTime date,
    required String timeSlot,
    required String problemDescription,
    required String plantType,
  }) {
    final booking = ConsultationBooking(
      id: 'CON-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
      expert: expert,
      date: date,
      timeSlot: timeSlot,
      problemDescription: problemDescription,
      plantType: plantType,
      fee: expert.pricePerSession.toDouble(),
    );

    _myBookings.insert(0, booking);
    HapticFeedback.heavyImpact();
    notifyListeners();
    return booking;
  }
}
