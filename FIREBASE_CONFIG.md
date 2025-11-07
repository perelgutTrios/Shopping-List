# Firebase Configuration Setup

## Initial Setup

1. **Copy the template file:**
   ```powershell
   Copy-Item lib\firebase_config.template.dart lib\firebase_config.dart
   ```

2. **Get your Firebase credentials:**
   - Go to [Firebase Console](https://console.firebase.google.com/)
   - Select your project (shopping-list-8fde8)
   - Click the gear icon → Project Settings
   - Scroll down to "Your apps" section
   - Copy the Firebase configuration values

3. **Edit `lib/firebase_config.dart`** with your actual credentials

## Security Note

- `lib/firebase_config.dart` is in `.gitignore` and will NOT be committed to git
- This prevents exposing your Firebase API keys in version control
- Each developer needs to create their own `firebase_config.dart` file locally

## Firebase Security Rules

Remember to set up proper security rules in Firebase Console to restrict database access:

```json
{
  "rules": {
    ".read": "auth != null",
    ".write": "auth != null"
  }
}
```
