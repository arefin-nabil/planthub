class Expert {
  final String id;
  final String name;
  final String title;
  final String imageUrl;
  final double rating;
  final int consultations;
  final String specialty;
  final int pricePerSession;
  final bool available;
  final List<String> skills;

  const Expert({
    required this.id,
    required this.name,
    required this.title,
    required this.imageUrl,
    required this.rating,
    required this.consultations,
    required this.specialty,
    required this.pricePerSession,
    required this.available,
    required this.skills,
  });
}

/// Backwards compatibility alias
typedef MockExpert = Expert;

class ConsultationBooking {
  final String id;
  final Expert expert;
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

