# Simple Flutter App

An interactive shopping list app built with Flutter that demonstrates stateful widgets and user interaction.

## Features

- Interactive shopping list with multiple products (Eggs, Flour, Chocolate chips)
- Tap items to toggle them in/out of your cart
- Visual feedback: items in cart are grayed out with strikethrough text
- Clean Material Design UI with AppBar

## How to Run

### PowerShell:

```powershell
cd "c:\Users\stephen.perelgut\CSD228\mobileapplicationLab1-main\SimpleFlutterApp"
flutter pub get
flutter run
```

### Choose a device:
When prompted, select your preferred platform:
- Chrome (web)
- Edge (web)
- Or any connected mobile device/emulator

## Project Structure

- `lib/main.dart` - Main application code with:
  - `Product` class - Data model for products
  - `ShoppingListItem` - Stateless widget for individual list items
  - `ShoppingList` - Stateful widget managing cart state
  - `main()` - App entry point

## Requirements

- Flutter SDK installed and on PATH
- Chrome or Edge browser for web deployment
- Use `flutter devices` to see all available target devices
