# Inventory Management (Flutter)

Beginner-friendly app that demonstrates core Flutter UI concepts.

## Setup (first time only)
This zip contains the Dart code, assets and fonts. Generate the platform folders (android/ios/web...) with:

```bash
cd inventory_management
flutter create . --project-name inventory_management
flutter pub get
flutter run
```
(`flutter create .` will NOT overwrite lib/, pubspec.yaml or assets.)

**Android release builds:** add `<uses-permission android:name="android.permission.INTERNET"/>` to `android/app/src/main/AndroidManifest.xml` so network images load.

## Where each concept lives
| Concept | File |
|---|---|
| AppBar, Scaffold, Padding, Row, Column, Expanded, ListView.builder | `lib/screens/home_screen.dart` |
| Colors | `lib/utils/app_colors.dart` |
| Fonts (Poppins, Lobster) | `pubspec.yaml`, used in `TextStyle(fontFamily: ...)` |
| Local image (`Image.asset`) | `home_screen.dart` (logo), `product_card.dart` (placeholder fallback) |
| Network image (`Image.network`) | `lib/widgets/product_card.dart` |
| Container | `lib/widgets/summary_card.dart`, `product_card.dart` |
| Stateless widgets | `section_header.dart`, `summary_card.dart`, `product_card.dart`, `main.dart` |
| Stateful widgets | `home_screen.dart`, `add_product_dialog.dart` |
| Custom class | `lib/models/product.dart` |
| Managing a data list | `lib/data/sample_data.dart` + `_products` in `home_screen.dart` |
| Cards + custom widgets | `lib/widgets/` |

Fonts: Poppins and Lobster are licensed under the SIL Open Font License.
