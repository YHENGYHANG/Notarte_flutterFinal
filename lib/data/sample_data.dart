import '../models/product.dart';

/// Returns the starting list of products (a List of our custom class).
List<Product> getInitialProducts() {
  return [
    Product(
      id: '1',
      name: 'Wireless Mouse',
      category: 'Electronics',
      price: 15.99,
      quantity: 24,
      imageUrl: 'https://picsum.photos/seed/mouse/200',
    ),
    Product(
      id: '2',
      name: 'Mechanical Keyboard',
      category: 'Electronics',
      price: 59.50,
      quantity: 4,
      imageUrl: 'https://picsum.photos/seed/keyboard/200',
    ),
    Product(
      id: '3',
      name: 'Office Chair',
      category: 'Furniture',
      price: 120.00,
      quantity: 8,
      imageUrl: 'https://picsum.photos/seed/chair/200',
    ),
    Product(
      id: '4',
      name: 'A4 Paper Ream',
      category: 'Stationery',
      price: 4.25,
      quantity: 120,
      imageUrl: 'https://picsum.photos/seed/paper/200',
    ),
    Product(
      id: '5',
      name: 'LED Desk Lamp',
      category: 'Furniture',
      price: 22.00,
      quantity: 0,
      imageUrl: 'https://picsum.photos/seed/lamp/200',
    ),
    Product(
      id: '6',
      name: 'Ballpoint Pens (Box)',
      category: 'Stationery',
      price: 3.10,
      quantity: 3,
      imageUrl: 'https://picsum.photos/seed/pens/200',
    ),
  ];
}
