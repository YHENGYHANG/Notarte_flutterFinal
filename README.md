# Inventory Management (Flutter)

A responsive inventory app with full CRUD, built to teach core Flutter UI concepts.

## Setup (first time only)
This zip contains the Dart code, assets and fonts. Generate the platform folders once:

```bash
cd inventory_management
flutter create . --project-name inventory_management
flutter pub get
flutter run            # or: flutter run -d chrome
```
`flutter create .` will NOT overwrite lib/, pubspec.yaml or assets.
Android release builds need `<uses-permission android:name="android.permission.INTERNET"/>`
in `android/app/src/main/AndroidManifest.xml` so network images load.

Run the tests with `flutter test`.

## CRUD
| Operation | How the user does it | Code |
|---|---|---|
| **Create** | "Add Product" button -> form | `addProductFlow`, `InventoryController.add` |
| **Read** | Grid/list, search, category filter, sort, detail page | `HomeScreen`, `ProductDetailScreen`, `InventoryController.query` |
| **Update** | Card menu / detail page -> Edit, or +/- stepper | `editProductFlow`, `update`, `adjustQuantity` |
| **Delete** | Card menu / detail page -> confirm, with Undo | `deleteProductFlow`, `remove`, `restore` |

Data is saved on the device with `shared_preferences`, so it survives restarts.

## Responsive design
| Width | Layout |
|---|---|
| < 600 (phone) | AppBar, stacked stats, 1 column, FAB, Add/Edit as **bottom sheet** |
| 600 - 999 (tablet) | Same page, stats in one row, 2 columns, Add/Edit as **dialog** |
| >= 1000 (desktop) | **Sidebar** (category navigation) + top bar + 2-4 column grid |

The grid column count is calculated from the available width (about one column per 400 px).
Breakpoints live in `lib/utils/breakpoints.dart`.

## Project structure
```
lib/
  main.dart                      app entry, theme
  models/product.dart            custom data class (+ copyWith, JSON)
  data/inventory_controller.dart ChangeNotifier with CRUD + persistence
  data/sample_data.dart          starting products
  utils/                         colors, breakpoints, formatting, CRUD flows
  screens/                       home_screen, product_detail_screen
  widgets/                       reusable custom widgets (card, stepper, form, sidebar...)
assets/images, assets/fonts      local images, Poppins + Lobster fonts
test/                            widget + CRUD unit tests
```

## Concepts map
| Concept | Where |
|---|---|
| AppBar, Scaffold | `home_screen.dart`, `product_detail_screen.dart` |
| Colors | `utils/app_colors.dart` |
| Fonts | `pubspec.yaml` (Poppins, Lobster) |
| Local / network images | `Image.asset` (logo, placeholder) / `Image.network` in `widgets/product_image.dart` |
| Container, Padding, Row, Column, Expanded | all widgets |
| Stateless vs Stateful | Stateless: `ProductCard`, `StockChip`... Stateful: `HomeScreen`, `ProductForm` |
| Custom class + data list | `models/product.dart`, `data/inventory_controller.dart` |
| Builder lists + cards | `SliverGrid` + `SliverChildBuilderDelegate`, `ListView.builder` in the sidebar |
| Extracting custom widgets | `lib/widgets/` |

Fonts: Poppins and Lobster are licensed under the SIL Open Font License.
