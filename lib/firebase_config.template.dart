import 'package:firebase_core/firebase_core.dart';

// Firebase configuration template
// Copy this file to firebase_config.dart and fill in your actual Firebase credentials
const firebaseConfig = FirebaseOptions(
  apiKey: "YOUR-API-KEY-HERE",
  authDomain: "YOUR-PROJECT-ID.firebaseapp.com",
  databaseURL: "https://YOUR-PROJECT-ID-default-rtdb.firebaseio.com",
  projectId: "YOUR-PROJECT-ID",
  storageBucket: "YOUR-PROJECT-ID.firebasestorage.app",
  messagingSenderId: "YOUR-MESSAGING-SENDER-ID",
  appId: "YOUR-APP-ID",
);
