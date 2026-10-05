class Order {
  final String id;
  final String plantName;
  final String plantImage;
  final int quantity;
  final double total;
  final String status;
  final String nurseryName;
  final DateTime date;

  const Order({
    required this.id,
    required this.plantName,
    required this.plantImage,
    required this.quantity,
    required this.total,
    required this.status,
    required this.nurseryName,
    required this.date,
  });
}

/// Backwards compatibility alias
typedef MockOrder = Order;
