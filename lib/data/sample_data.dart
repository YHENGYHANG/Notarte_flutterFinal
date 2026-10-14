import '../models/product.dart';

/// Placeholder photo generator (random but stable per seed).
String seedImage(String seed) => 'https://picsum.photos/seed/$seed/600/600';

/// Starting data used the first time the app runs (or after a reset).
List<Product> getSampleProducts() {
  Product make(int day, String id, String name, String category, double price,
      int qty, String notes) {
    return Product(
      id: id,
      name: name,
      category: category,
      price: price,
      quantity: qty,
      notes: notes,
      imageUrl: seedImage(id),
      createdAt: DateTime(2026, 9, day),
    );
  }

  return [
    make(1, 'mouse', 'Wireless Mouse', 'Electronics', 15.99, 24,
        'Ergonomic 2.4GHz mouse with silent clicks.'),
    make(2, 'keyboard', 'Mechanical Keyboard', 'Electronics', 59.50, 4,
        'Tactile switches, compact layout. Reorder soon.'),
    make(3, 'chair', 'Office Chair', 'Furniture', 120.00, 8,
        'Adjustable lumbar support, mesh back.'),
    make(4, 'paper', 'A4 Paper Ream', 'Stationery', 4.25, 120,
        '500 sheets, 80gsm. Bulk supply for the printers.'),
    make(5, 'lamp', 'LED Desk Lamp', 'Furniture', 22.00, 0,
        'Warm light, three brightness levels.'),
    make(6, 'pens', 'Ballpoint Pens (Box)', 'Stationery', 3.10, 3,
        'Box of 12, blue ink.'),
    make(7, 'webcam', 'HD Webcam', 'Electronics', 34.90, 15,
        '1080p with built-in microphone.'),
    make(8, 'notebook', 'Spiral Notebook', 'Stationery', 2.80, 60,
        'A5, 100 pages, dotted.'),
    make(9, 'desk', 'Standing Desk', 'Furniture', 289.00, 6,
        'Electric height adjustment, 140cm wide.'),
  ];
}
