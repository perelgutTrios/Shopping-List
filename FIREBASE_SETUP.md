# Shared Shopping List - Firebase Setup

## Setting Up Firebase

To enable shared lists, you need to set up a Firebase project:

### 1. Create Firebase Project

1. Go to https://console.firebase.google.com/
2. Click "Add project"
3. Name it "Shopping-List" (or your preferred name)
4. Follow the setup wizard

### 2. Enable Realtime Database

1. In your Firebase console, go to "Realtime Database"
2. Click "Create Database"
3. Start in **test mode** (for development)
4. Note the database URL (e.g., `https://your-project-id-default-rtdb.firebaseio.com`)

### 3. Get Firebase Config

1. Go to Project Settings (gear icon)
2. Scroll down to "Your apps"
3. Click the Web icon `</>`
4. Register your app
5. Copy the Firebase configuration

### 4. Update lib/main.dart

Replace the placeholder Firebase config at the top of `lib/main.dart` with your actual values:

```dart
const firebaseConfig = FirebaseOptions(
  apiKey: "YOUR-API-KEY",
  authDomain: "your-app.firebaseapp.com",
  databaseURL: "https://your-app-default-rtdb.firebaseio.com",
  projectId: "your-project-id",
  storageBucket: "your-app.appspot.com",
  messagingSenderId: "123456789",
  appId: "1:123456789:web:abcdef123456",
);
```

### 5. Database Security Rules

For production, update your Firebase Realtime Database rules:

```json
{
  "rules": {
    "lists": {
      "$listId": {
        ".read": true,
        ".write": true
      }
    }
  }
}
```

**Note:** These rules allow anyone to read/write. For production, you should implement authentication.

## Features

### Local Lists
- Create a local shopping list that stays on your device only
- No Firebase configuration needed for local lists

### Shared Lists
- Create shared lists that sync across all devices
- Share via email link
- Real-time updates when anyone modifies the list
- Requires Firebase configuration

### How It Works

1. **On Startup**: You see a list of all your saved shared lists
2. **Create New**: Choose between local (device-only) or shared (synced)
3. **Share**: Click the share button to send an email invitation
4. **Sync**: All changes sync instantly via Firebase Realtime Database

## Running the App

```bash
flutter pub get
flutter run -d chrome
```

For deployment:

```bash
flutter build web --release --base-href "/Shopping-List/"
```
